library(tidyverse)
library(osmdata)
library(tidytuesdayR)
library(ggplot2)
library(cowplot)

# using osmdata::getbb() fails, so got the lat/long min and max from openstreetmap
# https://www.openstreetmap.org/export#map=14/40.7825/-73.9655

bb <- c(-73.9850, 40.7630, -73.9450, 40.8021)


Gray <- "#8c9b86"
Cinnamon <- "#c2773e"
Black <- "#3c3934"
  

# tuesdata <- tidytuesdayR::tt_load('2023-05-23')
tuesdata <- tidytuesdayR::tt_load(2023, week = 21)

squirrel_data <- tuesdata$squirrel_data
squirrel_data_sm <- squirrel_data[!is.na(squirrel_data$`Primary Fur Color`) & squirrel_data$Approaches==TRUE,]
# Check to see if there are any clusters by time of day.
# squirrel_data_morning <- squirrel_data_sm[squirrel_data_sm$Shift == 'AM',]
# squirrel_data_afternoon <- squirrel_data_sm[squirrel_data_sm$Shift == 'PM',]

city_roads <- bb %>%
  opq() %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

city_water <- bb %>%
  opq() %>%
  add_osm_feature(key = "water") %>%
  osmdata_sf()

p <- ggplot() +
  geom_sf(data = city_water$osm_polygons, fill = "#7fc0ff") +
  geom_sf(data = city_roads$osm_lines,
          color = "#CCCCCC",
          linewidth = 0.2,
          alpha = 0.3) +
  geom_point(data = squirrel_data_sm, aes(x=X, y=Y, color=`Primary Fur Color`)) +
  scale_color_manual(values=c(Black, Cinnamon, Gray)) + 
  labs(title="Location Where Squirrels Begged For Food",
       subtitle="A Look at the New York Central Park 2018 Squirrel Census",
       caption = "Plot: Megan Payne @pointertomegan | Data: 2018 Squirrel Census | #TidyTuesday") +
       xlab("Latitude") + 
       ylab("Longitude") +
  theme_classic() + 
  theme(panel.background = element_rect(fill = "#FFFFFF"),
        text = element_text("Helvetica"),
        plot.title = element_text(color = Cinnamon, size = 12, face = "bold"),
        plot.caption = element_text(hjust = 0.5), 
        axis.text.x = element_text(angle = 45, hjust = 1))

save_plot("../images/week21_squirrel_census_food.png", p, base_height=5)
