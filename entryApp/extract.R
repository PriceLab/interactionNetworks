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

    return(newLine)
    }



fix <- function(tbl)
{
    for(i in 1:nrow(tbl)) {
        if(isTRUE(nchar(tbl$a[i]) == 0)){
            tbl <- tbl[-i,]
        }
    }
    
    for(i in 1:nrow(tbl)) {
        if(isTRUE(nchar(tbl$b[i]) == 0)){
            tbl <- tbl[-i,]
        }
    }
    
    for(i in 1:nrow(tbl)) {
        if(tbl$date[[i]] == "6-19")
            tbl$date[[i]] <- "2018-06-19"
        if(tbl$date[[i]] == "6-22")
            tbl$date[[i]] <- "2018-06-22"
        if(tbl$date[[i]] == "6-25")
            tbl$date[[i]] <- "2018-06-25"    
        if(tbl$date[[i]] == "6-26")
            tbl$date[[i]] <- "2018-06-26"
        
        if(grepl("06/", tbl$date[i]) == TRUE){
            day <- substr(tbl$date[i],4,5)
            tbl$date[[i]] <- sub(" ","",paste("2018-06-",day))
        }
        
        if(grepl("6/", tbl$date[i]) == TRUE){
            day <- substr(tbl$date[i],3,4)
            tbl$date[[i]] <- sub(" ","",paste("2018-06-",day)) 
        }
    }
    tbl <- tbl[order(tbl$date),]
    return(tbl)
}

tbl <- lapply(file.names, loadAndFix)
tbl <- do.call(rbind, tbl)
#tbl <- lapply(tbl, fix)

save(tbl, file = filename)
