#--------------------------------------------------------------------------------
anon <- function(tbl)
{
    tbl <- transform(tbl,a=paste("ID",as.numeric(factor(a))))
    return(tbl)
}#anon
#--------------------------------------------------------------------------------
test_anon <- function() {
    print("---test_anon")
    load("interaction_bundle-2018-07-19.RData")
    tbl <- fix(tbl)
    
    tbl <- anon(tbl)
    checkTrue(tbl$a[1] == "ID 23")
    checkEquals(tbl$a[4], "ID 1")
}#test_anon
#--------------------------------------------------------------------------------
