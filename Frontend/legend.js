// legend for the sequence plot
let containerLegend = d3.select("#legend")
  .append("svg")
  .attr("preserveAspectRatio", "xMinYMin meet")
  .attr("viewBox", "0 0 700 150")

// legend rectangles
containerLegend.append("rect").attr("x",10).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#208eb7")
containerLegend.append("rect").attr("x",10).attr("y",35).attr("width", 10).attr("height", 10).style("fill", "#65e6f9")
containerLegend.append("rect").attr("x",10).attr("y",60).attr("width", 10).attr("height", 10).style("fill", "#154e56")
containerLegend.append("rect").attr("x",10).attr("y",85).attr("width", 10).attr("height", 10).style("fill", "#58df8c")
containerLegend.append("rect").attr("x",10).attr("y",110).attr("width", 10).attr("height", 10).style("fill", "#966106")
containerLegend.append("rect").attr("x",250).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#b5d08d")
containerLegend.append("rect").attr("x",250).attr("y",35).attr("width", 10).attr("height", 10).style("fill", "#6d3918")
containerLegend.append("rect").attr("x",250).attr("y",60).attr("width", 10).attr("height", 10).style("fill", "#f24325")
containerLegend.append("rect").attr("x",250).attr("y",85).attr("width", 10).attr("height", 10).style("fill", "#8e1023")
containerLegend.append("rect").attr("x",250).attr("y",110).attr("width", 10).attr("height", 10).style("fill", "#c27d92")
containerLegend.append("rect").attr("x",490).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#fbcab9")
containerLegend.append("rect").attr("x",490).attr("y",35).attr("width", 10).attr("height", 10).style("fill", "#ff0087")
containerLegend.append("rect").attr("x",490).attr("y",60).attr("width", 10).attr("height", 10).style("fill", "#fd8f2f")
containerLegend.append("rect").attr("x",490).attr("y",85).attr("width", 10).attr("height", 10).style("fill", "#bce333")
containerLegend.append("rect").attr("x",490).attr("y",110).attr("width", 10).attr("height", 10).style("fill", "#FB820F")

// legend text
containerLegend.append("text").attr("x",30).attr("y",20).text("Sports, Exercise, and Recreation").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",30).attr("y",45).text("Personal Care").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",30).attr("y",70).text("Sleep").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",30).attr("y",95).text("Socializing, Relaxing, and Leisure").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",30).attr("y",120).text("Household Activities").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",270).attr("y",20).text("Work").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",270).attr("y",45).text("Professional & Personal Care Services").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",270).attr("y",70).text("Eating and Drinking").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",270).attr("y",95).text("Caring For Household Member").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",270).attr("y",120).text("Consumer Purchases").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",510).attr("y",20).text("Other").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",510).attr("y",45).text("Caring For Nonhousehold Members").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",510).attr("y",70).text("Education").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",510).attr("y",95).text("Volunteer").attr("class", "legend_item_text")
containerLegend.append("text").attr("x",510).attr("y",120).text("Religious and Spiritual").attr("class", "legend_item_text")


// legend for the first example
let containerLegendExample = d3.select("#legend_example")
  .append("svg")
  .attr("preserveAspectRatio", "xMinYMin meet")
  .attr("viewBox", "0 0 600 60")

// legend rectangles
containerLegendExample.append("rect").attr("x",10).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#65e6f9")
containerLegendExample.append("rect").attr("x",10).attr("y",35).attr("width", 10).attr("height", 10).style("fill", "#154e56")
containerLegendExample.append("rect").attr("x",150).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#58df8c")
containerLegendExample.append("rect").attr("x",150).attr("y",35).attr("width", 10).attr("height", 10).style("fill", "#b5d08d")
containerLegendExample.append("rect").attr("x",370).attr("y",10).attr("width", 10).attr("height", 10).style("fill", "#f24325")

// legend text
containerLegendExample.append("text").attr("x",30).attr("y",20).text("Personal Care").attr("class", "legend_item_text") //#65e6f9
containerLegendExample.append("text").attr("x",30).attr("y",45).text("Sleep").attr("class", "legend_item_text") //#154e56
containerLegendExample.append("text").attr("x",170).attr("y",20).text("Socializing, Relaxing, and Leisure").attr("class", "legend_item_text") //#58df8c
containerLegendExample.append("text").attr("x",170).attr("y",45).text("Work").attr("class", "legend_item_text") //#b5d08d
containerLegendExample.append("text").attr("x",390).attr("y",20).text("Eating and Drinking").attr("class", "legend_item_text") //#f24325
