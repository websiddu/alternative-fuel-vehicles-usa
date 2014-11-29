AFV.tab5 = do ->

  _initChart = ->

    d3.json 'data/afv.models.json', (err, data) ->
      i = 0
      d1 = []
      while i < data.length
        if data[i]['Fuel Type'] is 'Gasoline or E85'
          d1.push(data[i])
        i++

      # visualization = d3plus.viz()
      #   .container("#models svg")  # container DIV to hold the visualization
      #   .data(d1)  # data to use with the visualization
      #   .type("chart")      # visualization type
      #   .id("Id")         # key for which our data is unique on
      #   .x("x")         # key for x-axis
      #   .y("y")        # key for y-axis
      #   .draw()             # finally, draw the visualization!

      nv.addGraph ->
        #showDist, when true, will display those little distribution lines on the axis.
        chart = nv.models
          .scatterChart()
          #.showDistX(true)
          .margin({left: 70, bottom: 30})
          #.showDistY(true)
          # .y( (d) -> d['y'] )
          # .x( (d) -> d['x'])
          # .size( (d) -> 20)
          .transitionDuration(350)
          #.color(d3.scale.category10().range())

        #Configure how the tooltip looks.
        # chart.tooltipContent (d) ->
        #   console.log d
        #   "<h3>" + d + "</h3>"

        #Axis settings
        # chart.xAxis
        #   .tickFormat d3.format(".02f")

        # chart.yAxis
        #   .tickFormat d3.format(".02f")

        #We want to show shapes other than circles.
        #chart.scatter.onlyCircles false
        myData = randomData(4, 40)

        d3.select("#models svg").datum(data).call chart
        nv.utils.windowResize chart.update
        chart


  randomData = (groups, points) -> ## groups,# points per group
    data = []
    shapes = [
      "circle"
      "cross"
      "triangle-up"
      "triangle-down"
      "diamond"
      "square"
    ]
    random = d3.random.normal()
    i = 0
    while i < groups
      data.push
        key: "Group " + i
        values: []

      j = 0
      while j < points
        data[i].values.push
          x: random()
          y: random()
          size: Math.random()
          shape: shapes[j % 6]

        j++
      i++
    data


  init: ->
    _initChart()



AFV.tab5.init()
