AFV.tab2 = do ->
  graph = ($ '#bar-split')
  _vechicalTypeSplit = null

  _perpareDataForVehType = (data) ->


  _initVehicleTypeGraph = ->
    d3.json 'data/veh.type.json', (err, data) ->
      _vechicalTypeSplit = data

      nv.addGraph ->
        chart = nv.models
          .lineChart()
          .margin(left: 100)
          .useInteractiveGuideline(true)
          .transitionDuration(350)
          .showLegend(true)
          .showYAxis(true)
          .showXAxis(true)

        #Chart x-axis settings
        chart.xAxis.axisLabel("Time (ms)").tickFormat d3.format(",r")
        #Chart y-axis settings
        chart.yAxis.axisLabel("Voltage (v)").tickFormat d3.format(".02f")

        # Done setting the chart up? Time to render it!
        myData = _perpareDataForVehType(_vechicalTypeSplit) #You need data...
        #Select the <svg> element you want to render the chart in.
        #Populate the <svg> element with chart data...
        d3.select("#chart svg").datum(myData).call chart #Finally, render the chart!

        #Update the chart when window resizes.
        nv.utils.windowResize ->
          chart.update()
          return

        chart



  _initGraph = ->
    sidebarWidth = $('.sidebar').width()
    $('.ng-svg').css('width', sidebarWidth)

    nv.addGraph ->
      chart = nv.models.multiBarChart()
        .transitionDuration(350)
        .reduceXTicks(true)
        .rotateLabels(0)
        .showControls(true)
        .groupSpacing(0.2)
        .width(sidebarWidth)
        .margin({left: 55})
        .height(270)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('f'))
        .showMaxMin(false)

      chart.yAxis
        .axisLabel('Count')
        .orient('left')
        .showMaxMin(false)
        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )


      d3.select('#bar-split svg')
          .datum(window.us_total_aft_split)
          .call(chart);
      chart




  init: ->
    _initGraph()
    _initVehicleTypeGraph()

AFV.tab2.init()
