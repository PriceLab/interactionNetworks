print(load("interaction_bundle-2018-07-19.RData")) #which ever bundle in current use

#ideal format for date yyyy-mm-dd

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
    tbl <- tbl[rev(order(tbl$date)),]
    return(tbl)
}
