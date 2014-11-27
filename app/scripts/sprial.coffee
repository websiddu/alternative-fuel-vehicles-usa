AFV.sprial = do ->

  options = {
    pointLabelFontFamily : "'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif",
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>"
  }

  getFlatData: (data) ->
    newArr = []
    for key, val of data
      newArr.push(val)

    return newArr

  initSpiderWeb: ->
    $("#fuel-radial").highcharts
      chart:
        polar: true
        type: "line"
        height: 280
      credits: false
      exporting: false

      title: false
        # text: "Number of AFVs vs Fuel consumption"
        # x: -80

      pane:
        size: "80%"

      xAxis:
        categories: fuel_type_con
        tickmarkPlacement: "on"
        lineWidth: 0

      yAxis:
        gridLineInterpolation: "polygon"
        lineWidth: 0
        min: 0

      tooltip:
        shared: true
        pointFormat: "<span style=\"color:{series.color}\">{series.name}: <b>${point.y:,.0f}</b><br/>"

      legend:
        align: "right"
        verticalAlign: "top"
        y: 70
        layout: "vertical"

      series: [
        {
          name: "Fuel consumption"
          data: AFV.sprial.getFlatData(window.fuel_consumption_sum)
          pointPlacement: "on"
        }
        {
          name: "Number of AFVs"
          data: AFV.sprial.getFlatData(window.fuel_type_sum)
          pointPlacement: "on"
        }
      ]



  init: ->
    data = {
      labels: fuel_type_con
      datasets: [
          {
            label: "Fuel consumption",
            fillColor: "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: AFV.sprial.getFlatData(window.fuel_consumption_sum)
          }
          {
            label: "Number of AFV's",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: AFV.sprial.getFlatData(window.fuel_type_sum)
          }

      ]
    }




    ctx = document.getElementById("fuel-radial").getContext("2d");
    ctx1 = document.getElementById("fuel-bar").getContext("2d");
    myRadarChart = new Chart(ctx).Radar(data, options)
    myBarChart = new Chart(ctx1).Bar(data, options);



# AFV.sprial.initSpiderWeb()
AFV.sprial.init()

