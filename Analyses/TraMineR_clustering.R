library(tidyverse)
library(TraMineR)
library(fastcluster)
library(NbClust)
library(dendextend)
source("Plots/ggplot_settings.R")
set.seed(44)
setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

# read in ATUS data
atus_raw <- read_tsv("Inputs/atus.tsv")

# read in the demographics data
demographics <- read_delim(file = "Inputs/demographic.tsv",
                           delim = "\t",
                           escape_double = FALSE,
                           trim_ws = TRUE)


# filter to only include respondents who logged on weekdays and non holidays
IDs <- demographics %>% 
  filter(day_of_week %in% 2:6,
         holiday == 0) %>% 
  dplyr::select(ID, survey_weight)

# filter to just include weekends, pivot wider, and sample with weights
n_sample <- 10000
atus_sampled <- atus_raw %>% 
  pivot_wider(values_from = description, names_from = period, names_prefix = "p_") %>% 
  right_join(IDs, by = "ID") %>% 
  slice_sample(n = n_sample, weight_by = survey_weight) %>% 
  dplyr::select(-survey_weight)

# define alphabet as all unique states
alphabet <- atus_sampled[,-1] %>% unlist() %>% unique() %>% sort()
# states <- c("CHH")
labels <- c("Care_HH", "Care_NHH", "Cons_Pur", "Eat_drink", "Edu", 
            "HH_activ", "Other", "Prsl_care", "Care_svcs", "Rel_spirit", 
            "Sleep", "Leisure", "Recreation", "Volunteer", "Work")

# create state sequence object
atus_seq <- seqdef(data = atus_sampled[, -1], 
                   alphabet = alphabet, 
                   # states = mvad.scodes,
                   id = atus_sampled$ID,
                   labels = labels,
                   xtstep = 1)

dev.off()
# plot first 10 sequences
seqiplot(atus_seq, with.legend = "right", border = NA)
# plot all sequences sorted 
seqIplot(atus_seq, sortv = "from.start", with.legend = "right")
png("Plots/state_distribution.png", width = 900, height = 450)
seqdplot(atus_seq, sortv = "from.start", with.legend = "right", border = 'white', main = "State distribution of activities", xlab = "Time")
dev.off()
# plot 10 most frequent sequences
seqfplot(atus_seq, with.legend = "right", border = NA)
# plot legend
seqlegend(atus_seq)

# summary statistics
dev.off()
par(mfrow = c(2, 2))
seqdplot(atus_seq, with.legend = FALSE, border = NA, main = "(a) state distribution")
seqHtplot(atus_seq, main = "(b) entropy index")
seqmsplot(atus_seq, with.legend = FALSE, border = NA, main = "(c) mean time")
seqmtplot(atus_seq, with.legend = FALSE, main = "(d) modal state seq.")

# compute optimal matching distances
dist_om_TRATE <- seqdist(atus_seq, method = "OM", indel = 1, sm = "TRATE")
dist_om_DHD <- seqdist(atus_seq, method = "DHD")

# cluster the data
clusters <- hclust(as.dist(dist_om_DHD), method = "ward.D2")

# get optimal cluster sizes by calculating silhouette width
s_width <- NbClust(
  data = NULL,
  diss = as.dist(dist_om_DHD),
  distance = NULL,
  method = 'ward.D2',
  max.nc = 12,
  min.nc = 6,
  index = 'silhouette'
)

# plot the silhouette width
s_width$All.index %>% 
  enframe() %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(x = name, y = value)) +
  geom_line(color = 'grey30') +
  geom_area(alpha = 0.4) +
  geom_point(color = 'grey30') +
  scale_x_continuous(breaks = 6:12) +
  labs(title = "Silhouette width: dynamic Hamming distance",
       subtitle = paste0("Weighted sample of ", 
                         scales::comma_format()(n_sample),
                         " respondents"),
       x = 'n clusters',
       y = 'Silhouette width')
# ggsave("Plots/silhouette_width.svg", width = 7, height = 4)


# dendrograms -------------------------------------------------------------

hcl_ward <- clusters
hcl_k <- 7 #s_width$Best.nc[['Number_clusters']] # need a balance of optimal width and enough clusters to be interesting to the user
dend <- as.dendrogram(hcl_ward) %>% set("branches_k_color", k = hcl_k) %>% set("labels_colors")
dend <- cut(dend, h = 50)$upper # cut off bottom of dendogram for computation performance
ggd1 <- as.ggdend(dend)

# set dashed line for non-cluster segments
ggd1$segments$linetype <- 'solid'
ggd1$segments$linetype[which(is.na(ggd1$segments$col))] <- 'dashed'

# set connecting lines to grey
ggd1$segments$col[is.na(ggd1$segments$col)] <- 'grey50'

# plot the dendrograms
ggd1$segments %>% 
  ggplot() + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend),
               color = ggd1$segments$col, linetype = ggd1$segments$linetype,
               lwd = 0.6, alpha = 0.7) +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = scales::comma_format()) +
  labs(title = "Dendrogram of edit distance with Ward (D2) linkage",
       subtitle = paste0("Weighted sample of ", 
                         scales::comma_format()(n_sample),
                         " respondents"),
       x = NULL,
       y = NULL) +
  theme(axis.ticks = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = 'none')
