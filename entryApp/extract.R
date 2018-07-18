                                        # for extracting new data into .RData files
path = "~/github/interactionNetworks/entryApp/data"

extract <- data.frame(matrix(ncol=7, nrow=0))
names <- c("date", "a", "b","type","startTime","duration","mode")
colnames(extract) <- names

file.name <- dir(path, pattern = ".RData")
print(file.name)
print(extract)
print(length(file.name))

extract <- function()
{
    for(i in 1:length(file.name)) {
        
        print(load(file.name[i]))
        #file.unload <- print(load(file.name))
        #file <- read.table(load(file.name[i]), header=TRUE, sep="\t", stringsAsFactors=FALSE)
        extract <- rbind(extract, newLine)
    }
    print(head(extract))
}
  

# my approach

directory = "~/github/interactionNetworks/entryApp/data"
file.names <- file.path(directory, dir(directory, pattern=".RData$"))

loadAndFix <- function (file.name){
    load(file.name)
    if(ncol(newLine) == 6)
        newLine$mode <- "inPerson"
    return(newLine)
    }

tbls.all <- lapply(file.names, loadAndFix)
tbl <- do.call(rbind, tbls.all)
dim(tbl)
