var width = 880;
var height = 530;
var padding = 40;

var y = d3.time.scale()
    .domain([new Date(2011, 0, 1), new Date(2011, 0, 1, 23, 59)])
    .range([0, height]);

var x = d3.time.scale()
    .domain([new Date(2011, 0, 1), new Date(2011, 11, 31)])
    .range([0, width]);

var monthNames = ["Jan", "Feb", "Mar", "April", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

function yAxisLabel(d) {
  if (d == 12) { return "noon"; }
  return (d);
}

function initialMonthDates() {
  return d3.range(0, 12).map(function(i) { return new Date(2011, i, 1) });
}

function midMonthDates() {
  return d3.range(0, 12).map(function(i) { return new Date(2011, i, 15) });
}


var svg = d3.select("body")
  .append("svg")
  .attr("width", width + padding * 2)
  .attr("height", height + padding * 2);

var nightStart = "steelblue"
var nightEnd = d3.rgb(nightStart).darker(0.9).toString()

var defs = svg.append("defs");
var sunriseGradient = defs.append('linearGradient')
    .attr("id", "sunrise-gradient")
    .attr("x1", "0%")
    .attr("x2", "0%")
    .attr("y1", "0%")
    .attr("y2", "100%");
sunriseGradient.append('stop')
    .attr("offset", "0%")
    .attr("stop-color", nightEnd)
    .attr("stop-opacity", "1");
sunriseGradient.append('stop')
    .attr("offset", "100%")
    .attr("stop-color", nightStart)
    .attr("stop-opacity", "1");

var sunsetGradient = defs.append('linearGradient')
    .attr("id", "sunset-gradient")
    .attr("x1", "0%")
    .attr("x2", "0%")
    .attr("y1", "0%")
    .attr("y2", "100%");
sunsetGradient.append('stop')
    .attr("offset", "0%")
    .attr("stop-color", nightStart)
    .attr("stop-opacity", "1");
sunsetGradient.append('stop')
    .attr("offset", "100%")
    .attr("stop-color", nightEnd)
    .attr("stop-opacity", "1");

var dayGradient = defs.append('linearGradient')
    .attr("id", "day-gradient")
    .attr("x1", "0%")
    .attr("x2", "0%")
    .attr("y1", "0%")
    .attr("y2", "100%");
dayGradient.append('stop')
    .attr("offset", "20%")
    .attr("stop-color", "lightyellow")
    .attr("stop-opacity", "1");
dayGradient.append('stop')
    .attr("offset", "50%")
    .attr("stop-color", "#FFFFC0" )
    .attr("stop-opacity", "1");
dayGradient.append('stop')
    .attr("offset", "80%")
    .attr("stop-color", "lightyellow")
    .attr("stop-opacity", "1");

// create a group to hold the axis-related elements
var axisGroup = svg.append("g")
  .attr("transform", "translate("+padding+","+padding+")");


axisGroup.selectAll(".yTicks")
    .data(d3.range(5, 22))
  .enter().append("line")
    .attr("class", "yTicks")
    .attr("x1", -5)
    .attr("x2", width + 5)
    .attr("y1",function(d) { return y(new Date(2011, 0, 1, d)); })
    .attr("y2",function(d) { return y(new Date(2011, 0, 1, d)); });

axisGroup.selectAll(".xTicks")
    .data(initialMonthDates)
  .enter().append("line")
    .attr("class", "xTicks")
    .attr("x1", x)
    .attr("x2", x)
    .attr("y1", -5)
    .attr("y2", height + 5);

// draw the text for the labels. Since it is the same on top and
// bottom, there is probably a cleaner way to do this by copying the
// result and translating it to the opposite side

axisGroup.selectAll("text.xAxisTop")
    .data(midMonthDates)
  .enter().append("text")
    .attr("class", "xAxisTop")
    .attr("x", x)
    .attr("y", -5)
    .attr("text-anchor", "middle")
    .text(function(d, i){ return monthNames[i] });

axisGroup.selectAll("text.yAxisLeft")
    .data(d3.range(5, 22))
  .enter().append("text")
    .attr("class", "yAxisLeft")
    .attr("x", -7)
    .attr("y", function(d){ return y(new Date(2011, 0, 1, d)); })
    .attr("dy", 3)
    .attr("text-anchor", "end")
    .text(yAxisLabel);

// create a group for the sunrise and sunset paths
var lineGroup = svg.append("g")
    .attr("transform", "translate("+ padding + ", " + padding + ")");

// draw the background. The part of this that remains uncovered will
// represent the daylight hours.

var bg = lineGroup.append("rect")
    .attr("class", "background")
    .attr("fill", "url(#day-gradient)")
    .attr("x", 0)
    .attr("y", 0)
    .attr("width", width)
    .attr("height", height);

var sunriseLine = d3.svg.area()
    .x(function(d){ return x(d.date) })
    .y1(function(d){ return y(new Date(2011, 0, 1, d.sunrise[0], d.sunrise[1]))})
    .interpolate("linear");

var sunsetLine = d3.svg.area()
    .x(function(d){ return x(d.date) })
    .y0(height)
    .y1(function(d){ return y( new Date(2011, 0, 1, d.sunset[0], d.sunset[1])) })
    .interpolate("linear");

// draw the solar noon
var noonLine = d3.svg.line()
    .x(function(d){ return x(d.date)})
    .y(function(d){ return y ( new Date(2011, 0, 1, d.noon[0], d.noon[1]) ) })

// finally, draw a line representing 12:00 across the entire
// visualization

lineGroup.append("line")
    .attr("class", "noon")
    .attr("x1", 0)
    .attr("x2", width)
    .attr("y1", function(){return y(new Date(2011, 0, 1, 12))} )
    .attr("y2", function(){return y(new Date(2011, 0, 1, 12))} )



// The meat of the visualization is surprisingly simple. sunriseLine
// and sunsetLine are areas (closed svg:path elements) that use the date
// for the x coordinate and sunrise and sunset (respectively) for the y
// coordinate. The sunrise shape is anchored at the top of the chart, and
// sunset area is anchored at the bottom of the chart.

d3.json("/data/2011/buenos-aires.json", function(json){

  data = json

  lineGroup.append("path")
      .attr("d", sunriseLine(data))
      .attr("class", "sunrise")
      .attr("fill", "url(#sunrise-gradient)");

  lineGroup.append("path")
      .attr("d", sunsetLine(data))
      .attr("class", "sunset")
      .attr("fill", "url(#sunset-gradient)");

  lineGroup.append("path")
      .data(data)
      .attr("class", "solar-noon")
      .attr("d", noonLine(data));

})
