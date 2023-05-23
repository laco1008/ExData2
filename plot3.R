#Read files and libraries
library(tidyverse)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#convert to tibble for easier handling
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

#create plot data
plotdat <- NEI %>% 
        filter(fips == "24510") %>%
        group_by(type,year) %>%
        summarize(total = sum(Emissions))

#make a new variable, which gives the color of the line back (green if the emission decreased, red if it increased)
grow <- plotdat %>%
        summarize(smaller = (first(total) - last (total))) %>%
        mutate(is = ifelse(smaller>0, "green", "red"))

#merge these together
plot <- merge(plotdat, grow, by = "type")

#activate png device
png("plot3.png")

#create ggplot
ggplot(data = plot, aes(year, total, label = total, color = is)) + 
        geom_point(size = 2) +
        facet_grid(type ~ ., scales = "free_y") +
        geom_line() +
        scale_color_identity() +
        geom_label() +
        labs(title = "Types in Baltimore")

dev.off()

