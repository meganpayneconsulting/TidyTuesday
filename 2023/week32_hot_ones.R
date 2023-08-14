library(tidytuesdayR)
library(ggplot2)
library(tidyverse)
library(scales)
options(scipen=999)
library(showtext)
showtext_auto()
font_add_google(name = "Philosopher", family = "philosopher")
font_add_google(name = "Lakki Reddy", family = "lakki")

tuesdata <- tidytuesdayR::tt_load('2023-08-08')
## OR
# tuesdata <- tidytuesdayR::tt_load(2023, week = 32)

# episodes <- tuesdata$episodes
sauces <- tuesdata$sauces
# seasons <- tuesdata$seasons
glimpse(sauces)

# Quick look at the Scoville score for each sauce number (boxplot)
p <- ggplot(data=sauces) +
  geom_boxplot(aes(x=sauce_number, y=scoville, group=sauce_number)) + 
  scale_x_continuous(name = "Sauce Number", breaks = seq(0, 10, 2)) +
  scale_y_continuous(name = "Scoville", 
                     labels=scales::label_number(accuracy=1, big.mark=",")) +
  theme_minimal()
p  

# The 10th sauce scoville score is a bit high after season 3
sauces %>% filter(sauce_number==10)

# Take a look at the dist of scoville number across seasons
# Each season uses the same 10 sauces all season.
# Not really necessary since I have a boxplot, but a little easier to see
ggplot(sauces) +
  geom_point(aes(x=sauce_number, y=scoville, group=sauce_number)) +
  scale_x_continuous(name = "Sauce Number", breaks = seq(0, 10, 2)) +
  scale_y_continuous(name = "Scoville", 
          labels=scales::label_number(accuracy=1, big.mark=",")) +
  theme_minimal()

# Take a look at the progression in scoville number by season
ggplot(sauces) +
  geom_line(aes(x=sauce_number, y=scoville, group=season, color=season)) +
  scale_x_continuous(name = "Sauce Number", breaks = seq(0, 10, 2)) +
  scale_y_continuous(name = "Scoville", 
                     labels=scales::label_number(accuracy=1, big.mark=",")) +
  theme_minimal()


ggplot(sauces, aes(x = season, y = sauce_number)) +
  geom_raster(aes(fill = scoville)) + 
  scale_fill_gradient(name = "Scoville Score", trans = "log", 
        low="#FFFFFF", high="#660000",
        breaks=c(3000, 25000, 100000, 500000, 2000000),
        labels=scales::label_number(accuracy=1, big.mark=",")) +
  scale_y_continuous(n.breaks=6) +
  theme_classic() +
  theme(text=element_text(family='sans', color="white", size=16),
        plot.title=element_text(family='lakki', size=30, color="#990000"),
        plot.subtitle=element_text(family='philosopher', size=20, color="white"),
        panel.background = element_rect(fill="black", color="black"),
        plot.background = element_rect(fill="black"),
        axis.line = element_line(color="white"),
        axis.text = element_text(color="white"),
        axis.ticks = element_line(color="white"),
        legend.background = element_rect(fill="black")) +
  xlab("Season") +
  ylab("Sauce Number") +
  labs(title="A Literal Heatmap of Hot Ones Sauces",
       subtitle="A look at the Scoville score for the Youtube series",
       caption="Data Source: Wikipedia | Graphic: Megan Payne | #TidyTuesday #Rstats")

ggsave("images/week32_scoville_heatmap.png")
