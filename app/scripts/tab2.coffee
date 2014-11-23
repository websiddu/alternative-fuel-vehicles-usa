AFV.tab2 = do ->
  graph = ($ '#bar-split')
  _vechicalTypeSplit = null

  _perpareDataForVehType = (data) ->
    result = []
    j = 0
    for i, val of data
      if result[j] is undefined
        result[j] = {}

      result[j].values = _getDataFromFlatArray(val)
      result[j].key = i
      j++

    return result


  _getDataFromFlatArray = (data) ->
    i = 0
    start_year = 2004
    r = []
    while i < data.length
      coord = {
        x: start_year
        y: data[i]
      }
      r.push coord
      i++
      start_year++

    return r

  _initVehicleTypeGraph = (data) ->
    d3.json 'data/veh.type.json', (err, data) ->
      _vechicalTypeSplit = data

      nv.addGraph ->
        chart = nv.models
          .stackedAreaChart()
          .margin(left: 70)
          .useInteractiveGuideline(true)
          .transitionDuration(350)
          .showLegend(false)
          .showYAxis(true)
          .showXAxis(true)
          #.height(320)

        chart.xAxis
          .axisLabel('Year')
          .tickFormat(d3.format('f'))

        chart.yAxis
          .axisLabel('Count')
          .orient('left')
          .showMaxMin(false)
          .tickFormat( (d) ->
            prefix = d3.formatPrefix(d)
            prefix.scale(d) + prefix.symbol
          )

        myData = _perpareDataForVehType(window.veh_types) #You need data...

        d3.select("#multiline-split svg").datum(myData).call chart #Finally, render the chart!

        #d3.select("#multiline-split .nv-legendWrap").attr("class", "hide")

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
