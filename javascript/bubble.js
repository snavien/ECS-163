// Calling the file my.js.
// Make sure you have already loaded the
// d3 file and html elements
// if you want to reference it here.



/** WINDOW DIMENSIONS **/
// set dimensions of the canvas / graph
var base_width = $(window).width();
var base_height = $(window).height();

//TODO: http://stackoverflow.com/questions/13280809/jquery-resize-on-window-scale-up-or-scale-down
var margin = {top: 20, right: 20, bottom: 60, left: 250},
				  width = 1000 - margin.left - margin.right - 100,
				  height = 700 - margin.top - margin.bottom - 100;


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

// add the svg canvas to the div with id = bubblechart
var bvis = d3.select("#bubblechart").append("svg")
	    	.attr("width", width + margin.left + margin.right)
	    	.attr("height", height + margin.top + margin.bottom)
	    	.attr("class", "bubblechart_svg")
	  		.append("g")
	    	.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// this div is used for the tooltip
var div = bvis.append("div")
		    .attr("class", "tooltip")
		    .style("opacity", 0);

// Load the data, process it, and display it with a bubble chart.
// You can't load the fullsize file, so you'll need to do some
// preprocessing to break the data up or aggregate it

var player_b; 
d3.csv("data/top10.csv", function(error, topdata){
		console.log(topdata);
		player_b = topdata;
	});
console.log(player_b);
d3.csv("data/print.csv", function(error, data) {
	if (error) throw error;

	var player_data = [], count = 0;
	for(var i = 0; i < data.length; i++){
		if(data[i].player_b == '')
		{
			player_data[count] = data[i];
			count++;
		}
	}

	
	
	console.log(player_b);
	
	var select = bvis
				.append("select")
				.attr("class", "select_pb")
				.on('change', onchange);
	var option = select
				.selectAll('option')
				.data(player_b).enter()
				.append('option')
				.text(function(d) {return d;});
	function onchange(){
			selectValue = d3.select('select').property('value');
			d3.select('body')
			   .append('p')
			   .text(selectValue + ' is the last selected option.');
			   return selectValue;
			};
	

	// get the total time spent on each key
	var max = d3.max(player_data, function(d) {
		return +d.stop_t/1000;
	});

	var min = d3.min(player_data, function(d) {
		return +d.start_t/1000;
	});
	console.log(max);
	console.log(min);
	
	var times = calc_time_per_key(player_data);

	// scale the data ranges
	// the x domain goes over the set of keys
	x.domain(player_data.map(function(d) { return d.player_a; }));
	
	// y goes from 0 to the max value in times
	y.domain([max,min]);

	// add the axes
	bvis.append("g")
	  	.attr("class", "x axis")
		.attr("transform", "translate(10," + (height - margin.top * 4 - 10) +")")
	  	.call(xAxis)
			.append("text")
			.attr("x", width/4)
			.attr("y", 30)
			.style("text-anchor", "middle")
			.text("Time (1000m)");
			// .append("text")
			// .attr("y", 450)
			// .style("text-anchor", "end")
			// .text("Time");

	bvis.append("g")
	  .attr("class", "y axis")
		.call(yAxis)
		.append("text")
		.attr("y", -40)
		.attr("dy", "3em")
		.style("text-anchor", "end")
		.text("Player A");

	console.log(player_data[0].server_id);
	console.log(player_data[0].start_t);

	   
	// add the dots
	var dots = bvis.selectAll(".dot")
		.data(player_data)
		.enter().append("circle")
		.attr("class", "dot")
      	.attr("r", function(d){ return d.stop_t - d.start_t; })
		.attr("fill", function(d){ if(d.key == " KilledBy") return "red"; else return "blue";})
      	.attr("cy", function(d) {
				return x(d.player_a); })
		.attr("fill-opacity", 0.70)
      	.attr("cx", function(d) { return y(d.start_t/1000); })
		.on("mouseover", function(d) {
			d3.select(this).attr("r", d3.select(this).attr("r") * 1 * 2);
			if(d.key == " KilledBy"){
				div.transition()
					.duration(200)
					.style("opacity", .95);
				div.html("killed " + d.player_a + " for " + (d.stop_t - d.start_t) + "min")
					.style("left", (d3.event.pageX) +"px")//(x(d.key) + x.rangeBand() + x.rangeBand()/2) + "px")
					.style("top", (d3.event.pageY ) + "px")
					.style("font", "9.5px arial, serif")
			}
			else{
				div.transition()
					.duration(200)
					.style("opacity", .95);
				div.html("chatted with " + d.player_a + " for " + (d.stop_t - d.start_t) + "min")
					.style("left", d3.event.pageX + "px")
					.style("top", (d3.event.pageY) + "px")
					.style("font", "9.5px arial, serif")
			}

			})
		.on("mouseout", function(d) {
			d3.select(this).attr("r", (d.stop_t - d.start_t));
			div.transition()
            	.duration(500)
            	.style("opacity", 0);
			});
		bvis.append(dots)
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
