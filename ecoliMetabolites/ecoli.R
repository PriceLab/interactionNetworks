library(jsonlite)
library(igraph)
library(graph)
library(RCyjs)
library(rlist)

source("reactionGeneToDataFrame.R")

vec <- ""
#--------------------------------------------------------------------------------
json_file <- "e_coli_core.json"
tbl <- fromJSON(json_file, flatten=TRUE)

print(length(tbl$genes$id))
if(length(tbl$genes$id) == 0)
    return("ecoli data not found")

gnel <- new("graphNEL", edgemode="undirected")

metaboliteNodes <- c(tbl$metabolites$id)
reactionNodes <- c(tbl$reactions$id)
geneNodes <- c(tbl$genes$id)

tbl.rx.ids <- tbl$reactions$id
tbl.rx.ids.TMP <- list()

reactionGenes_removeOR <- strsplit(tbl$reactions$gene_reaction_rule, " or ")

for(i in 1:length(tbl.rx.ids)) {
    if(length(reactionGenes_removeOR[[i]]) == 2) {
        tbl.rx.ids.TMP <- list.append(tbl.rx.ids.TMP, tbl.rx.ids[i], tbl.rx.ids[i])
    } else if(length(reactionGenes_removeOR[[i]]) == 3){
        tbl.rx.ids.TMP <- list.append(tbl.rx.ids.TMP, tbl.rx.ids[i], tbl.rx.ids[i], tbl.rx.ids[i])
    } else if(length(reactionGenes_removeOR[[i]]) == 4) {
        tbl.rx.ids.TMP <- list.append(tbl.rx.ids.TMP, tbl.rx.ids[i], tbl.rx.ids[i], tbl.rx.ids[i], tbl.rx.ids[i])
    }else {
        tbl.rx.ids.TMP <- list.append(tbl.rx.ids.TMP, tbl.rx.ids[i])
    }
} # for loop

print(length(tbl.rx.ids.TMP))

reactionGenes <- unlist(strsplit(unlist(reactionGenes_removeOR), " and "))

# 174 genes for 95 reactions

gnel <- graph::addNode(metaboliteNodes, gnel)
gnel <- graph::addNode(reactionNodes, gnel)
gnel <- graph::addNode(geneNodes, gnel)

nodeDataDefaults(gnel, attr="nodeType") <- "undefined"
edgeDataDefaults(gnel, attr="edgeType") <- "undefined"

nodeData(gnel, tbl$metabolites$id, attr="nodeType") <- "metabolite"
nodeData(gnel, tbl$reaction$id, attr="nodeType") <- "reaction"
nodeData(gnel, tbl$gene$id, attr="nodeType") <- "gene"

gnel

rcy <- RCyjs()
setGraph(rcy, gnel)

