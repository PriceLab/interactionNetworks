# display.R:  a minimal rcyjs script to display your interaction data
#----------------------------------------------------------------------------------------------------
library(RCyjs)
#----------------------------------------------------------------------------------------------------
tableToGraph <- function(tbl)
{
   stopifnot(colnames(tbl) == c("date", "a", "b", "type", "startTime", "duration","mode"))

   g <-graphNEL(edgemode = "directed")

   nodeDataDefaults(g, attr = "type") <- "undefined"
   nodeDataDefaults(g, attr = "name") <- "undefined"
   nodeDataDefaults(g, attr = "employmentCategory") <- "staff"
   nodeDataDefaults(g, attr = "interactionCount") <- 0

   edgeDataDefaults(g, attr = "edgeType") <- "undefined"
   edgeDataDefaults(g, attr = "score") <- 0
   edgeDataDefaults(g, attr = "misc") <- "default misc"

   people <- unique(c(tbl$a, tbl$b))
   g <- addNode(people, g)
   nodeData(g, people, "name") <- people

      # at present, all of the people in the "a" column are interns
      # extract these, assign their employmentCategory appropriately
   interns <- unique(tbl$a)
   nodeData(g, interns, "employmentCategory") <- "intern"

   g <- addEdge(tbl$a, tbl$b, g)
   edgeData(g, tbl$a, tbl$b, "edgeType") <- tbl$type

   g

} # tableToGraph
#----------------------------------------------------------------------------------------------------
run <- function()
{
  tbl.aishah <- read.table("AishahsInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.omar <- read.table("omarInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)

  tbl.anna <- read.table("annaInteractionLog.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.ana <- read.table("anaInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.brian <- read.table("brianInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.ioanna <- read.table("ioannaInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.noah <- read.table("noahInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)

  tbl.1 <- rbind(tbl.omar,tbl.aishah)
  tbl.2 <- rbind(tbl.1,tbl.anna)
  tbl.3 <- rbind(tbl.2,tbl.ana)
  tbl.4 <- rbind(tbl.3,tbl.brian)
  tbl.5 <- rbind(tbl.4,tbl.ioanna)
  tbl.all <- rbind(tbl.5,tbl.noah)

  g <- tableToGraph(tbl.all)

  rcy <- RCyjs()
  setGraph(rcy, g)
  layout(rcy, "cose")
  loadStyleFile(rcy, "style.js")

} # run
#----------------------------------------------------------------------------------------------------
