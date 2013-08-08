# main analysis file
# 
# turn of all project template options

rm(list = ls())

require(stringr)
require(reshape2)
require(plyr)
require(lubridate)

# user defined parameters
updateData <- FALSE   # explicitly update data
solarCsv   <- c('./data/solarPV_2011_data_v201212.csv',   # 2011 data
                './data/solarPV_2012_data_v201307.csv',   # 2012 data
                './data/solarPV_2013_data_v201307.csv')   # 2013 data to date

#=========================================
# get data
if (updateData){
    source(".//munge//mungeData.R")
    data <- mungeData(solarCsv)
} else{
    fid = list.files("./cache", pattern = "solarData_", full.names=T)
    load(fid[length(fid)])
}

#=========================================
# analysis
# 
# sum by year
data$year <- year(data$date)
data$month <- month(data$date)

totalInstallations <- ddply(data, c("year", "month"), summarise, total = sum(nInstallations))

#=========================================
# plots
# 
