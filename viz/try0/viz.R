library(RCyjs)
library(igraph)
source("analysis.R")
print(load("dataframe_07-10.RData"))
print(load("interaction-bundle.RData"))

                                        #hack
newLine$tpye <- NULL
tbl <- rbind(tbl, newLine)
tbl$signature <- paste(tbl$a, tbl$b, sep=":")

gnel <- new("graphNEL", edgemode = "undirected")
#gnel <- new("graphNEL", edgemode = "directed")

all.nodes <- c(unique(c(tbl$a, tbl$b)))
duplicated.interactions <- which(duplicated(tbl$signature))
tbl.unique <- tbl[-duplicated.interactions,]

gnel <- graph::addNode(all.nodes, gnel)
gnel <- graph::addEdge(tbl.unique$a, tbl.unique$b, gnel)
gi <- igraph.from.graphNEL(gnel, name = TRUE, weight = TRUE, unlist.attrs = TRUE)
newman <- community.newman(gi)
print(head(newman))

nodeDataDefaults(gnel, attr = "type") <- "undefined"
nodeDataDefaults(gnel, attr="newman") <- 0
edgeDataDefaults(gnel, attr = "count") <- 0

nodeData(gnel, nodes(gnel), attr="newman") <- newman

gnel

rcy <- RCyjs()
setGraph(rcy, gnel)
layout(rcy, "cose")
layout(rcy, "cola")
#layout(rcy, "circle")


tbl.counts <- as.data.frame(table(tbl$signature), stringsAsFactors=FALSE)
count.names <- tbl.counts$Var1
tokens <- strsplit(count.names, split=":")
tbl.x <- do.call(rbind, lapply(tokens, function(token.pair) data.frame(a=token.pair[1], b=token.pair[2], stringsAsFactors=FALSE)))
tbl.x$count <- tbl.counts$Freq
edgeData(gnel, tbl.x$a, tbl.x$b, attr="count") <- tbl.x$count
loadStyleFile(rcy, "style.js")
#loadStyleFile(rcy, "updateStyle.js")


tbl.freq <- as.data.frame(table(tbl$signature))
head(tbl.freq[order(tbl.freq$Freq, decreasing=TRUE),], n=30)
