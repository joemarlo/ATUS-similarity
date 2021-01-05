library(tidyverse)
set.seed(44)
setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

activities <- read_csv("d3/data/string_table.csv") %>% 
  pull(description)

#'<select value="', button_colors[1],'" class="user_input" id="input_one">\n'
map2(.x = button_colors, .y = activities[1:11], function(col, activity){
  paste0(
      '<option value="#', col, '">', activity, '</option>'
  )
}) %>% paste0(collapse="")

sequence_colors <- colorRampPalette(RColorBrewer::brewer.pal(10, "Paired"))(15)

# from colorgorical: http://vrl.cs.brown.edu/color
sequence_colors <- c(
    "#208eb7",
    "#65e6f9",
    "#154e56",
    "#58df8c",
    "#966106", #"#069668",
    "#b5d08d",
    "#6d3918",
    "#f24325",
    "#8e1023",
    "#c27d92",
    "#fbcab9",
    "#ff0087",
    "#fd8f2f",
    "#bce333",
    "#798a58"
  )
# sequence_colors <- viridis::viridis_pal()(15)
scales::show_col(sequence_colors)

# add colors to string table
string_table <- read_csv("d3/data/string_table.csv")
#string_table$val <- sequence_colors

# manually edit colors
# string_table$val[string_table$description == 'Sleep'] = 

# write out table
string_table %>% write_csv('d3/data/string_table.csv')

# get colors for lookup table in jquery
writeLines(
  paste0("{val : '", string_table$val, "', text: '", string_table$description, "'}", collapse = ', ')
)


# read in modal strings
modal_strings <- read_csv("Analyses/Data/modes.csv")
# modal_strings %>% write_csv("Analyses/Data/input_to_manual_strings.csv")

# manually edit strings to make them more realistic
# if the modal strings change then all this needs should be updated too
str_sub(modal_strings[1, 'sequence'], 11, 11) <- 'B'
str_sub(modal_strings[1, 'sequence'], 12, 12) <- 'H'
str_sub(modal_strings[1, 'sequence'], 18, 18) <- 'H'
str_sub(modal_strings[1, 'sequence'], 30, 30) <- 'H'
str_sub(modal_strings[1, 'sequence'], 38, 38) <- 'B'

str_sub(modal_strings[2, 'sequence'], 9, 9) <- 'H'
str_sub(modal_strings[2, 'sequence'], 30, 30) <- 'C'
str_sub(modal_strings[2, 'sequence'], 31, 31) <- 'B'
str_sub(modal_strings[2, 'sequence'], 32, 34) <- 'DDD'
str_sub(modal_strings[2, 'sequence'], 35, 35) <- 'H'

str_sub(modal_strings[3, 'sequence'], 9, 9) <- 'B'
str_sub(modal_strings[3, 'sequence'], 10, 10) <- 'H'
str_sub(modal_strings[3, 'sequence'], 18, 18) <- 'H'
str_sub(modal_strings[3, 'sequence'], 32, 32) <- 'H'
str_sub(modal_strings[3, 'sequence'], 36, 36) <- 'B'

str_sub(modal_strings[4, 'sequence'], 7, 7) <- 'B'
str_sub(modal_strings[4, 'sequence'], 18, 18) <- 'H'
str_sub(modal_strings[4, 'sequence'], 32, 32) <- 'H'

str_sub(modal_strings[5, 'sequence'], 7, 7) <- 'B'
str_sub(modal_strings[5, 'sequence'], 8, 8) <- 'H'
str_sub(modal_strings[5, 'sequence'], 18, 18) <- 'H'
str_sub(modal_strings[5, 'sequence'], 31, 32) <- 'HH'

str_sub(modal_strings[6, 'sequence'], 4, 4) <- 'B'
str_sub(modal_strings[6, 'sequence'], 5, 5) <- 'H'
str_sub(modal_strings[6, 'sequence'], 18, 18) <- 'H'
str_sub(modal_strings[6, 'sequence'], 27, 27) <- 'H'

str_sub(modal_strings[7, 'sequence'], 15, 15) <- 'H'
str_sub(modal_strings[7, 'sequence'], 41, 41) <- 'H'
str_sub(modal_strings[7, 'sequence'], 42, 42) <- 'B'

# create non-cluster days
otherCare <- modal_strings[[3, 'sequence']]
otherVolunteer <- modal_strings[[3, 'sequence']]
otherReligious <- modal_strings[[3, 'sequence']]
otherCare <- str_replace_all(otherCare, 'E', 'I')
otherVolunteer <- str_replace_all(otherVolunteer, 'E', 'N')
otherReligious <- str_replace_all(otherReligious, 'E', 'O')
modal_strings <- modal_strings %>% 
  bind_rows(tibble(cluster = c('otherCare', 'otherVolunteer', 'otherReligious'),
                   sequence = c(otherCare, otherVolunteer, otherReligious)))

# get colors of default string for use in jquery
modal_strings_colors <- modal_strings %>% 
  group_by(cluster) %>% 
  separate(sequence, as.character(2:49), sep = 1:48) %>% 
  pivot_longer(cols = 2:49) %>% 
  rename(activity = value) %>% 
  left_join(string_table)

# plot of created days
modal_strings_colors %>% 
  mutate(name = as.numeric(name)) %>% 
  ggplot(aes(x = name, y = cluster, fill = description)) +
  geom_tile(color = 'white')

# generate JS code to define sequence arrays per cluster
final_clusters <- unique(modal_strings_colors$cluster)
for (i in seq_along(final_clusters)){
  modal_strings_colors %>% 
    filter(cluster == final_clusters[i]) %>% 
    pull(val) %>% 
    paste0("{val : '", ., "'}", collapse = ',') %>% 
    paste0("let proto", i," = [ ", ., " ]") %>% 
    writeLines()
  writeLines('\n')
}

