library(shiny)
library(shinyTime)
library(shinythemes)
library(DT)

source("dirToTable.R")

#-------------------------------------------------------------------------------#

internList <- read.table("internList.csv", sep="\t", header=FALSE, fill=TRUE)
hsInternList <- read.table("hsInternList.csv", sep="\t", header=FALSE, fill=TRUE)
switchList <- internList
staffList <- read.table("isbAllStaff",header=FALSE, sep="\t", fill=TRUE)
dir <- "data"

tbl.master <- data.frame()
tbl.master <- dirToTable(dir)

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
                           "High School Intern" = "high"),
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
                tabPanel("Your Existing Network",
                         "Your network will display here... Soon!"),
                tabPanel("Tabular View",
                         DT::dataTableOutput("table"))
            )
        )
    )
    
)


server <- function(input,output, session) {

    output$table <- DT::renderDataTable(tbl.master)
    
    observeEvent(input$grade, {
        if(input$grade == "under"){
            switchList <- internList
        } else {
            switchList <- hsInternList
        }
        updateSelectInput(session, "name", choices = switchList[[1]])
        })
    
    observeEvent(input$to_current_time, {
        updateTimeInput(session, "time", value = Sys.time())
    })
    
    
    output$timeTag <- renderText({
        paste("Time:")
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
