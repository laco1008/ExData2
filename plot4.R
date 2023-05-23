#Read files and libraries
library(tidyverse)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert to tibble for easier handling
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

#filter for coal combustion
coaldat <- SCC[str_detect(SCC$EI.Sector, "[Cc]oal") & str_detect(SCC$EI.Sector, "[Cc]omb"),]

#merge NEI and filtered SCC
mrg <- merge(NEI, coaldat, by = "SCC", all = FALSE)

#open png device
png("plot4.png")

#create plot
mrg %>% 
        group_by(year) %>%
        summarize(total = sum(Emissions)) %>%
        ggplot(aes(year,total, label = total)) +
                geom_point() +
                geom_line()+
                geom_label() +
                labs(title = "Coal combustion source")

dev.off()