function getConfigBar(){
  let width = 300;
  let height = 200;
  let margin = {
      top: 10,
      bottom: 100,
      left: 10,
      right: 10
  }

  //The body is the area that will be occupied by the bars.
  let bodyHeight = height - margin.top - margin.bottom;
  let bodyWidth = width - margin.left - margin.right;

  //The container is the SVG where we will draw the chart
  let container = d3.select("#plot_histograms" );

  return {width, height, margin, bodyHeight, bodyWidth, container}
}

function getScalesBar(data, config, id){

}

function getScalesBar(data, configBar) {
 let { bodyWidth, bodyHeight } = configBar;
 let maximumValue = d3.max(data, d => +d.value);
 //console.log(d3.max(data, d => +d[id]))

 let xScale = d3.scaleBand()
     .domain(data.map(function(d) { return d.key; }))
     .range([0, bodyWidth])
     .padding(0.2);

 let yScale = d3.scaleLinear()
      .domain([0, maximumValue])
     .range([bodyHeight, 0])

 return {xScale, yScale}
}

function drawBars(data, configBar, scales, id){
  let {margin, container, bodyHeight, bodyWidth, width, height} = configBar;
  let {xScale, yScale} = scales
  console.log('Data inputted to drawBars():', data)

  // add svg to the container
  container = container
   .append("svg")
   .attr("class", "plotBar" + id)
   .attr("width", width)
   .attr("height", height)

  // remove and redraw X axis
  d3.selectAll(".bottomAxisBar" + id).remove()
  container.append("g")
   .attr("class", "bottomAxisBar" + id)
  // .attr("transform", "translate(0," + bodyHeight + ")")
   .attr("transform", "translate(" + margin.left + "," + bodyHeight + ")")
   .call(d3.axisBottom(xScale))
   .selectAll("text")
     .attr("transform", "translate(-10,5)rotate(-70)")
     .style("text-anchor", "end");

  // remove and redraw x axis label
  d3.selectAll(".xaxis_label_bar_"+id).remove()
  container.append("text")
    .attr("class", "xaxis_label xaxis_label_bar_"+id)
    .attr("transform",
          "translate(" + (bodyWidth*1/2) + " ," + (bodyHeight + (margin.bottom*3/4)) + ")")
    .text(id)

 // join data with rect
 let rects = container
   .selectAll("rectBar" + id)
   .data(data)

 // add the new bars
 rects
   .enter()
   .append("rect")
   .merge(rects)
     .attr("x", d => xScale(d.key))
     .attr("y", d => yScale(d.value))
     .attr("width", xScale.bandwidth())
     .attr("height", d => bodyHeight - yScale(d.value))
     .attr("class", "rectBar" + id)
     .on("mouseover", function(d){
       d3.select(this).transition()
         .duration('50')
         .attr('opacity', '0.8');
     })
     .on("mouseleave", function(d){
       d3.select(this).transition()
         .duration('50')
         .attr('opacity', '1')
     })
     .transition()
       .duration(750)
       .styleTween("fill", d => d3.interpolate("white", "#394E48"))

 // delete the old bars
 rects
   .exit()
   .remove()
}

function countData(data, id){
  counts = d3.nest()
  .key(d => d[id])
  .rollup(d => d.length)
  .entries(demographics);

  return counts
}

function drawBarPlots(data) {
  // delete old plots
  d3.select("svg.plotBarSex").remove()
  d3.select("svg.plotBarMarried").remove()
  d3.select("svg.plotBarEducation").remove()
  d3.select("svg.plotBarRace").remove()

  // get config, scales then draw the plots
  let configBar = getConfigBar();

  let counts = countData(data, 'sex')
  let scales = getScalesBar(counts, configBar, 'sex');
  drawBars(data=counts, configBar=configBar, scales=scales, id='Sex');

  counts = countData(data, 'married')
  scales = getScalesBar(counts, configBar, 'married');
  drawBars(data=counts, configBar=configBar, scales=scales, id='Married');

  counts = countData(data, 'education')
  scales = getScalesBar(counts, configBar, 'education');
  drawBars(data=counts, configBar=configBar, scales=scales, id='Education');

  counts = countData(data, 'race')
  scales = getScalesBar(counts, configBar, 'race');
  drawBars(data=counts, configBar=configBar, scales=scales, id='Race');
}
