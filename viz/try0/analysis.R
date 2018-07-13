library(igraph)
library(RCyjs)

print(load("dataframe_07-10.RData"))
tbl$signature <- paste(tbl$a, tbl$b, sep=":")

gnel <- new("graphNEL", edgemode = "undirected") #only takes undirected edges

all.nodes <- c(unique(c(tbl$a, tbl$b)))
duplicated.interactions <- which(duplicated(tbl$signature))
tbl.unique <- tbl[-duplicated.interactions,]

gnel <- graph::addNode(all.nodes, gnel)
gnel <- graph::addEdge(tbl.unique$a, tbl.unique$b, gnel)
gi <- igraph.from.graphNEL(gnel, name = TRUE, weight = TRUE, unlist.attrs = TRUE)

community.newman <- function(gi)
{
    deg <- igraph::degree(gi)
    ec <- ecount(gi)
    B <- get.adjacency(gi) - outer(deg, deg, function(x,y) x*y/2/ec)
    diag(B) <- 0
    eigen(B)$vectors[,1]
} #community.newman


scale <- function(v, a, b)
{
    v <- v-min(v) ; v <- v/max(v) ; v <- v * (b-a) ; v+a
} #scale


run <- function()
{
    newm <- community.newman(gi)
    browser()
    V(gi)$color <- ifelse(newm < 0, "grey", "green")
    V(gi)$size <- scale(abs(newm), 15, 25)
    E(gi)$color <- "grey"
    E(gi)[ V(gi)[color=="grey"] %--% V(gi)[color=="green"] ]$color <- "red"
    
    plot(gi, layout=layout.kamada.kawai,
         vertex.color="a:color",
         vertex.size="a:size",
         edge.color="a:color")
}# run
#------------------------------------------------------------------------------------------

