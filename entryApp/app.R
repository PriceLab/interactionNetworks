#variables

#internList <- scan("internList.csv", sep=",", what=list('character'))
internList <- read.table("internList.csv", sep="\t", header=FALSE, fill=TRUE) #to add blank above list of names
staffList <- read.table("isbAllStaff",header=FALSE, sep="\t", fill=TRUE)
dataDir <- "data" #directory for data
newLine <- ""

library(shiny)
library(shinyTime)

ui <- fluidPage(
    tags$head(tags$style(".rightAlign{float:right;}")),
    headerPanel(
    tags$h2("Enter a new interaction"), windowTitle = "ISB Interactions"
    ),
    sidebarLayout(
        sidebarPanel(
            dateInput('date',
                      label = 'Date:',
                      value = NULL,
                      min = "2018-06-01",
                      max = "2018-08-31"),
            selectInput("name", "Who are you?",
                        choices = internList[[1]]),
            selectInput("partner", "Who did you interact with?",
                        choices = staffList[[1]]),
                                           
            selectInput("type", "Interaction Type:",
                        c("Administrative" = "adm",
                          "Programming" = "prg",
                          "Data" = "data",
                          "Biology" = "bio",
                          "Social" = "soc")),
            radioButtons("type2", "Was it...?",
               c("In Person" = "norm",
                 "Email" = "email")),
            actionButton("to_current_time", "Current time", class = 'rightAlign'),
            timeInput("time", "Time:", seconds=FALSE),
            #textOutput("sysTime"),
            sliderInput("dur", "Duration (minutes):", min = 1, max = 120, value = 2),
            textOutput("count"),
            actionButton(inputId = "submit",
                         label = "Submit")
            ),
        mainPanel(
            tabsetPanel(
                tabPanel("Project Summary", includeHTML("projectSummary.html")),
                tabPanel("Your Existing Network", "Your network will display here"),
                                        #img(src="network.png", height=450, width=750),
                tabPanel("Tabular View", tableOutput("table"))
            )
        )
    )
)


server <- function(input,output, session) {

    observeEvent(input$to_current_time, {
        updateTimeInput(session, "time", value = Sys.time())
    })

    output$sysTime <- renderText({
        paste(Sys.time())
    })
    
    subCounter <- reactiveValues(countervalue = 0)
    
    output$count <- renderText({
        if(subCounter$countervalue == 1) {
            paste("You've submitted ", subCounter$countervalue, " interaction!")
        } else {
            paste("You've submitted ", subCounter$countervalue, " interactions!")
        }
    })
    
    observeEvent(input$submit, {newLine <- data.frame("date" = as.character.Date(input$date),
                                                      "a" = input$name,
                                                      "b" = input$partner,
                                                      "type" = input$type,
                                                      "startTime" = as.character.Date(input$time),
                                                      "duration" = input$dur,
                                                      stringsAsFactors = FALSE)

                                                      if(input$type2 == "norm"){
                                                          filename <- sprintf("%s/interaction-%s-%s.RData", dataDir,input$name,Sys.time())
                                                      } else {
                                                          filename <- sprintf("%s/emailInteraction-%s-%s.RData", dataDir,input$name,Sys.time())
                                                      }
                                                      
                                                      filename <- gsub(" ", "", filename, fixed = TRUE)
                                                      save(newLine, file = filename)

                                                      subCounter$countervalue <- subCounter$countervalue + 1
                                                      print("Interaciton Logged.")
    })
}

shinyOptions <- list()

if(Sys.info()[["nodename"]] == "trena.systemsbiology.net"){
    port <- 60020
    printf("running on trena, using port %d", port)
    shinyOptions <- list(host="0.0.0.0", port=port, launch.browser=FALSE)
}

app <- shinyApp(ui=ui,server=server, options=shinyOptions)

say it ain't so

