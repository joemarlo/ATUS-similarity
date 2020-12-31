// function to read data if we'd rather use fixed data
function loadData() {
    return Promise.all([
        d3.csv("data/tmp.csv")
    ]).then(datasets => {
        store = datasets[0];
        console.log(store)
        return store;
    })
}

function getConfig() {
   let width = 700;
   let height = 500;
   let margin = {
       top: 10,
       bottom: 50,
       left: 50,
       right: 20
   }
   //The body is the area that will be occupied by the bars.
   let bodyHeight = height - margin.top - margin.bottom;
   let bodyWidth = width - margin.left - margin.right;

   //The container is the SVG where we will draw the chart
   let container = d3.select("#plot_sequence" );
   container
       .attr("width", width)
       .attr("height", height)

   return {width, height, margin, bodyHeight, bodyWidth, container}
}

function getScales(data, config) {
 let { bodyWidth, bodyHeight, container } = config;
 let maximumValue = d3.max(data, d => +d.time);
 let minimumValue = d3.min(data, d => +d.time);

 let xScale = d3.scaleLinear()
     .domain([-600, 600]) //[minimumValue, maximumValue]
     .range([0, bodyWidth])
 let yScale = d3.scaleLinear()
     .range([bodyHeight, 0])

 return {xScale, yScale}
}

function drawBars(data, nbins, scales, config){
  let {margin, container, bodyHeight, bodyWidth} = config;
  //let {xScale, yScale} = scales

  // Labels of row and columns -> unique identifier of the column called 'group' and 'variable'
  var myGroups = d3.map(data, function(d){return d.time;}).keys()
  var myVars = d3.map(data, function(d){return d.ID;}).keys()
  console.log(myGroups)
  console.log(myVars)

  // Build X scales and axis:
  var xScale = d3.scaleBand()
    .range([ 0, bodyWidth ])
    .domain(myGroups)
    .padding(0.01);

  // Build Y scales and axis:
  var yScale = d3.scaleBand()
    .range([ bodyHeight, 0 ])
    .domain(myVars)
    .padding(0.05);

  // Build color scale TODO expand to 15 colors!!!
  // https://github.com/d3/d3-scale-chromatic#interpolateSpectral
  let myColor = d3.scaleOrdinal(d3.schemeSpectral[11])

  // add the squares
  container
    .selectAll()
    .data(data, function(d) {return d.time+':'+d.ID;})
    .enter()
    .append("rect")
      .attr("x", d => x(d.time))
      .attr("y", d => y(d.ID))
      .attr("rx", 5)
      .attr("ry", 5)
      .attr("width", x.bandwidth() )
      .attr("height", y.bandwidth() )
      .style("fill", d => myColor(d.activity)) //function(d) { return myColor(d.activity)} )
      .style("stroke-width", 2)
      .style("stroke", "none")
      .style("opacity", 0.8)

    /*
  // remove and redraw X axis
  d3.selectAll(".bottomaxis").remove()
  container.append("g")
    .attr("class", "bottomaxis")
    .attr("transform", "translate(" + margin.left + "," + bodyHeight + ")")
    .call(d3.axisBottom(xScale));

  // remove and redraw Y axis
  yScale.domain([0, d3.max(bins, d => d.length)]);
  d3.selectAll(".leftaxis").remove()
  container.append("g")
    .attr("class", "leftaxis")
    .call(d3.axisLeft(yScale))
    .style("transform",
      `translate(${margin.left}px, 0px)`
    )

  // join data with rect
  let rects = container
    .selectAll("rect")
    .data(bins)

  // add the new bars
  rects
    .enter()
    .append("rect") // Add a new rect for each new elements
    .merge(rects) // get the already existing elements as well
      .attr("x", 1)
      .attr("transform", function(d) { return "translate(" + (xScale(d.x0) + margin.left) + "," + yScale(d.length) + ")"; })
      .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
      .attr("height", function(d) { return bodyHeight - yScale(d.length); })
      .style("fill", "#394E48")

  // delete the old bars
  rects
    .exit()
    .remove()

    */
 }

function drawHistogram(data, nbins) {
  let config = getConfig();
  let scales = getScales(data, config);
  drawBars(data, nbins, scales, config);
}

function showData(data) {
    // initialize values
    let current_bins = 50
    let current_mean = 50
    let current_sd = 100
    let n_datapoints = 5000

    // initialize plot
    drawHistogram(data, current_bins);
}

//showData()
loadData().then(showData);
