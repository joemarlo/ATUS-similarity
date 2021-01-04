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

# get colors of default string for use in jquery
modal_strings_colors <- modal_strings %>% 
  group_by(cluster) %>% 
  separate(sequence, as.character(2:49), sep = 1:48) %>% 
  pivot_longer(cols = 2:49) %>% 
  rename(activity = value) %>% 
  left_join(string_table)

# generate JS code to define sequence arrays per cluster
final_clusters <- unique(modal_strings_colors$cluster)
for (i in seq_along(final_clusters)){
  modal_strings_colors %>% 
    filter(cluster == final_clusters[i]) %>% 
    pull(val) %>% 
    paste0("{val : '", ., "'}", collapse = ',') %>% 
    writeLines()
  writeLines('\n')
}