# ggsave("Plots/dendrogram.png", width = 7, height = 4)

# sequence plots ----------------------------------------------------------

cluster_6 <- cutree(clusters, k = hcl_k)
cluster_6 <- factor(cluster_6, labels = paste("Cluster", 1:hcl_k))

# dev.off()
par(mar = c(3, 3, 3, 3))
#png(paste0("Plots/TraMineR/", dist_names[i], "_state_sequence.png"), width = 600, height = 450)
seqIplot(atus_seq, group = cluster_6, sortv = "from.start", main = "State sequences", with.legend = FALSE)
dev.off()

par(mar = rep(1.5,4))
png(paste0("Plots/DHD_state_distribution.png"), width = 700, height = 1000)
seqdplot(atus_seq, group = cluster_6, sortv = "from.start", border = 'white', main = "State distributions", with.legend = FALSE)
dev.off()

par(mar = c(3, 3, 3, 3))
#png(paste0("Plots/TraMineR/", dist_names[i], "_state_entropy.png"), width = 900, height = 450)
seqHtplot(atus_seq, group = cluster_6, main = "Entropy index", with.legend = FALSE)
dev.off()

par(mar = c(3, 3, 3, 3))
# png(paste0("Plots/TraMineR/", dist_names[i], "_state_modal.png"), width = 900, height = 450)
seqmsplot(atus_seq, group = cluster_6, border = NA, main = "Mean time")
dev.off()


# final dataset -----------------------------------------------------------

# read in lookup table of activity:letter
string_table <- read_csv("Analyses/Data/string_table.csv")

# long dataframe of the IDs and each state
clusters_long <- atus_sampled %>% 
  mutate(cluster = cluster_6) %>% 
  pivot_longer(cols = starts_with("p")) %>% 
  left_join(string_table, by = c("value" = "description")) %>% 
  dplyr::select(ID, cluster, activity)

# dataframe of id, sequence, and cluster membership
IDs_by_cluster <- clusters_long %>% 
  group_by(ID, cluster) %>% 
  summarize(sequence = paste0(activity, collapse = ""),
            .groups = 'drop')

# write out cluster membership
write_csv(IDs_by_cluster, path = "Analyses/Data/clusters.csv")


# modal strings -----------------------------------------------------------

get_mode <- function(x) {
  uniq <- unique(x)
  mode <- uniq[which.max(tabulate(match(x, uniq)))]
  return(mode)
}

# get modal activity by cluster and time
modal_activities <- clusters_long %>% 
  group_by(ID) %>% 
  mutate(index = row_number()) %>% 
  group_by(cluster, index) %>% 
  summarize(mode = get_mode(activity))

# need to shift time four hours and fix labels
labels <- as.character(seq(2, 24, by = 2))
labels <- c(labels[2:12], labels[1:2])
labels[1] <- "4am"

# plot the modes
custom_colors <- c(string_table$val)
names(custom_colors) <- string_table$description
modal_activities %>% 
  ungroup() %>% 
  left_join(string_table, by = c("mode" = "activity")) %>% 
  ggplot(aes(x = index, y = cluster, fill = description)) +
  geom_tile(color = 'white', size = 0.5) +
  scale_x_continuous(labels = labels,
                     breaks = seq(0, 48, by = 4)) +
  scale_fill_manual(values = custom_colors) +
  labs(title = "Modal sequences per cluster",
       x = NULL,
       y = NULL,
       fill = NULL) +
  theme(legend.position = 'bottom')
# ggsave("Plots/modal_sequences.svg", width = 7.5, height = 4)

# write out the modal strings
modal_strings <- modal_activities %>% 
  group_by(cluster) %>% 
  summarize(sequence = paste0(mode, collapse = ""),
            .groups = 'drop')
write_csv(modal_strings, "Analyses/Data/modes.csv")


# plot the sequences ------------------------------------------------------
# this is to ensure there wasn't any ID mismatches during the clustering process

# convert df back to long with a row per activity
atus_samp <- IDs_by_cluster %>%
  separate(sequence, as.character(1:48), sep = 1:48) %>% 
  pivot_longer(cols = 3:50) %>%
  rename(activity = value,
         period = name) %>% 
  left_join(string_table, by = 'activity') %>% 
  na.omit() %>% 
  mutate(period = as.numeric(period),
         ID = as.factor(ID))

# sequence plots by cluster
atus_samp %>%
  group_by(ID) %>% 
  mutate(entropy = DescTools::Entropy(table(activity))) %>%
  ungroup() %>% 
  ggplot(aes(x = period, y = reorder(ID, entropy), fill = description)) +
  geom_tile() +
  scale_y_discrete(labels = NULL) +
  scale_x_continuous(labels = labels,
                     breaks = seq(0, 48, by = 4)) +
  scale_fill_manual(values = custom_colors) +
  facet_wrap(~cluster, ncol = 2, scales = 'free_y') +
  labs(title = 'Edit distance and Ward D2 clustering',
       subtitle = "Each row represents an individual respondent's day",
       x = "Time of day", 
       y = "Individuals",
       fill = NULL) +
  guides(fill = guide_legend(ncol = 1)) +
  theme(legend.position = 'right')
# ggsave("Plots/state_distributions_by_cluster.png", width = 9, height = 8)
