setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

# temp: create test data for d3
tmp <- IDs_by_cluster %>% 
  group_by(cluster) %>% 
  slice_sample(n = 50) %>%
  separate(sequence, as.character(1:48), sep = 1:48) %>% 
  pivot_longer(cols = 3:50) %>% 
  rename(time = name, activity = value) %>% 
  group_by(ID) %>% 
  arrange(desc(DescTools::Entropy(table(activity))))

tmp %>% write_csv("d3/data/sequences.csv")



# read in the demographics data
demographics <- read_delim(file = "Inputs/demographic.tsv",
                           delim = "\t",
                           escape_double = FALSE,
                           trim_ws = TRUE)

demographics %>% 
  dplyr::select(ID, age, sex, n_child, HH_income, married, race, education, state) %>% 
  filter(ID %in% tmp$ID) %>% 
  left_join(tmp %>% distinct(ID, cluster)) %>% 
  write_csv("d3/data/demographics.csv")


# change name on string table
read_csv("Analyses/Data/string_table.csv") %>% 
  rename(activity = string) %>% 
  write_csv("d3/data/string_table.csv")
