// set dimensions of the canvas / graph
var margin = {top: 20, right: 20, bottom: 30, left: 50},
			  width = 800 - margin.left - margin.right,
			  height = 500 - margin.top - margin.bottom;

var time = d3.scale.linear().rangeRoundBands([0, width], .1);

var loc = d3.scale.ordinal().range([height, 0]);

var xAxis = d3.svg.axis()
              .scale(time)
              .orient("bottom");

var yAxis = d3.svg.axis()
              .scale(loc)
              .orient("left");
              .ticks(20);

var svg = d3.select("#chart").append("svg")
	    	.attr("width", width + margin.left + margin.right)
	    	.attr("height", height + margin.top + margin.bottom)
	    	.attr("class", "chart_svg")
	  		.append("g")
	    	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var div = d3.select("body").append("div")
            .attr("class", "tooltip")
            .style("opacity", 0);


// load the data:
d3.csv("data/print.csv", function(error, data)){
  if (error) throw error;

  var times = calc_time_per_key(data);

  time.domain([0, d3.max(times, function(d) {return d.total_time;})]);
  location.domain(data.map(function(d) {return d.key}));

  // add the axes
  svg.append("g")
      .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
      .call(xAxis);
  svg.append("g")
      .attr("class", "y axis")
    .call(yAxis)
  .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", -40)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Time (m)");

}

function calc_time_per_key(data) {
  var time_per_key = {};
  for(var i = 0; i < data.length; i+=1)
  {
    var row = data[i];
		if(row.key in time_per_key)
    {
			time_per_key[row.key] += row.stop_t - row.start_t;
    }
    else
    {
			time_per_key[row.key] = row.stop_t - row.start_t;
    }
  }
