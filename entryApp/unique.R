library(RUnit)
source("organize.R")
load("interaction_bundle-2018-07-19.RData")

tbl <- fix(tbl)

anon <- function(tbl)
{
    tbl <- transform(tbl,a=paste("ID",as.numeric(factor(a))))
    return(tbl)
}#anon

test_anon <- function() {
    print("---test_anon")
    tbl <- anon(tbl)
    checkTrue(tbl$a[1] == "ID 28")
    checkEquals(tbl$a[4], "ID 23")
}
