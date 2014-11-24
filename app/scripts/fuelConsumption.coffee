AFV.fc = do ->
  _fuelConsumptionData = null
  myData = null

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

  _loadInitalVehicleTypeGraph = ->
    myData = _perpareDataForVehType(window.fuel_consumption)
    AFV.fc.initFuelTypeGraph(myData)
    return

  _getFuelConsumpationData = ->
    d3.json 'data/fuel.consumption.json', (err, data) ->
      _fuelConsumptionData = data
      #myData = _perpareDataForVehType(window.veh_types)
      #AFV.tab2.initFuelTypeGraph(myData)
      return
    return

  loadByStateFuelConsumptionGraph: (target) ->
    currentState = target.feature.properties.name
    return if(_fuelConsumptionData is undefined)

    stateData = _perpareDataForVehType _fuelConsumptionData[currentState], true
    AFV.fc.initFuelTypeGraph(stateData)

  initFuelTypeGraph: (data) ->
    nv.addGraph ->
      chart = nv.models
        .stackedAreaChart()
        .margin(left: 55)
        .useInteractiveGuideline(true)
        .transitionDuration(550)
        .showLegend(true)
        .showYAxis(true)
        .showXAxis(true)
        .showControls(false)
        # .controlLabels({
        #   stacked: "Total number"
        #   expanded: "Percent of total"
        # })
        #.height(320)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('f'))

      chart.yAxis
        .axisLabel("Thousand Gasoline-Equivalent Gallons")
        .orient('left')
        .showMaxMin(false)
        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )

      d3.select("#fuel-consumption svg").datum(data).call chart #Finally, render the chart!

      #d3.select("#multiline-split .nv-legendWrap").attr("class", "hide")

      nv.utils.windowResize ->
        chart.update()
        return

      chart

  init: ->
    _getFuelConsumpationData()
    _loadInitalVehicleTypeGraph()

AFV.fc.init()
