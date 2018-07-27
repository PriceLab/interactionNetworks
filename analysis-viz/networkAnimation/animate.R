library(RCyjs)
#------------------------------------------------------------------------------------------------------------------------
stopifnot(packageVersion("RCyjs") >= "2.3.9")
if(!exists("tbl"))
   load("interaction_bundle_dayNumber.RData")
#------------------------------------------------------------------------------------------------------------------------
buildGraph <- function(tbl)
{
   all.nodes <- c(sort(unique(c(tbl$a, tbl$b))), "INFO")

   g <- graphNEL(nodes=all.nodes, edgemode="undirected")

   edgeDataDefaults(g, attr = "edgeType") <- "undefined"
   nodeDataDefaults(g, attr = "type") <- "person"
   nodeDataDefaults(g, attr = "active") <- 1
   nodeDataDefaults(g, attr = "week") <- ""

   nodeData(g, "INFO", attr="type") <- "informationalNode"

   g <- addEdge(tbl$a, tbl$b, g)
   edgeData(g, tbl$a, tbl$b, "edgeType") <- tbl$type

   rcy <- RCyjs(10000:10100, g)
   setGraph(rcy, g)

   list(rcy=rcy, g=g)

} # buildGraph
#------------------------------------------------------------------------------------------------------------------------
run <- function()
{
   x <- buildGraph(tbl)
   rcy <- x$rcy
   g <- x$g
   loadStyleFile(rcy, "style.js")
   length(nodes(g))
   layout(rcy, "cola")
   Sys.sleep(10)
   tbl.pos <- getPosition(rcy)
      # put the informational node at the top right of the current layout
   top.right.x <- max(tbl.pos$x)
   top.right.y <- min(tbl.pos$y)
   setPosition(rcy, data.frame(id="INFO", x=top.right.x, y=top.right.y, stringsAsFactors=FALSE))

   fivenum(tbl$dayNumber)  # 1 18 24 29 37

   date.boundaries <- as.integer(seq(from=1, length.out=8, to = 37))  # 1  6 11 16 21 26 31 37

   for(i in seq_len(7)) { # length(date.boundaries) -1
      start.day <- date.boundaries[i]
      end.day  <- date.boundaries[i+1]
      tbl.active <- subset(tbl, dayNumber >= start.day & dayNumber < end.day)
      actives <- c(unique(c(tbl.active$a, tbl.active$b)), "INFO")
      inactives <- setdiff(nodes(g), actives)
      printf("active: %d   inactive: %d", length(actives), length(inactives))
      setNodeAttributes(rcy, "week", rep("INFO", 2), rep(sprintf("Week %d", i), 2))
      setNodeAttributes(rcy, "active", actives, rep(1, length(actives)))
      setNodeAttributes(rcy, "active", inactives, rep(0, length(inactives)))
      redraw(rcy)
      }

} # run
#------------------------------------------------------------------------------------------------------------------------
