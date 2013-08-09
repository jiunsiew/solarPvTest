# main analysis file
# 
# turn of all project template options

rm(list = ls())

require(stringr)
require(reshape2)
require(plyr)
require(lubridate)
require(ggplot2)

# user defined parameters
updateData <- TRUE   # explicitly update data
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
# some totals/avgs by state, month year
data$year <- year(data$date)
data$month <- month(data$date)

totals <- ddply(data, c("State","year", "month"), 
                summarise, 
                totalInstallations = sum(nInstallations), 
                totalCapacity = sum(capacity_Kw),
                avgSize = sum(capacity_Kw)/sum(nInstallations))
totals$date <- dmy(paste0("1/", totalInstallations$month, "/", totalInstallations$year))

#=========================================
# plots
# 
qplot(date, totalInstallations, data = totals, geom = "line", facets = ~State, main = "Total Installations")
qplot(date, totalCapacity, data = totals, geom = "line", facets = ~State, main = "Total Capacity (kW)")
qplot(date, avgSize, data = totals, geom = "line", facets = ~State, main = "Average Size") + ylim(0,5)

