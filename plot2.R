#Read files and libraries
library(tidyverse)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert to tibble for easier handling
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

#activate png device
png("plot2.png")

#create plot

NEI %>% 
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarize(total = sum(Emissions)) %>%
  plot(type = "b") %>%
  axis(side = 1, at = seq(1999,2008, by=1))

dev.off()



