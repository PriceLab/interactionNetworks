library(RCyjs)
library(igraph)
library(RUnit)
source("analysis.R")
source("organize.R")
source("sepDate.R")
#source("extract.R")
#--------------------------------------------------------------------------------
runTests <- function()
{
    test_fix()
    test_s.date_firstWeek()
    test_s.date_secondWeek()
    test_community.newman()
}#runTests
#--------------------------------------------------------------------------------
