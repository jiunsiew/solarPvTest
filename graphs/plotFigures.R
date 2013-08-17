# plots

require(ggplot2)
require(ggmap)

#=========================================
# plots
# 
qplot(date, totalInstallations, data = totals, geom = "line", facets = ~State, main = "Total Installations")
qplot(date, totalCapacity, data = totals, geom = "line", facets = ~State, main = "Total Capacity (kW)")
qplot(date, avgSize, data = totals, geom = "line", facets = ~State, main = "Average Size") + ylim(0,5)

#=========================================
# maps
# stopped here: need to figure out how to plot points and make dots of various sizes on map
# might need to also calculate cumulative total
map <- get_map(location = "Victoria, Australia", zoom = 7)
g <- ggmap(map) + geom_point(data=data, aes(Lat,Long))
print(g)