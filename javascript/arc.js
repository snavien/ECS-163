/** OVERVIEW CHART**/
//TODO: Create overview of actions or servers
var width = 360,
    height = 360,
    radius = Math.min(width, height) / 2;
console.log("here");
var min_cnt = 0,
		max_cnt = 0;


var color = d3.scale.category20b();
// var color = d3.scale.ordinal()
//   .range(['#A60F2B', '#648C85', '#B3F2C9', '#528C18', '#C3F25C']);
//var color = d3.scale.linear.do-main([min_cnt, max_cnt]).range("red", "black");

var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(radius - 70);

var pie = d3.layout.pie()
    .value(function(d) { return d.count; })
    .sort(null);

var svg = d3.select("#donutchart")
    .append("svg")
    .attr("width", width)
    .attr("height", height)
  	.append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

var tooltip = d3.select("body")
              .append('div')
              .attr('class', 'label');
tooltip.append('div')
       .attr('class', 'label');

tooltip.append('div')
       .attr('class', 'count');

tooltip.append('div')
      .attr('class', 'percent');


d3.csv("data/all_actions.csv", function(error, data) {
    if (error) throw error;

		console.log("!");
	  var g = svg.selectAll(".arc")
	      .data(pie(data))
	    	.enter().append("g")
	      .attr("class", "arc");


	  var path = g.append("path")
              .data(pie(data))
      	      .attr("d", arc)
      	      .style("fill", function(d, i) {return color(i); })
              .style("stroke", "white")
              .style("stroke-width", "2")
              .attr("class", "path");
    // var path = svg.selectAll('path')
    path.on("mouseover", function(d, i){
          console.log("pooop");
          var total = d3.sum(data.map(function(d) {
            return d.count;
          }));
          console.log("!");
          var percent = Math.round(1000 * d.count / total) / 10;
          tooltip.select('.label').html(d.label);
          tooltip.select('.count').html(d.count);
          tooltip.select('.percent').html(percent + '%');
          tooltip.style('display', 'block');
        });

	  g.append("text")
	      .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
	      .attr("dy", ".35em")
	      .text(function(d) { return d.action; });

    var legendRectSize = 18,
        legendSpacing = 4;

    var legend = svg.selectAll('.legend')
                .data(color.domain())
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', function(d, i) {
                  var height = legendRectSize + legendSpacing;
                  var offset =  height * color.domain().length / 2;
                  var horz = -2 * legendRectSize;
                  var vert = i * height - offset;
                  return 'translate(' + horz + ',' + vert + ')';
                });
    legend.append('rect')                                                          .attr('width', legendRectSize)
         .attr('height', legendRectSize)
         .style('fill', color)
         .style('stroke', color);
    legend.append('text')
                .data(data)
                .attr('x', legendRectSize + legendSpacing)
                .attr('y', legendRectSize - legendSpacing)
                .text(function(d) { return d.action; });

    percent(data);
  });

  function percent(d) {
    var sum = sum + int(d.count);
    console.log(sum);
  }
