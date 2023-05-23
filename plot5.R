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
png("plot5.png")

#create plot
mrg %>% 
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarize(total = sum(Emissions)) %>%
        ggplot(aes(year,total, label = total)) +
                geom_point() +
                geom_line()+
                geom_label() +
                labs(title = "Motor source Baltimore")

dev.off()