loadStyleFile(rcy, "style.js")
#--------------------------------------------------------------------------------
ecoli_data_to_graphNEL <- function () #will be useful, code above
{
    tbl <- ecoli_dataExtract()
        
    print(length(tbl$genes$id))
    if(length(tbl$genes$id) == 0)
        return("ecoli data not found")
    
    gnel <- new("graphNEL", edgemode="undirected")
        
    metaboliteNodes <- c(tbl$metabolites$id)
    reactionNodes <- c(tbl$reactions$id)
    geneNodes <- c(tbl$genes$id)

    gnel <- graph::addNode(metaboliteNodes, gnel)
    gnel <- graph::addNode(reactionNodes, gnel)
    gnel <- graph::addNode(geneNodes, gnel)

    nodeDataDefaults(gnel, attr="nodeType") <- "undefined"
    edgeDataDefaults(gnel, attr="edgeType") <- "undefined"

    nodeData(gnel, tbl$metabolites$id, attr="nodeType") <- "metabolite"
    nodeData(gnel, tbl$reaction$id, attr="nodeType") <- "reaction"
    nodeData(gnel, tbl$gene$id, attr="nodeType") <- "gene"

#    edgeData(gnel, 

    gnel

    rcy <- RCyjs()
    setGraph(rcy, gnel)
    Sys.sleep(3)
    layout(rcy, "grid")
    
}#ecoli_data_to_graphNEL
#--------------------------------------------------------------------------------
createTestiGraph <- function(nodeCount, edgeCount)
{
    elementCount <- nodeCount^2;
    vec <- rep(0, elementCount)

    set.seed(13);
    vec[sample(1:elementCount, edgeCount)] <- 1
    mtx <- matrix(vec, nrow=nodeCount)

    gi <- graph_from_adjacency_matrix(mtx)
    g <- igraph.to.graphNEL(gi)
    edgeDataDefaults(g, attr="edgeType") <- "testEdges"
    nodeDataDefaults(g, attr="nodeType") <- "testNodes"

    gi
}#creatTestiGraph
#--------------------------------------------------------------------------------
igraphToJSON <- function(gi) #referenced BiocGraphToCytoscapeJSON
{
    if(length(V(gi)) == 0)
        return("{}")

    nodeCount <- length(V(gi))
    if('name'%in% list.vertex.attributes(gi)){
        V(gi)$id <- V(gi)$name
    } else {
        V(gi)$id <- as.character(c(1:nodeCount))
    }
    
    nodes <- V(gi)
    nodesList <- list()
    
    vector.count <- 10 * (length(V(gi)) + length(E(gi)))
    vec <- vector(mode="character", length=vector.count)
    i <- 1;

    vec[i] <- '{"elements": {"nodes": ['; i <- i + 1;
    nodes <- V(gi)
    edgeNames <- as.data.frame(as_edgelist(gi))
    edgeNames <- paste(edgeNames$V1, edgeNames$V2)
    edgeNames <- sub(" ", "->", edgeNames)
    edges <- strsplit(edgeNames, " ")
    names(edges) <- edgeNames

    noa.names <- names(graph::nodeDataDefaults(gi))
    eda.names <- names(graph::edgeDataDefaults(gi))
    nodeCount <- length(nodes)
    edgeCount <- length(edgeNames)
    
}#igraphToJSON
#--------------------------------------------------------------------------------
graphToJSON <- function(g)
{
   if(length(nodes(g)) == 0)
      return ("{}")

       # allocate more character vectors that we could ever need; unused are deleted at conclusion

    vector.count <- 10 * (length(edgeNames(g)) + length (nodes(g)))
    vec <- vector(mode="character", length=vector.count)
    i <- 1;

    vec[i] <- '{"elements": {"nodes": ['; i <- i + 1;
    nodes <- nodes(g)
    edgeNames <- edgeNames(g)
    edges <- strsplit(edgeNames, "~")  # a list of pairs
    edgeNames <- sub("~", "->", edgeNames)
    names(edges) <- edgeNames

    noa.names <- names(graph::nodeDataDefaults(g))
    eda.names <- names(graph::edgeDataDefaults(g))
    nodeCount <- length(nodes)
    edgeCount <- length(edgeNames)

    for(n in 1:nodeCount){
       node <- nodes[n]
       vec[i] <- '{"data": '; i <- i + 1
       nodeList <- list(id = node)
       this.nodes.data <- graph::nodeData(g, node)[[1]]
       if(length(this.nodes.data) > 0)
          nodeList <- c(nodeList, this.nodes.data)
       nodeList.json <- toJSON(nodeList, auto_unbox=TRUE)
       vec[i] <- nodeList.json; i <- i + 1
       if(all(c("xPos", "yPos") %in% names(graph::nodeDataDefaults(g)))){
          position.markup <- sprintf(', "position": {"x": %f, "y": %f}',
                                     graph::nodeData(g, node, "xPos")[[1]],
                                     graph::nodeData(g, node, "yPos")[[1]])
          vec[i] <- position.markup
          i <- i + 1
          }
        if(n != nodeCount){
           vec [i] <- "},"; i <- i + 1 # sprintf("%s},", x)  # another node coming, add a comma
           }
       } # for n

    vec [i] <- "}]"; i <- i + 1  # close off the last node, the node array ], the nodes element }

    if(edgeCount > 0){
       vec[i] <- ', "edges": [' ; i <- i + 1
       for(e in seq_len(edgeCount)) {
          vec[i] <- '{"data": '; i <- i + 1
          edgeName <- edgeNames[e]
          edge <- edges[[e]]
          sourceNode <- edge[[1]]
          targetNode <- edge[[2]]
          edgeList <- list(id=edgeName, source=sourceNode, target=targetNode)
          this.edges.data <- edgeData(g, sourceNode, targetNode)[[1]]
          if(length(this.edges.data) > 0)
             edgeList <- c(edgeList, this.edges.data)
          edgeList.json <- toJSON(edgeList, auto_unbox=TRUE)
          vec[i] <- edgeList.json; i <- i + 1
          if(e != edgeCount){          # add a comma, ready for the next edge element
             vec [i] <- '},'; i <- i + 1
             }
          } # for e
      vec [i] <- "}]"; i <- i + 1
      } # if edgeCount > 0

   vec [i] <- "}"  # close the edges object
   i <- i + 1;
   vec [i] <- "}"  # close the elements object
   vec.trimmed <- vec [which(vec != "")]
   #printf("%d strings used in constructing json", length(vec.trimmed))
   paste0(vec.trimmed, collapse=" ")

} # graphToJSON
#------------------------------------------------------------------------------------------------------------------------
