library(RUnit)
#----------------------------------------------------------------------------------------------------
runTests <- function()
{
    test_expandAndRuleLineToDataFrame()
    test_expandOrRuleLineToDataFrame()
    test_expandSimpleRuleLineToDataFrame()
    test_lineToReactionDataFrame()
}
#----------------------------------------------------------------------------------------------------
expandAndRuleLineToDataFrame <- function(tbl.raw)
{   
    tbl.raw$geneReactionRule <- gsub("(", "", tbl.raw$geneReactionRule, fixed=TRUE)
    tbl.raw$geneReactionRule <- gsub(")", "", tbl.raw$geneReactionRule, fixed=TRUE)

    tbl.raw$geneReactionRule <- strsplit(tbl.raw$geneReactionRule, " and ")    

    tbl <- data.frame(matrix(nrow=length(tbl.raw$geneReactionRule[[1]]), ncol=2))
    colnames(tbl) <- c("reactionName", "geneReactionRule")

    tbl$reactionName <- tbl.raw$reactionName
    tbl$geneReactionRule <- tbl.raw$geneReactionRule[[1]]

    tbl
}#expandAndRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
expandOrRuleLineToDataFrame <- function(tbl.raw)
{
    tbl.raw$geneReactionRule <- gsub("(", "", tbl.raw$geneReactionRule, fixed=TRUE)
    tbl.raw$geneReactionRule <- gsub(")", "", tbl.raw$geneReactionRule, fixed=TRUE)

    tbl.raw$geneReactionRule <- strsplit(tbl.raw$geneReactionRule, " or ")    

    tbl <- data.frame(matrix(nrow=length(tbl.raw$geneReactionRule[[1]]), ncol=2))
    colnames(tbl) <- c("reactionName", "geneReactionRule")

    tbl$reactionName <- tbl.raw$reactionName
    tbl$geneReactionRule <- tbl.raw$geneReactionRule[[1]]

    tbl
}#expandOrRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
expandSimpleRuleLineToDataFrame <- function(tbl.raw)
{
    tbl.raw$geneReactionRule <- gsub("(", "", tbl.raw$geneReactionRule, fixed=TRUE)
    tbl.raw$geneReactionRule <- gsub(")", "", tbl.raw$geneReactionRule, fixed=TRUE)

    tbl <- data.frame(matrix(nrow=length(tbl.raw$geneReactionRule[[1]]), ncol=2))
    colnames(tbl) <- c("reactionName", "geneReactionRule")

    tbl$reactionName <- tbl.raw$reactionName
    tbl$geneReactionRule <- tbl.raw$geneReactionRule[[1]]

    tbl
}
#----------------------------------------------------------------------------------------------------e
test_expandAndRuleLineToDataFrame <- function()
{
    printf("--- test_expandAndRuleLineToDataFrame")
    tbl.raw <- data.frame(reactionName="rx1",
                          reactionID="ar",
                          geneReactionRule="gene1 and gene2 and gene 3")
    
    tbl <- expandAndRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 3)
}#test_expandAndRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
test_expandOrRuleLineToDataFrame <- function()
{
        printf("--- test_expandORRuleLineToDataFrame")
    tbl.raw <- data.frame(reactionName="rx1",
                          reactionID="ar",
                          geneReactionRule="gene1 or gene2 or gene 3")
    
    tbl <- expandOrRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 3)
}#test_expandOrRuleLineToDataFrame 
#----------------------------------------------------------------------------------------------------
test_expandSimpleRuleLineToDataFrame <- function()
{
        printf("--- test_expandSimpleRuleLineToDataFrame")
    tbl.raw <- data.frame(reactionName="rx1",
                          reactionID="ar",
                          geneReactionRule="gene1")
    
    tbl <- expandOrRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 1)
}#test_expandSimpleRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
lineToRule <- function(tbl.raw)
{
   is.and.rule <- grepl(" and ", tbl.raw$geneReactionRule)
   is.or.rule <- grepl(" or ", tbl.raw$geneReactionRule)

   if(is.and.rule == TRUE) {
       expandAndRuleLineToDataFrame(tbl.raw)
   } else if(is.or.rule == TRUE) {
       expandOrRuleLineToDataFrame(tbl.raw)
   } else {
       expandSimpleRuleLineToDataFrame(tbl.raw)
   }

} # lineToRule
#----------------------------------------------------------------------------------------------------
test_lineToReactionDataFrame <- function()
{
   printf("--- test_lineToReactionDataFrame")
   tbl.raw <- data.frame(reactionName=c("rx1", "rx2", "rx3"),
                         reactionID=c("ar", "br","cr"),
                         geneReactionRule=c("gene1", "gene2 or gene3", "gene4 and gene5 and gene6"),
                         stringsAsFactors=FALSE)

   tbl.out.1 <- lineToRule(tbl.raw[1,])
   checkEquals(nrow(tbl.out.1), 1)

   tbl.out.2 <- lineToRule(tbl.raw[2,])
   checkEquals(nrow(tbl.out.2), 2)

   tbl.out.3 <- lineToRule(tbl.raw[3,])
   checkEquals(nrow(tbl.out.3), 3)

} # test_lineToReactionDataFrame
#----------------------------------------------------------------------------------------------------
