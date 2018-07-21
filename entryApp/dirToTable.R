library(RUnit)
source("organize.R")

tbl.master <- data.frame()
#--------------------------------------------------------------------------------#
runTests <- function()
{
    test_dirToTable()

} # runTests
#--------------------------------------------------------------------------------#
dirToTable <- function(dir, quiet=TRUE)
{
   if(!file.exists(dir))
       stop(sprintf("The directory %s does not exist.", dir))
   files <- grep(".RData", list.files(dir), value=TRUE)

   for(file in files){
       load(file.path(dir,file))
       tbl <- newLine
       if(!quiet)
           print(tbl)
       if(ncol(tbl) == 6)
           tbl$mode <- "inPerson"
       stopifnot(colnames(tbl) == c("date", "a", "b", "type", "startTime", "duration", "mode"))
       tbl.master <- rbind(tbl.master, tbl)
   } # for

   tbl <- fix(tbl.master)
    
   return(tbl)
   
} # dirToTable
#--------------------------------------------------------------------------------#
test_dirToTable <- function()
{
    printf("--- test_dirToTable")
    
    dir <- "data"
    tbl <- dirToTable(dir)
    checkTrue(is.data.frame(tbl))
    checkEquals(ncol(tbl), 7)
    
}# test_dirToTable
#--------------------------------------------------------------------------------#




