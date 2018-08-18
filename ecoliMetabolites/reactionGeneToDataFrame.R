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
    tbl.raw$gene_reaction_rule <- gsub("(", "", tbl.raw$gene_reaction_rule, fixed=TRUE)
    tbl.raw$gene_reaction_rule <- gsub(")", "", tbl.raw$gene_reaction_rule, fixed=TRUE)

    tbl.raw$gene_reaction_rule <- strsplit(tbl.raw$gene_reaction_rule, " and ")    

    tbl <- data.frame(matrix(nrow=length(tbl.raw$gene_reaction_rule[[1]]), ncol=2))
    colnames(tbl) <- c("id", "gene_reaction_rule")

    tbl$id <- tbl.raw$id
    tbl$gene_reaction_rule <- tbl.raw$gene_reaction_rule[[1]]

    tbl
}#expandAndRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
expandOrRuleLineToDataFrame <- function(tbl.raw)
{
    tbl.raw$gene_reaction_rule <- gsub("(", "", tbl.raw$gene_reaction_rule, fixed=TRUE)
    tbl.raw$gene_reaction_rule <- gsub(")", "", tbl.raw$gene_reaction_rule, fixed=TRUE)

    tbl.raw$gene_reaction_rule <- strsplit(tbl.raw$gene_reaction_rule, " or ")    

    tbl <- data.frame(matrix(nrow=length(tbl.raw$gene_reaction_rule[[1]]), ncol=2))
    colnames(tbl) <- c("id", "gene_reaction_rule")

    tbl$id <- tbl.raw$id
    tbl$gene_reaction_rule <- tbl.raw$gene_reaction_rule[[1]]

    tbl
}#expandOrRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
expandSimpleRuleLineToDataFrame <- function(tbl.raw)
{
    tbl.raw$gene_reaction_rule <- gsub("(", "", tbl.raw$gene_reaction_rule, fixed=TRUE)
    tbl.raw$gene_reaction_rule <- gsub(")", "", tbl.raw$gene_reaction_rule, fixed=TRUE)

    tbl <- data.frame(matrix(nrow=length(tbl.raw$gene_reaction_rule[[1]]), ncol=2))
    colnames(tbl) <- c("id", "gene_reaction_rule")

    tbl$id <- tbl.raw$id
    tbl$gene_reaction_rule <- tbl.raw$gene_reaction_rule[[1]]

    tbl
}
#----------------------------------------------------------------------------------------------------e
test_expandAndRuleLineToDataFrame <- function()
{
    printf("--- test_expandAndRuleLineToDataFrame")
    tbl.raw <- data.frame(id="rx1",
                          name="ar",
                          gene_reaction_rule="gene1 and gene2 and gene 3")
    
    tbl <- expandAndRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 3)
}#test_expandAndRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
test_expandOrRuleLineToDataFrame <- function()
{
    printf("--- test_expandORRuleLineToDataFrame")
    tbl.raw <- data.frame(id="rx1",
                          name="ar",
                          gene_reaction_rule="gene1 or gene2 or gene 3")
    
    tbl <- expandOrRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 3)
}#test_expandOrRuleLineToDataFrame 
#----------------------------------------------------------------------------------------------------
test_expandSimpleRuleLineToDataFrame <- function()
{
    printf("--- test_expandSimpleRuleLineToDataFrame")
    tbl.raw <- data.frame(id="rx1",
                          name="ar",
                          gene_reaction_rule="gene1")
    
    tbl <- expandOrRuleLineToDataFrame(tbl.raw)
    checkEquals(nrow(tbl), 1)
}#test_expandSimpleRuleLineToDataFrame
#----------------------------------------------------------------------------------------------------
lineToRule <- function(tbl.raw)
{
   is.and.rule <- grepl(" and ", tbl.raw$gene_reaction_rule)
   is.or.rule <- grepl(" or ", tbl.raw$gene_reaction_rule)
browser()
   if(is.and.rule == TRUE) {
       expandAndRuleLineToDataFrame(tbl.raw)
   } else if(is.or.rule == TRUE) {
       expandOrRuleLineToDataFrame(tbl.raw)
   } else {
       expandSimpleRuleLineToDataFrame(tbl.raw)
   }

   tbl <- do.call(rbind, tbl)

   print(nrow(tbl))

} # lineToRule
#----------------------------------------------------------------------------------------------------
test_lineToReactionDataFrame <- function()
{
   printf("--- test_lineToReactionDataFrame")
   tbl.raw <- data.frame(id=c("rx1", "rx2", "rx3"),
                         name=c("ar", "br","cr"),
                         gene_reaction_rule=c("gene1", "gene2 or gene3", "gene4 and gene5 and gene6"),
                         stringsAsFactors=FALSE)

   tbl.out.1 <- lineToRule(tbl.raw[1,])
   checkEquals(nrow(tbl.out.1), 1)

   tbl.out.2 <- lineToRule(tbl.raw[2,])
   checkEquals(nrow(tbl.out.2), 2)

   tbl.out.3 <- lineToRule(tbl.raw[3,])
   checkEquals(nrow(tbl.out.3), 3)

   tbl.out <- lineToRule(tbl.raw)

} # test_lineToReactionDataFrame
#----------------------------------------------------------------------------------------------------
