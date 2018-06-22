# display.R:  a minimal rcyjs script to display your interaction data
#----------------------------------------------------------------------------------------------------
library(RCyjs)
#----------------------------------------------------------------------------------------------------
tableToGraph <- function(tbl)
{
   stopifnot(colnames(tbl) == c("date", "a", "b", "type", "startTime", "duration"))

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

   g <- addEdge(tbl$a, tbl$b, g)
   edgeData(g, tbl$a, tbl$b, "edgeType") <- tbl$type

   # g <- graph::addEdge("A", "B", g)
   # g <- graph::addEdge("B", "C", g)
   # g <- graph::addEdge("C", "A", g)
   # edgeData(g, "A", "B", "edgeType") <- "phosphorylates"
   # edgeData(g, "B", "C", "edgeType") <- "synthetic lethal"
   # edgeData(g, "A", "B", "score") <- 35
   # edgeData(g, "B", "C", "score") <- -12

   g


} # tableToGraph
#----------------------------------------------------------------------------------------------------
run <- function()
{
  tbl.aishah <- read.table("AishahsInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  tbl.omar <- read.table("omarInteractionData.csv", sep=",", as.is=TRUE, header=TRUE)
  g <- tableToGraph(tbl.aishah)
  rcy <- RCyjs()
  setGraph(rcy, g)
  layout(rcy, "cose")
  loadStyleFile(rcy, "style.js")

} # run
#----------------------------------------------------------------------------------------------------
