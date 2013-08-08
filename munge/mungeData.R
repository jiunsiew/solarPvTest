require(stringr)
require(reshape2)
require(plyr)
require(lubridate)

mungeData <- function(solarCsv){
    
    # postcode lat/long data
    # original code and post code lat/long data file taken from:
    # - http://informedguess.wordpress.com/2012/12/06/pollock-plot/ 
    # - http://blog.datalicious.com/free-download-all-australian-postcodes-geocod
    # - http://dl.dropbox.com/u/10822/Datalicious/All-Australian-Postcodes-Geocoded.zip
    postCodeData <- read.csv('H:\\R_tests\\solarPvTest\\data\\pc_full_lat_long.csv')
    postCodeData <- postCodeData[!duplicated(postCodeData$Pcode),]  # get rid of duplicates, 
    names(postCodeData)[1] <- "postCode"    # to enable joining later
    # cache('postCodeData') # run this once as it doesn't really change much
    
    
    #=========================================================
    # solar data
#     solarCsv <- c('H:\\R_tests\\solarPvTest\\data\\solarPV_2011_data_v201212.csv',   # 2011 data
#                   'H:\\R_tests\\solarPvTest\\data\\solarPV_2012_data_v201307.csv',   # 2012 data
#                   'H:\\R_tests\\solarPvTest\\data\\solarPV_2013_data_v201307.csv')   # 2013 data to date
    nCsv = length(solarCsv)
    
    solarData = list()
    
    for (iC in 1:nCsv){
        rawData = read.csv(solarCsv[iC])
        names(rawData)[1] <- "postCode"
        
        # clean data
        cleanData          <- melt(rawData, id.vars = "postCode")
        cleanData$variable <- paste0("1", cleanData$variable)           # create the date
        cleanData$date     <- dmy(str_sub(cleanData$variable, 1, 8))
        cleanData$type     <- str_sub(cleanData$variable, 10)           # date type (installed capacity or quantity)
        cleanData$variable <- NULL                                      # get rid of variable column
        cleanData          <- dcast(cleanData, postCode + date ~ type)  # rearrange columns
        
        # clean up column names
        names(cleanData)[c(3,4)] <- c("nInstallations", "capacity_Kw")
        
        solarData = rbind(solarData, cleanData)
    }
    
    #=========================================================
    # combine solar and lat/long data
    data = join(solarData, postCodeData, type="left", by="postCode")
    fid = paste0("./cache/solarData_", format(Sys.time(), "%Y-%m-%d"), ".Rdata")  # remove dates if there's version control
    save(data, file = fid)

}