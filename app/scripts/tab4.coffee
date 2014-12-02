AFV.tab4 = do ->


  _numberOfModelsOffered = ->
    nv.addGraph ->
      chart = nv.models.multiBarChart()
        .transitionDuration(350)
        .reduceXTicks(true)
        .rotateLabels(0)
        .showControls(true)
        .legendPosition('bottom')
        .groupSpacing(0.2)
        .margin({left: 55})

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('f'))
        .showMaxMin(false)

      chart.yAxis
        .axisLabel("Number of Models")
        .orient('left')
        .showMaxMin(false)
        .tickFormat( (d) ->
          prefix = d3.formatPrefix(d)
          prefix.scale(d) + prefix.symbol
        )
      d3.select('#models-split svg')
          .datum(window.models_data)
          .call(chart);

      chart

  init: ->
    _numberOfModelsOffered()

AFV.tab4.init()
