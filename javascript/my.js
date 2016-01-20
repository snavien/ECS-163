// Calling the file my.js.
// Make sure you have already loaded the
// d3 file and html elements
// if you want to reference it here.


// set dimensions of the canvas / graph
var margin = {top: 20, right: 20, bottom: 30, left: 50},
				  width = 800 - margin.left - margin.right,
				  height = 500 - margin.top - margin.bottom;

// set the ranges
var x = d3.scale.ordinal().rangeRoundBands([0, height], .1); //players
var y = d3.scale.linear().range([width, 0]); //time

// define the axes
var xAxis = d3.svg.axis()
					.ticks(20)
					.scale(y)
    			.orient("bottom");
var yAxis = d3.svg.axis()
					.ticks(5)
			    .scale(x)
			    .orient("left")
			    .ticks(10);

// add the svg canvas to the div with id = barchart
var svg = d3.select("#barchart").append("svg")
	    	.attr("width", width + margin.left + margin.right)
	    	.attr("height", height + margin.top + margin.bottom)
	    	.attr("class", "barchart_svg")
	  		.append("g")
	    	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// this div is used for the tooltip
var div = d3.select("body").append("div")
		    .attr("class", "tooltip")
		    .style("opacity", 0);

// Load the data, process it, and display it with a bar chart.
// You can't load the fullsize file, so you'll need to do some
// preprocessing to break the data up or aggregate it
d3.csv("data/print3.csv", function(error, data) {
	if (error) throw error;
	// var player_data = data.filter(function(d) {
	// 	return d.player_b === "00040857941a98d183a9ffcc5efc12a5e73a91ad")
	// });
	var player_data = [], count = 0;
	for(var i = 0; i < data.length; i++){
		if(data[i].player_b == ' 00040857941a98d183a9ffcc5efc12a5e73a91ad')
		{
			player_data[count] = data[i];
			count++;
		}
	}


	// get the total time spent on each key
	var max = d3.max(player_data, function(d) {
	return +d.stop_t;
//  	return d3.max(d.stop_t, function(e) { return d3.max(e); });
	});

	var min = d3.min(player_data, function(d) {
		return +d.start_t;
		//return d3.min(d.start_t, function(e) { return d3.min(e); });
	});
	console.log(max);
	console.log(min);
//	var max = d3.max(data, function(d){return +d.stop_t};);
		//var min = d3.min(player_data, function(d){return +d.start_t};)
	var times = calc_time_per_key(player_data);

//	var min = d3.min(player_data, function(d){return +d.start_t};)
	// scale the data ranges
	// the x domain goes over the set of keys
	x.domain(player_data.map(function(d) { return d.player_a; }));
	// y goes from 0 to the max value in times

	y.domain([max,min]);

	// add the axes
	svg.append("g")
	  	.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
	  	.call(xAxis);

	svg.append("g")
	  	.attr("class", "y axis")
		.call(yAxis)
		.append("text")
		//.attr("transform", "rotate(180)")
		.attr("y", -40)
		.attr("dy", "3em")
		.style("text-anchor", "end")
		.text("Player A");

	console.log(player_data[0].server_id);
	console.log(player_data[0].start_t);

	// add the bars
	svg.selectAll(".dot")
		.data(player_data)
		.enter().append("circle")
			.attr("class", "dot")
      .attr("r", function(d){ return d.stop_t - d.start_t; })
			.attr("fill", function(d){ if(d.key == " KilledBy") return "red"; else return "blue";})
      .attr("cx", function(d) {
				console.log(d.player_a);
				return x(d.player_a); })
			.attr("fill-opacity", 0.70)
      .attr("cy", function(d) { return y(d.start_t); })
			//.attr("x", )
			//.attr("width", x.rangeBand())
			//.attr("y", )
			//.attr("height", function(d) { return height - y(d.total_time); })
			.on("mouseover", function(d) {
				div.transition()
					.duration(200)
					.style("opacity", .9);
				div.html(d.key + " = " + d.player_a)
					.style("left", (x(d.key) + x.rangeBand() + x.rangeBand()/2) + "px")
                	.style("top", (d3.event.pageY - 28) + "px")
				})
			.on("mouseout", function(d) {
				div.transition()
                	.duration(500)
                	.style("opacity", 0);
				});
	console.log("done");
});

// this gets the total time spent on each key
// from on the loaded file and adds
// it to a javascript object called time_per_key.
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

  //convert to array form
  var time_per_key_array = Object.keys(time_per_key).map(function (key) {
    return {
    	"key": key,
      	"total_time": time_per_key[key]
    };
  });

  return time_per_key_array;
}
