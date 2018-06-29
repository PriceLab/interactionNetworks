#variables

internList <- scan("internList.csv", sep=",", what=list('character'))
staffList <- read.table("isbAllStaff",header=FALSE, sep="\t")
dataDir <- "data" #directory for data
newLine <- ""

library(shiny)
library(shinyTime)

ui <- fluidPage(headerPanel(
                tags$h2("Enter a new interaction"), windowTitle = "ISB Interactions"
                ),
                sidebarLayout(
                  sidebarPanel(
                    dateInput('date',
                              label = 'Date:',
                              value = Sys.Date()),
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
                    timeInput("time", "Time:", value = Sys.time(), seconds=FALSE),
                    sliderInput("dur", "Duration (minutes):", min = 1, max = 120, value = 2),
                    actionButton(inputId = "submit",
                                 label = "Submit"),
                    tags$br(),
                    textOutput("count"),
   			#img(src="isb.png", height=20, width=20),

                    tableOutput("data")
                  ),
                  mainPanel(
                    tabsetPanel(
		        tabPanel("Project Summary", includeHTML("projectSummary.html")),
			tabPanel("Your Existing Network", verbatimTextOutput("Your network will display here")),
                                 #img(src="network.png", height=450, width=750),
        		tabPanel("Tabular View", tableOutput("table"))
      			)
                  )
                )
                )


server <- function(input,output) {

    subCounter <- reactiveValues(countervalue = 0)

    observeEvent(input$submit, {
      subCounter$countervalue <- subCounter$countervalue + 1
    })
u
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

        		filename <- sprintf("%s/interaction-%s-%s.RData", dataDir,input$name,Sys.time())
			filename <- gsub(" ", "", filename, fixed = TRUE)
                        save(newLine, file = filename)

                        print("Interaciton Logged.")
  })
}

shinyOptions <- list()
if(Sys.info()[["nodename"]] == "trena.systemsbiology.net"){
   print("running on trena, using port 60013")
   shinyOptions <- list(host="0.0.0.0", port=60013, launch.browser=FALSE)
   }

app <- shinyApp(ui=ui,server=server, options=shinyOptions)


