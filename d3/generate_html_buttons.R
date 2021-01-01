library(tidyverse)
setwd('/home/joemarlo/Dropbox/Data/Projects/ATUS-similarity')

# TODO: need 15 colors
button_colors <- RColorBrewer::brewer.pal(11, 'Spectral')

activities <- read_csv("d3/data/string_table.csv") %>% 
  pull(description)

'<select value="', button_colors[1],'" class="user_input" id="input_one">\n'
map2(.x = button_colors, .y = activities[1:11], function(col, activity){
  paste0(
      '<option value="#', col, '">', activity, '</option>'
  )
}) %>% paste0(collapse="")

