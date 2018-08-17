library(graph)
library(RCyjs)

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
two.random.people <- c("Audrey Clay-Streib", "Mukul Midha")
g.interactions <- addNode(two.random.people, g.interactions)
g.interactions <- addEdge(two.random.people[1], two.random.people[2], g.interactions)
addGraph(rcy, g.interactions)
