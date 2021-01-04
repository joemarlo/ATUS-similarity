library(tidyverse)
source("Plots/ggplot_settings.R")
set.seed(44)
setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

# read in modal strings
modal_strings <- read_csv("Analyses/Data/modes.csv")

modal_strings$description <- c(
  "Socializing",
  "Night workers",
  "Household activitys then socializing",
  "Students then socializing",
  "8-7ers",
  "6-5ers",
  "evening workers"
)


modal_strings$work <- c(0, 1, 0, 0, 1, 1, 1)
modal_strings$day_work <- c(0,0,0,0, 1, 1, 1)

# Do you work?
# Yes
# No

# When do you start work?
# Early morning -> C6
# Morning -> C5
# Afternoon -> C7
# Night -> C2

# Are you are student?
# Yes -> C4
# No

# How do you usually spend your day?
# Socializing -> C1
# Household activities -> C3
# Other -> Custom

