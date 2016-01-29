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
				  width = 1200 - margin.left - margin.right - 100,
				  height = 800 - margin.top - margin.bottom - 100;


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

var pbs = [
 {player_b: 'eda2f039602d9be91938d7be7ad1db303b9db6b3',  key:'Chat',    count:126},
 {player_b: '2848665d7e224c7a3be91d4b2fe3056e8d45c233',	 key:'Chat',	count:122},
 {player_b: 'e024a19b809e5296ed8f8955abe2de130e6659be',	 key:'Chat',	count:106},
 {player_b: '90b1fb5998bd4b903d0374c0491adb3662b6ee0a',	 key:'Chat',	count:94},
 {player_b: '27f170b7e1d60627d4237c42247380718f301eae',	 key:'Chat',	count:86},
 {player_b: '97400cd2cc77407a482dc7eae4fa237ecc665b8f',	 key:'Chat',	count:84},
 {player_b: '9f852dd428cf8c8638ecca8bc140af290be8512c',	 key:'Chat',	count:82},
 {player_b: '4a74e27575ff5bf59be961e4c595f11dcc75f638',	 key:'Chat',	count:82},
 {player_b: 'cf17291e08ce94c7a0276473c449402f028c07f6',	 key:'Chat',	count:76},
 {player_b: 'd807bbe8b1b8be4cd5210088cd648fb56b8da4f9',	 key:'Chat',	count:62},
 {player_b: '20c4959245c8dd7b632658e33f9fa911d25996ad',	 key:'KilledBy', count:44},
 {player_b: '0442f040899d219249a6ec7e2bbbd93215a60e4f',	 key:'KilledBy',	count:26},
 {player_b: 'ca79b06f3201741837aac183d330d1f24723b84a',	 key:'KilledBy',	count:23},
 {player_b: 'd175d9a7a58df393c415514d8cb914ec925b2484',	 key:'KilledBy',	count:21},
 {player_b: 'e7f369c5a34a625a1cebf36b842d020c8f55a58b',	 key:'KilledBy',	count:21},
 {player_b: 'f3efc34dd3a33199954fae38c036ab7757aec0b0',	 key:'KilledBy',	count:21},
 {player_b: '1ddcaf400ef8a8ca87d3711ba707ba2b502423fb',	 key:'KilledBy',	count:20},
 {player_b: 'ef8a2e055ecec596bdd32df5c5be1c3de14ae2ec',	 key:'KilledBy',	count:20},
 {player_b: '37d873a1c3410d75d07576accd636fef1a538dbf',	 key:'KilledBy',	count:20},
 {player_b: '5d789a1ca9fd682c2b959a0a6214694a6b5b113d',	 key:'KilledBy',	count:20},	
]

d3.csv("data/print.csv", function(error, data) {
	var fulldata = data;
	if (error) throw error;

	var player_data = [], count = 0;
	
	console.log(pbs);
	var kill = [], chat = [], cnt1 = 0, cnt2 = 0;
	for(var i = 0; i < pbs.length; i++){
		if(pbs[i].key == 'Chat')
		{
			chat[cnt1] = pbs[i].player_b;
			cnt1++;
		}
		if(pbs[i].key == 'KilledBy')
		{
			kill[cnt2] = pbs[i].player_b;
			cnt2++;
		}
	}

	console.log(kill);
	console.log(chat);
	
	var path = d3.selectAll(".path")
		        .on("click", function(d){
	           // svg.append("circle")
	           // .attr("r", 10)
	           // .attr("transform", "translate("+ (radius*(-1) - 50 ) + ",0)");
	           
	           var select = d3.select("body")
					.append("select")
					.attr("class", "select_pb")
					.on('change', onchange);
					//.append("text");
			   var option = select
							.selectAll('option')
							.data(kill).enter()
							.append('option')
							.text(function(d) {return d;});
	        });

	
	
	function onchange(){
		

		selectValue = d3.select('select').property('value');
		console.log(selectValue);
		console.log(" " + selectValue);
		console.log(fulldata[0].player_b);
		for(var i = 0; i < fulldata.length; i++){
			if(fulldata[i].player_b == (" " + selectValue))
			{
				console.log("hi");
				player_data[count] = fulldata[i];
				count++;
			}
		}
		console.log("player_data");
		console.log(player_data);
	
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
	
		var axes = d3.selectAll('.xaxis');

   		if(axes){
			console.log(axes);
		   	axes.remove();
		}
		
		var axes2 = d3.selectAll('.yaxis');

   		if(axes2){
			console.log(axes2);
		   	axes2.remove();
		}
		// add the axes
		bvis.append("g")
		  	.attr("class", "xaxis")
			.attr("transform", "translate(10," + (height - margin.top + 10) +")")
		  	.call(xAxis)
				.append("text")
				.attr("x", width/4)
				.attr("y", 30)
				.style("text-anchor", "middle")
				.text("Time (1000m)");
	
		bvis.append("g")
		  .attr("class", "yaxis")
			.call(yAxis)
			.append("text")
			.attr("y", -40)
			.attr("dy", "3em")
			.style("text-anchor", "end")
			.text("Player A");
	
		console.log(player_data[0].server_id);
		console.log(player_data[0].start_t);
		var children = d3.selectAll(".dot");

   		if(children){
			console.log(children);
		   	children.remove();
		}
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
						.style("left", (d3.event.pageX) +"px")
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


							

		   	return selectValue;
		};
	
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
