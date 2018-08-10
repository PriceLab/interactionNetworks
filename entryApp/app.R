library(shiny)
library(shinyTime)
library(shinythemes)
library(DT)
library(ggplot2)


#source("dirToTable.R")
#source("extract.R")
source("hist.R")
source("organize.R")
source("unique.R")

#load("interaction_bundle-2018-07-19.RData")# delete late
#load("interaction_bundle-2018-07-23.RData")
#load("interaction_bundle-2018-07-24.RData")
#load("interaction_bundle-2018-07-27.RData")
#load("interaction_bundle-2018-07-30.RData")
#load("interaction_bundle-2018-08-01.RData")
#load("interaction_bundle-2018-08-03.RData")
#load("interaction_bundle-2018-08-07.RData")
#load("interaction_bundle-2018-08-08.RData")
load("interaction_bundle-2018-08-09.RData")



#-------------------------------------------------------------------------------#

internList <- read.table("internList.csv", sep="\t", header=FALSE, fill=TRUE)
hsInternList <- read.table("hsInternList.csv", sep="\t", header=FALSE, fill=TRUE)
otherList <- read.table("extraList.csv", sep="\t", header=FALSE, fill=TRUE)
switchList <- internList
staffList <- read.table("isbAllStaff",header=FALSE, sep="\t", fill=TRUE)
dir <- "data"

#tbl <- dirToTable(dir)
tbl <- fix(tbl)
tbl <- anon(tbl)

newLine <- ""

#-------------------------------------------------------------------------------#

ui <- fluidPage(
    
    theme = shinytheme("lumen"),
    tags$head(),
    headerPanel(
        tags$h2("Enter a new interaction"),
        windowTitle = "ISB Interactions"
    ),
    
    sidebarLayout(
        sidebarPanel(
            dateInput('date',
                      label = 'Date:',
                      value = NULL,
                      min = "2018-06-01",
                      max = "2018-08-31"),
            radioButtons("grade", NULL,
                         c("Undergradute Intern" = "under",
                           "High School Intern" = "high",
                           "Other" = "other"),
                         inline=TRUE),
            selectInput("name", "Who are you?",
                        choices = internList[[1]]),
            selectInput("partner", "Who did you interact with?",
                        choices = staffList[[1]]),
            selectInput("type", "Interaction Type:",
                        c("Administrative" = "adm",
                          "Programming" = "prg",
                          "Data" = "data",
                          "Biology" = "bio",
			  "Education" = "edu",
                          "Social" = "soc")),
            radioButtons("mode", "Interaction mode:",
                         c("In Person" = "inPerson",
                           "Email" = "email"),
                         inline=TRUE),
            textOutput("timeTag"),
            actionButton("to_current_time", "Current time"),
            timeInput("time", "", seconds=FALSE),
            sliderInput("dur", "Duration (minutes):",
                        min = 1, max = 120, value = 2),
            textOutput("count"),
            actionButton(inputId = "submit",
                         label = "Submit")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Project Summary",
                         includeHTML("projectSummary.html")),
                tabPanel("Histogram *NEW*",
                         plotOutput(outputId = "histPlot")),
                tabPanel("Table View *NEW*",
                         dataTableOutput("table"))
            )
        )
    )
    
)


server <- function(input,output, session) {

    output$table <- DT::renderDataTable(tbl,
                                        rownames=FALSE,
                                        options=list(
                                            columnDefs = list(
                                                list(visible=FALSE,targets=c(4,5,6)))))
    
    observeEvent(input$grade, {
        if(input$grade == "under"){
            switchList <- internList
        } else if(input$grade == "high") {
            switchList <- hsInternList
        } else {
            switchList <- otherList
        }
        updateSelectInput(session, "name", choices = switchList[[1]])
        })
    
    observeEvent(input$to_current_time, {
        updateTimeInput(session, "time", value = Sys.time())
    })
    
    
    output$timeTag <- renderText({
        paste("Time:")
    })

    output$histPlot <- renderPlot({
        logHist <- unlist(lapply(tbl$date, to.dayNumber))
        ggplot() + aes(logHist) + geom_histogram(binwidth=1, color="red", fill="green", alpha=0.2) + ggtitle("Interactions Logged") + theme(plot.title = element_text(hjust = 0.5)) + labs(y = "Frequency", x = "Days Since June 17th")
    })
    
    subCounter <- reactiveValues(countervalue = 0)
    
    output$count <- renderText({
        if(subCounter$countervalue == 1) {
            paste("You've submitted ", subCounter$countervalue, " interaction!")
        } else {
            paste("You've submitted ", subCounter$countervalue, " interactions!")
        }
    })
    
    observeEvent(input$submit, {
        newLine <- data.frame(
            "date" = as.character.Date(input$date),
            "a" = input$name,
            "b" = input$partner,
            "type" = input$type,
            "startTime" = as.character.Date(input$time),
            "duration" = input$dur,
            "mode" = input$mode,
            stringsAsFactors = FALSE)
        
        filename <- sprintf("%s/interaction-%s-%s.RData", dir,input$name,Sys.time())
        filename <- gsub(" ", "", filename, fixed = TRUE)
        save(newLine, file = filename)
        
        subCounter$countervalue <- subCounter$countervalue + 1
        print("Interaciton Logged.")
    })
    
}

#--------------------------------------------------------------------------------#

shinyOptions <- list()

if(Sys.info()[["nodename"]] == "trena.systemsbiology.net"){
    port <- 60013
    printf("running on trena, using port %d", port)
    shinyOptions <- list(host="0.0.0.0", port=port, launch.browser=FALSE)
}

app <- shinyApp(ui=ui,server=server, options=shinyOptions)

#--------------------------------------------------------------------------------#
