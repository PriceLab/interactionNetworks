directory = "~/github/interactionNetworks/entryApp/data"
file.names <- file.path(directory, dir(directory, pattern=".RData$"))
filename <- sprintf("interaction_bundle-%s.RData", Sys.Date())
filename <- gsub(" ", "", filename, fixed = TRUE)
#--------------------------------------------------------------------------------
loadFiles <- function (file.names)
{ 
    load(file.names)
    
    if(ncol(newLine) == 6) {
    	 newLine$mode <- "inPerson"
         }
    if(ncol(newLine) ==8) {
         newLine$tpye <- NULL
	 }
    if(newLine$b == "Anna Hughes Hoge") {
         newLine$b <- "Anna Hoge"
	 }

    return(newLine)
}#loadFiles
#--------------------------------------------------------------------------------
extract <- function()
{
    tbl <- lapply(file.names, loadFiles)
    tbl <- do.call(rbind, tbl)

    save(tbl, file = filename)
}#extract
#--------------------------------------------------------------------------------
