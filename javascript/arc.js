/** OVERVIEW CHART**/
//TODO: Create overview of actions or servers
var width = 960,
    height = 500,
    radius = Math.min(width, height) / 2;
console.log("here");
var min_cnt = 0,
		max_cnt = 0;
var color = d3.scale.ordinal()
    .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00", "blue"]);

//var color = d3.scale.linear.do-main([min_cnt, max_cnt]).range("red", "black");

var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(radius - 70);

var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.count; });


var svg = d3.select("#donutchart").append("svg")
    .attr("width", width)
    .attr("height", height)
  	.append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

d3.csv("all_actions.csv", type, function(error, data) {
	  if (error) throw error;

		console.log("!");
	  var g = svg.selectAll(".arc")
	      .data(pie(data))
	    	.enter().append("g")
	      .attr("class", "arc");

	  g.append("path")
	      .attr("d", arc)
	      .style("fill", function(d) { return color(d.count); });

	  g.append("text")
	      .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
	      .attr("dy", ".35em")
	      .text(function(d) { return d.actions; });
	});

	function type(d) {
	  d.count = +d.cout;
	  return d;
}
