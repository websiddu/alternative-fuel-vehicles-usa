
AFV.sidebar = do ->

  renderTotalAFVGraph: ->

  prepareData: (layer, now) ->
    properties = layer.feature.properties
    data = JSON.parse(localStorage["#{now}_data"])[properties.name]

    renderedData = []
    values = []
    for i,key of window.years
      point =
        x: key
        y: data[i]

      values.push(point)
    switch now
      when 'carbon'
        features =
          values: values
          key: 'Carbon emission (MMTCO2)'
          color: 'green'
      when 'all'
        features =
          values: values
          key: "AFV's"

    renderedData.push features

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
      chart = nv.models.lineChart()
        .useInteractiveGuideline(true)
        .transitionDuration(350)
        .showLegend(true)
        .showYAxis(true)
        .showXAxis(true)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('r'))

      chart.yAxis
        .axisLabel('Number of AFVs')
        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )

      d3.select('#linegraph svg')
          .datum(data)
          .call(chart);
      chart
    # $('#linegraph').highcharts
    #   chart:
    #     type: "line"

    #   title:
    #     text: "Total AFV's"

    #   xAxis:
    #     categories: window.years

    #   yAxis:
    #     title:
    #       text: false

    #   series: [
    #     {
    #       name: "AFV"
    #       data: window.us_total_afv_line_y
    #     }
    #   ]

    return


