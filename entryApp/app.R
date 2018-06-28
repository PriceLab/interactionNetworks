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
                                choices = internList[[1]],
				selected = "Ethan Hamilton"),
                    selectInput("partner", "Who did you interact with?",
                                choices = staffList[[1]],
				selected = "Leroy Hood"),
                    selectInput("type", "Interaction Type:",
                                c("Administrative" = "adm",
                                  "Programming" = "prg",
                                  "Data" = "data",
                                  "Biology" = "bio",
                                  "Consulting" = "con",
                                  "Social" = "soc")),
                    timeInput("time", "Time:", value = Sys.time()),
                    numericInput("dur", "Duration (min):", 2, min = 1),
                    actionButton(inputId = "submit",
                                 label = "Submit"),
			#img(src="isb.png", height=20, width=20),

                    tableOutput("data")
                  ),
                  mainPanel(
                    tabsetPanel(
		        tabPanel("Project Summary", includeHTML("projectSummary.html")),
			tabPanel("Your Existing Network", verbatimTextOutput("Your network will display here")),
                                 # img(src="network.png", height=450, width=750)),
        		tabPanel("Tabular View", tableOutput("table"))
      			)
                  )
                )
                )


server <- function(input,output) {

  observeEvent(input$submit, {newLine <- data.frame("date" = as.character.Date(input$date),
    		      		"a" = input$name,
				"b" = input$partner,
				"type" = input$type,
				"startTime" = as.character.Date(input$time),
				"duration" = input$dur,
				stringsAsFactors = FALSE)

			print(newLine)
        		filename <- sprintf("%s/interaction-%s-%s.RData", dataDir,input$name,Sys.time())
			filename <- gsub(" ", "", filename, fixed = TRUE)
			save(newLine, file = filename)

			print("DONE")
  })
}

shinyOptions <- list()
if(Sys.info()[["nodename"]] == "trena.systemsbiology.net"){
   print("running on trena, using port 60013")
   shinyOptions <- list(host="0.0.0.0", port=60013, launch.browser=FALSE)
   }

app <- shinyApp(ui=ui,server=server, options=shinyOptions)


