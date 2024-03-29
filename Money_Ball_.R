library(tidyverse)
library(ggplot2)
library(ggeasy)
library(ggpubr)
library(dplyr)

league <- read.csv("all_pitchers.csv")
league
colnames(league)

gleague <- league %>% group_by(player_name)
ngames <- gleague %>% summarize(ngames = n_distinct(game_date))
playerfilter1 <- ngames %>%
  filter(ngames > 5) %>%
  select(player_name)
playerfilter2 <- as.data.frame(playerfilter1)
playerfilter2
dl
dl <- league %>% filter(player_name %in% playerfilter2)

league$type
## Slider

league1 <- mutate(league, strikes = ifelse(league$type == "S", 1, 0))

slider <- filter(league1, pitch_type == "SL")
slider


dl2 <- filter(slider)
dl2
srp1 <- ggplot(dl2, aes(plate_z, strikes)) +
  geom_point(size = 1, stroke = 2, shape = 9, color = "navyblue", pch = 21, fill = "white", alpha = .75) +
  theme_linedraw()
srp1

srm1 <- glm(strikes ~ plate_z + I(plate_z*plate_z), data = dl2, family = "binomial")
summary(srm1)

Team_Slider <- srp1 + geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"), color = "white", size = 3) +
  labs(title = "Slider Strike Probability (Team Average)",
       x = "Z Location (Vertical Height in ft)",
       y = "Strike %") +
  theme(text=element_text(size=12, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
Team_Slider

## Fastball

## Z Location

league2 <- mutate(league, strikes = ifelse(league$type == "S", 1, 0))

fastball <- filter(league2, pitch_type == "FF", effective_speed >= "60")
fastball


dl3 <- filter(fastball)
dl3
srp2 <- ggplot(dl3, aes(plate_z, strikes)) +
  geom_point(size = 1, stroke = 2, shape = 9, color = "navyblue", pch = 21, fill = "white", alpha = .75) +
  theme_linedraw()
srp2

srm2 <- glm(strikes ~ plate_z + I(plate_z*plate_z), data = dl3, family = "binomial")
summary(srm2)
Team_Fastball_Z <- srp2 + geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"), color = "white", size = 3) +
  labs(title = "Fastball Strike Probability (Team Average)",
       x = "Z Location (Vertical Height in ft)",
       y = "Strike %") +
  theme(text=element_text(size=12, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
Team_Fastball_Z

## Release Spin Rate

srp4 <- ggplot(dl3, aes(release_spin_rate, strikes)) +
  geom_point(size = 1, stroke = 2, shape = 9, color = "navyblue", pch = 21, fill = "white", alpha = .75) +
  theme_linedraw()
srp4

srm4 <- glm(strikes ~ release_spin_rate, data = dl3, family = "binomial")
summary(srm4)
Team_Fastball_Spin <- srp4 + geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"), color = "white", size = 3) +
  labs(title = "Fastball Strike Probability (Team Average)",
       x = "Release Spin Rate",
       y = "Strike %") +
  theme(text=element_text(size=12, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
Team_Fastball_Spin



## Sinker

sinker <- filter(league2, pitch_type == "SI")
sinker


dl4 <- filter(sinker)
dl4
srp3 <- ggplot(dl4, aes(plate_z, strikes)) +
  geom_point(size = 1, stroke = 2, shape = 9, color = "navyblue", pch = 21, fill = "white", alpha = .75) +
  theme_linedraw()
srp3

srm3 <- glm(strikes ~ plate_z, data = dl4, family = "binomial")
summary(srm3)
Team_Sinker <- srp3 + geom_smooth(method = "glm", se = FALSE, method.args = list(family = "binomial"), color = "white", size = 3) +
  labs(title = "Sinker Strike Probability (Team Average)",
       x = "Z Location (Vertical Height in ft)",
       y = "Strike %") +
  theme(text=element_text(size=12, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
Team_Sinker

ggarrange(Team_Sinker, Team_Fastball_Spin, Team_Slider, Team_Fastball_Z, nrow = 2, ncol = 2)


team_avg_spin <- league1 %>%
  group_by(player_name, pitch_type = "FF") %>%
  summarize(spin = mean(release_spin_rate, na.rm = T))
            


  
Team_averages <- na.omit(team_avg_spin)

Individual_Spin_FF <- distinct(Team_averages)
Individual_Spin_FF 
##

team_avg_FF_Z <- league1 %>%
  group_by(player_name, pitch_type = "FF") %>%
  summarize(Z = mean(plate_z, na.rm = T))
team_avg_FF_Z
Team_averages1 <- na.omit(team_avg_FF_Z)
Individual_FF_Z <- distinct(Team_averages1)
Individual_FF_Z

##

team_avg_sliderZ <- league1 %>%
  group_by(player_name, pitch_type = "SL") %>%
  summarize(Z = mean(plate_z, na.rm = T))




Team_averages2 <- na.omit(team_avg_sliderZ)

Individual_Slider_Z <- distinct(Team_averages2)
Individual_Slider_Z 

##

team_avg_sinkerZ <- league1 %>%
  group_by(player_name, pitch_type = "SI") %>%
  summarize(Z = mean(plate_z, na.rm = T))




Team_averages3 <- na.omit(team_avg_sinkerZ)

Individual_Sinker_Z <- distinct(Team_averages3)
Individual_Sinker_Z 


SinkerZ <- ggplot(Individual_Sinker_Z, aes(x = Individual_Sinker_Z$Z, y = Individual_Sinker_Z$player_name)) +
  geom_boxplot(aes(group = Individual_Sinker_Z$player_name), color = "white", size = 2) +
  labs(title = "Individual Player Averages (Sinker)",
       x = "Average Z Location (height in ft)",
       y = "Pitcher Name") +
  theme(text=element_text(size=10, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
SinkerZ

SliderZ <- ggplot(Individual_Slider_Z, aes(x = Individual_Slider_Z$Z, y = Individual_Slider_Z$player_name)) +
  geom_boxplot(aes(group = Individual_Slider_Z$player_name), color = "white", size = 2) +
  labs(title = "Individual Player Averages (Slider)",
       x = "Average Z Location (height in ft)",
       y = "Pitcher Name") +
  theme(text=element_text(size=10, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
SliderZ

FF_Z <- ggplot(Individual_FF_Z, aes(x = Individual_FF_Z$Z, y = Individual_FF_Z$player_name)) +
  geom_boxplot(aes(group = Individual_FF_Z$player_name), color = "white", size = 2) +
  labs(title = "Individual Player Averages (Fastball)",
       x = "Average Z Location (height in ft)",
       y = "Pitcher Name") +
  theme(text=element_text(size=10, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
FF_Z

FF_Spin <- ggplot(Individual_Spin_FF, aes(x = Individual_Spin_FF$spin, y = Individual_Spin_FF$player_name)) +
  geom_boxplot(aes(group = Individual_Spin_FF$player_name), color = "white", size = 2) +
  labs(title = "Individual Player Averages (Fastball)",
       x = "Average Release Spin Rate (rpm)",
       y = "Pitcher Name") +
  theme(text=element_text(size=10, 
                          family="serif")) +
  ggeasy::easy_center_title() + 
  theme(
    panel.background = element_rect(fill = "grey",
                                    colour = "navyblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "navyblue"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "navyblue"))
FF_Spin

Indiv <- ggarrange(FF_Spin, FF_Z, nrow = 1, ncol = 2)
Indiv
Indiv1 <- ggarrange(SliderZ, SinkerZ, nrow = 1, ncol = 2)
Indiv1

