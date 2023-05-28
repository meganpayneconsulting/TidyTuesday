library(tidytuesdayR)
library(ggplot2)
library(tidyverse)
library(BobRossColors)
library(sysfonts)

font_add_google("Montserrat")

# tuesdata <- tidytuesdayR::tt_load('2023-02-21')
tuesdata <- tidytuesdayR::tt_load(2023, week = 8)

bob_ross <- tuesdata$bob_ross
bob_ross$season <- as.factor(bob_ross$season)

q <- ggplot(data=bob_ross, aes(x=season, y=num_colors, fill=season)) +
  geom_boxplot(outlier.colour="black", 
        outlier.shape=19,
        outlier.size=1, 
        notch=FALSE) + 
  labs(title="Bob Ross's Use of Color",
       subtitle="A look at how many colors he used in each painting, by season",
       caption="Plot by: Megan Payne @pointertomegan | Source: Bob Ross Colors data package \n 
       Chart color palette chosen from paintings 'Towering Glacier', 'The Windmill', 'Oval Barn', and 'Meadow Lake'.",
       x="Season", y="Number of Colors Used") +
  theme_minimal() +
  theme(text = element_text(family = "Montserrat")) +
  theme(legend.position = "none") +
  scale_fill_bob_ross(painting = c("towering_glacier", "the_windmill", "oval_barn", "meadow_lake"), type="qualitative") 

q

ggsave("images/week8_bob_ross_boxplot.png", width=7, bg="white")
