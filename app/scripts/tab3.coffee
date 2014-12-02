AFV.tab3 = do ->
  _fuelTypeData = null
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
    myData = _perpareDataForVehType(window.fuel_type)
    AFV.tab3.initFuelTypeGraph(myData)
    return

  _getVehicleTypeData = ->
    d3.json 'data/fuel.type.json', (err, data) ->
      _fuelTypeData = data
      _loadInitalVehicleTypeGraph()
      #myData = _perpareDataForVehType(window.veh_types)
      #AFV.tab2.initFuelTypeGraph(myData)
      return
    return

  loadByStateFuelTypeGraph: (target) ->
    currentState = target.feature.properties.name
    return if(_fuelTypeData is undefined)

    stateData = _perpareDataForVehType _fuelTypeData[currentState], true
    AFV.tab3.initFuelTypeGraph(stateData)

  initFuelTypeGraph: (data) ->
    nv.addGraph ->
      chart = nv.models
        .lineChart()
        .margin(left: 55)
        .useInteractiveGuideline(true)
        .transitionDuration(350)
        .showLegend(true)
        .showYAxis(true)
        .showXAxis(true)
        # .controlLabels({
        #   stacked: "Total number"
        #   expanded: "Percent of total"
        # })
        #.height(320)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('f'))

      chart.yAxis
        .axisLabel("Number of AFVs")
        .orient('left')
        .showMaxMin(false)
        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )

      d3.select("#fuel-split svg").datum(data).call chart #Finally, render the chart!

      #d3.select("#multiline-split .nv-legendWrap").attr("class", "hide")

      $('.sidebar').on 'scrollend', ->
        chart.update()

      nv.utils.windowResize ->
        chart.update()
        return

      chart

  init: ->
    _getVehicleTypeData()
    # setTimeout ->
    #   _loadInitalVehicleTypeGraph()
    # , 1000

AFV.tab3.init()
