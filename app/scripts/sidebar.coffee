
AFV.sidebar = do ->

  carbon_colors = ["#b30000","#ef6548","#fc8d59", "#fdbb84"]
  afv_colors = ['#08306b', '#2171b5', '#4292c6', '#6baed6']

  prepareDataSelect: (states) ->
    result = []
    i = 0
    while i < states.length
      r1 = AFV.sidebar.prepareData(states[i], i)
      result = result.concat(r1)
      i++

    result.sort (a, b) -> a.yAxis > b.yAxis

    return result



  prepareData: (layer, index = 0) ->
    if typeof layer is 'string'
      state = layer
    else
      state = layer.feature.properties.name

    dataAll = JSON.parse(localStorage["all_data"])[state]
    dataCarbon = JSON.parse(localStorage["carbon_data"])[state]

    renderedData = []
    values = []
    values1 = []
    for i,key of window.years
      point =
        x: key
        y: dataCarbon[i]

      point2 =
        x: key
        y: dataAll[i]

      values.push(point)
      values1.push(point2)

    features = [
      {
        key: "Total AFVs in #{state}"
        originalStream: 'AFVs'
        seriesIndex: 0
        type: 'line'
        color: afv_colors[index]
        values: values1
        yAxis: 1
      }
      {
        key: "Carbon Emissions in #{state}"
        originalStream: 'Carbon'
        seriesIndex: 1
        type: 'line'
        values: values
        color: carbon_colors[index]
        yAxis: 2
      }
    ]


    renderedData = features

    renderedData


  initCarbonEmissions: (data) ->
    sidebarWidth = $('.sidebar').width()
    $('.ng-svg').css('width', sidebarWidth)

    nv.addGraph ->
      chart = nv.models.lineChart()
        .useInteractiveGuideline(true)
        .transitionDuration(350)
        .showLegend(true)
        .showYAxis(true)
        .showXAxis(true)

        #.width(sidebarWidth)
        #.forceY([0,200])

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('r'))

      chart.yAxis
        .axisLabel('Carbon emission (MMTCO2)')

      d3.select('#linegraph-carbon svg')
          .datum(data)
          .call(chart);
      chart

  totalAFVs: (data) ->

    nv.addGraph ->
      chart = nv.models.multiChart()
        #.useInteractiveGuideline(true)
        #.transitionDuration(350)
        .showLegend(true)
        .customLegend(true)

        #.showYAxis(true)
        #.showXAxis(true)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('r'))


      chart.yAxis1
        .axisLabel('Number of AFVs')

        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )

      chart.yAxis2
        .axisLabel('Carbon emission (MMTCO2)')

        # .tickFormat( (d) ->
        #   prefix = d3.formatPrefix(d)
        #   prefix.scale(d) + prefix.symbol
        # )


      d3.select('#linegraph svg')
        .datum(data)
        .call(chart)
      chart

    return


