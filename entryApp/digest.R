





files <- grep(".RData", list.files("."), value=TRUE)

tbl.master <- data.frame()
for(file in head(files)){
   load(file)
   tbl <- newLine
   if(ncol(tbl) == 6)
       tbl$mode <- "inPerson"
   stopifnot(colnames(tbl) == c("date", "a", "b", "type", "startTime", "duration", "mode"))
   printf("%s: %d, %d", file, nrow(tbl), ncol(tbl))
   tbl.master <- rbind(tbl.master, tbl)
   }
