library(RCyjs)
print(load("dataframe_07-10.RData"))
tbl$signature <- paste(tbl$a, tbl$b, sep=":")

g <- new("graphNEL", edgemode = "directed")
nodeDataDefaults(g, attr = "type") <- "undefined"
edgeDataDefaults(g, attr = "count") <- 0

all.nodes <- c(unique(c(tbl$a, tbl$b)))
duplicated.interactions <- which(duplicated(tbl$signature))
tbl.unique <- tbl[-duplicated.interactions,]

g <- graph::addNode(all.nodes, g)
g <- graph::addEdge(tbl.unique$a, tbl.unique$b, g)
g
rcy <- RCyjs()
setGraph(rcy, g)
layout(rcy, "cose")
layout(rcy, "cola")


tbl.counts <- as.data.frame(table(tbl$signature), stringsAsFactors=FALSE)
count.names <- tbl.counts$Var1
tokens <- strsplit(count.names, split=":")
tbl.x <- do.call(rbind, lapply(tokens, function(token.pair) data.frame(a=token.pair[1], b=token.pair[2], stringsAsFactors=FALSE)))
tbl.x$count <- tbl.counts$Freq
edgeData(g, tbl.x$a, tbl.x$b, attr="count") <- tbl.x$count
loadStyleFile(rcy, "style.js")


tbl.freq <- as.data.frame(table(tbl$signature))
head(tbl.freq[order(tbl.freq$Freq, decreasing=TRUE),], n=30)
