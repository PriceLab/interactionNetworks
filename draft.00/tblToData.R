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
print(head(tbl.all))

tbl.all$mode <- "inPerson"
