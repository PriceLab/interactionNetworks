#--------------------------------------------------------------------------------
to.dayNumber <- function(dayString)
{
    tokens <- strsplit(dayString, "-")[[1]];
    month <- as.integer(tokens[2])
    day <- as.integer(tokens[3])
    (month * 30) + day - 197

}#to.dayNumber
#--------------------------------------------------------------------------------
test_to.dayNumber <- function()
{
    checkEquals(to.dayNumber("2018-06-26"), 9)
    checkEquals(to.dayNumber("2018-07-04"), 17)
}#test_to.dayNumber
#--------------------------------------------------------------------------------
