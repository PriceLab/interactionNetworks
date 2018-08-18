library(graph)
library(RCyjs)

load("interaction_bundle-2018-08-16.RData")

tbl.staff <- read.table("isbStaffList.txt", sep="\t", as.is=TRUE)
colnames(tbl.staff) <- c("name", "title")
subset(tbl.staff, title=="")

tbl.groups <- read.table("groups.txt", sep="\t", as.is=TRUE)
colnames(tbl.groups) <- "group"

dim(tbl.staff)
dim(tbl.groups)
tbl <- cbind(tbl.staff, tbl.groups)

lab.groups <- c("Baliga", "Shmulevich", "Subramanian", "Hood-Price", "Ranish", "Huang", "Moritz", "Gibbons", "Heath", "Hadlock")

tbl <- subset(tbl, group %in% lab.groups)
dim(tbl)

length(lab.groups)
people <-tbl$name
length(people)
length(intersect(lab.groups, people))

all.nodes <- c(people, lab.groups)

g <- graphNEL(edgemode="directed")

g <- addNode(all.nodes, g)
g <- addEdge(tbl$name, tbl$group, g)

rcy <- RCyjs(title="ISB groups")
setGraph(rcy, g)
layout(rcy, "cola")
layout(rcy, "cose")


g.interactions <- graphNEL(edgemode="directed")
interaction.nodes <- c(unique(c(tbl$a, tbl$b)))
duplicated.interactions <- which(duplicated(tbl$signature))
tbl.unique <- tbl[-duplicated.interactions,]

g.interactions <- addNode(interaction.nodes, g.interactions)
g.interactions <- graph::addEdge(tbl.unique$a, tbl.unique$b, g.interactions)

addGraph(rcy, g.interactions)

edgeDataDefaults(g, attr="type") <- "undefined"
edgeData(g, tbl.unique$a, tbl.unique$b, attr="type") <- "interaction"

loadStyleFile(rcy, "style.js")
