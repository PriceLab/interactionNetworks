directory = "~/github/interactionNetworks/entryApp/data"
file.names <- file.path(directory, dir(directory, pattern=".RData$"))
filename <- sprintf("interaction_bundle-%s.RData", Sys.Date())
filename <- gsub(" ", "", filename, fixed = TRUE)

loadAndFix <- function (file.names){
    
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
    if(newLine$a == "Ethan Hamilton" && newLine$b == "Leroy Hood") {
         newLine <- NULL
	 }
  
    return(newLine)
    }

tbls.all <- lapply(file.names, loadAndFix)

tbl <- do.call(rbind, tbls.all)
dim(tbl)

save(tbl, file = filename)