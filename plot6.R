#Read files and libraries
library(tidyverse)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert to tibble for easier handling
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

#filter for coal combustion
coaldat <- SCC[str_detect(SCC$EI.Sector, "[Mm]otor") | str_detect(SCC$EI.Sector, "[Vv]ehicle"),]

#merge NEI and filtered SCC
mrg <- as_tibble(merge(NEI, coaldat, by = "SCC", all = FALSE))

#open png device
png("plot6.png")

#create plot data, summarize by fips and year, and create a percentage change variable
plotdat <- mrg %>% 
        filter(fips == "24510" | fips == "06037") %>%
        group_by(fips,year) %>%
        summarize(total = sum(Emissions)) %>%
        mutate(percent = total / total[1])


#create plot
par(mfrow = c(2,2))       
plot(x=subset(plotdat, fips == "06037",year)$year, y= subset(plotdat, fips == "06037", total)$total, type = "b", main = "LA total", xlab = "year", ylab = "total motor vehicle emission")
plot(x=subset(plotdat, fips == "24510",year)$year, y= subset(plotdat, fips == "24510", total)$total, type = "b", main = "Baltimore total", xlab = "year", ylab = "total motor vehicle emission")
plot(x=subset(plotdat, fips == "06037",year)$year, y= subset(plotdat, fips == "06037", percent)$percent, type = "b", main = "LA percentage", xlab = "year", ylab = "% change from 1999")
plot(x=subset(plotdat, fips == "24510",year)$year, y= subset(plotdat, fips == "24510", percent)$percent, type = "b", main = "Baltimore percentage", xlab = "year", ylab = "% change from 1999")


dev.off()

