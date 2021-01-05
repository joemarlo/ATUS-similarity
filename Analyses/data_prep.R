setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

# create data for d3; need to slice sample because file size performance
IDS_by_cluster <- read_csv('Analyses/Data/clusters.csv')
sampled_IDs <- IDs_by_cluster %>% 
  group_by(cluster) %>% 
  slice_sample(n = 100) %>%
  separate(sequence, as.character(1:48), sep = 1:48) %>% 
  pivot_longer(cols = 3:50) %>% 
  rename(time = name, activity = value) %>% 
  group_by(ID) %>% 
  arrange(desc(DescTools::Entropy(table(activity))))

sampled_IDs %>% write_csv("d3/data/sequences.csv")

# read in the demographics data
demographics <- read_delim(file = "Inputs/demographic.tsv",
                           delim = "\t",
                           escape_double = FALSE,
                           trim_ws = TRUE)

# get demographics for the sampled IDs and write out
demographics %>% 
  dplyr::select(ID, age, sex, n_child, HH_income, married, race, education, state) %>% 
  filter(ID %in% sampled_IDs$ID) %>% 
  left_join(sampled_IDs %>% distinct(ID, cluster)) %>%
  mutate(sex = case_when(sex == 1 ~ "Male", 
                         sex == 2 ~ "Female", 
                         TRUE ~ '-'),
         married = case_when(married == 1 ~ "Yes",
                             married == 0 ~ "No",
                             TRUE ~ "-"),
         HH_income = if_else(is.na(HH_income), 0, HH_income),
         race = str_to_title(race)) %>% 
  write_csv("d3/data/demographics.csv")

# change name on string table
# read_csv("Analyses/Data/string_table.csv") %>% 
#   rename(activity = string) %>% 
#   write_csv("d3/data/string_table.csv")
