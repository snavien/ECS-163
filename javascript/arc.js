/** OVERVIEW CHART**/
//TODO: Create overview of actions or servers
var width = 1000,
    height = 600,
    radius = Math.min(width, height) / 2;
console.log("here");
var min_cnt = 0,
		max_cnt = 0;


var color = d3.scale.category20b();
// var color = d3.scale.ordinal()
//   .range(['#A60F2B', '#648C85', '#B3F2C9', '#528C18', '#C3F25C']);
//var color = d3.scale.linear.do-main([min_cnt, max_cnt]).range("red", "black");

var arc = d3.svg.arc()
    .startAngle(function(d){ return d.startAngle; })
    .endAngle(function(d){ return d.endAngle; })
    .outerRadius(radius - 10)
    .innerRadius(radius - 90);

var pie = d3.layout.pie()
    .value(function(d) { return d.count; })
    .sort(null);

var svg = d3.select("#donutchart")
    .append("svg")
    .attr("width", width + 100)
    .attr("height", height + 150)
  	.append("g")
    .attr("transform", "translate(" + (width + 50) / 2 + "," + (height + 40) / 2 + ")");


var tooltip_arc = d3.select("#donutchart")
              .append('div')
              .attr('class', 'label');
tooltip_arc.append('div')
       .attr('class', 'label');

tooltip_arc.append('div')
       .attr('class', 'count');

tooltip_arc.append('div')
      .attr('class', 'percent');

d3.csv("data/all_actions.csv", function(error, data) {
    if (error) throw error;
    var total = 0;
		data.forEach(function(d){
      d.count = +d.count;
      total = total + d.count;
    });
	  var g = svg.selectAll(".arc")
	      .data(pie(data))
	    	.enter().append("g")
	      .attr("class", "arc")
        .on('mouseover', function() {
            var current = this;
            var others = svg.selectAll(".arc").filter(function(el) {
                return this != current
            });
            others.selectAll("path").style('opacity', 0.60);
        })
        .on('mouseout', function() {
            var current = this;
            var others = svg.selectAll(".arc").filter(function(el) {
                return this != current
            });
            others.selectAll("path").style('opacity', 1);
        });

    var arcOver = d3.svg.arc()
        .outerRadius(radius + 10)
        .innerRadius(radius - 70);

	  var path = g.append("path")
              .data(pie(data))
      	      .attr("d", arc)
      	      .style("fill", function(d, i) {return color(i); })
              .style("stroke", "white")
              .style("stroke-width", "2")
              .attr("class", "path")
              .attr("transform", "translate(400,0)")
              .on("mouseenter", function(d) {
                d3.select(this)
                   .attr("stroke","white")
                   .transition()
                   .duration(500)
                   .attr("d", arcOver)
                   .attr("stroke-width",9);
               })
               .on("mouseleave", function(d) {
                   d3.select(this)
                      .transition()
                      .attr("d", arc)
                      .attr("stroke","none");
               });


    path.on("mousemove", function(d){
          var percent = Math.round(1000 * d.data.count / total) / 10;
          var lab = tooltip_arc.select('.label').html(d.label);

          tooltip_arc.select('.count').html(d.count);
          var perc = tooltip_arc.select('.percent').html(d.data.action + '<p>' + percent + '%');
          tooltip_arc.style('display', 'inline-block');
          perc.style("left", d3.event.pageX+"px");
          perc.style("top", d3.event.pageY+"px");
          perc.style("opacity", ".95");
        })
        .on("mouseout", function(d){
            tooltip_arc.style("display", "none");
        })
        .on("click", function(d){
           svg.append("circle");

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
    legend.append('rect')
         .attr('width', legendRectSize)
         .attr('height', legendRectSize)
         .style('fill', color)
         .style('stroke', color);
    legend.append('text')
                .data(data)
                .attr('x', legendRectSize + legendSpacing)
                .attr('y', legendRectSize - legendSpacing)
                .text(function(d) { return d.action; });


  });

  $( "#slider" ).slider({
      value: 0,
      min: 0,
      max: 3,
      step: 1,
      slide: function( event, ui ) {
          update(ui.value);
          console.log(ui.value);
        }
  })
  .each(function() {

    //
    // Add labels to slider whose values
    // are specified by min, max and whose
    // step is set to 1
    //

    // Get the options for this slider
    var opt = $(this).data().uiSlider.options;

    // Get the number of possible values
    var vals = opt.max - opt.min;

    // Space out values
    for (var i = 0; i <= vals; i++) {

      var el = $('<label>'+dataStructure[i].label+'</label>').css('left',(i/vals*100)+'%');

      $( "#slider" ).append(el);

    }

  });

  update(0);
