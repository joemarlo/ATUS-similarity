library(tidyverse)
set.seed(44)

IDs_by_cluster <- read_csv(file = "Analyses/Data/clusters.csv")
modal_strings <- read_csv(file = "Analyses/Data/modes.csv")

                            
# classify a new observation by string dist ------------------------------------

# new observation
new_obs <- "CCCCCCCCCCDDDDFFFFAAAADDDDDDDDDDDDDDDDCCCCCCCCCC"

# calculate distances to modal strings
distances <- stringdist::stringdist(
  a = new_obs,
  b = modal_strings$sequence,
  method = "lv"
)

# estimate cluster membership
best_cluster <- modal_strings$cluster[which.min(distances)]

# plot it
IDs_by_cluster %>% 
  filter(cluster == best_cluster) %>%
  dplyr::select(ID, sequence) %>% 
  slice_sample(n = 50) %>% 
  bind_rows(tibble(ID = 1, sequence = new_obs)) %>% 
  separate(sequence, as.character(1:48), sep = 1:48) %>% 
  pivot_longer(cols = 2:49) %>%
  rename(string = value,
         period = name) %>% 
  left_join(string_table, by = 'string') %>% 
  mutate(period = as.numeric(period),
         ID = as.factor(ID)) %>% 
  group_by(ID) %>% 
  mutate(entropy = DescTools::Entropy(table(string))) %>%
  ungroup() %>% 
  ggplot(aes(x = period, y = reorder(ID, entropy), fill = description)) +
  # ggplot(aes(x = period, y = ID, fill = description)) +
  geom_tile() +
  scale_y_discrete(labels = NULL) +
  scale_x_continuous(labels = labels,
                     breaks = seq(0, 48, by = 4)) +
  labs(title = 'Edit distance and Ward D2 clustering',
       subtitle = "Each row represents an individual respondent's day",
       x = "Time of day", 
       y = "Individuals",
       fill = NULL) +
  guides(fill = guide_legend(ncol = 1)) +
  theme(legend.position = 'right')
