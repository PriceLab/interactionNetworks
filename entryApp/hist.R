library(RUnit)
source("organize.R")

load("interaction_bundle-2018-07-19.RData") #which ever bundle in current use

tbl <- fix(tbl)

to.dayNumber <- function(dayString)
{
    tokens <- strsplit(dayString, "-")[[1]];
    month <- as.integer(tokens[2])
    day <- as.integer(tokens[3])
    (month * 30) + day - 197

}

test_to.dayNumber <- function()
{
   checkEquals(to.dayNumber("2018-06-26"), 206)
   checkEquals(to.dayNumber("2018-07-04"), 214)
}

#logHist <- unlist(lapply(tbl$date, to.dayNumber))
#hist(logHist, xlab="Days into Project", breaks=20, main="Interactions Logged Per Week")


