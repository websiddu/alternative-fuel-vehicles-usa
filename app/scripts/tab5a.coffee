AFV.tab5a = do ->
  dataForSmall = [
    {
      key: "Green house gases",
      values: [
        {
          "x" : 50
          "y" : 3.6
          "color": "#bc5679"
        } ,
        {
          "x" : 45
          "y" : 4.0
          "color": "#bc5679"
        } ,
        {
          "x" : 40
          "y" : 4.5
          "color": "#bc5679"
        } ,
        {
          "x" : 35
          "y" : 5.1
          "color": "#bc5679"
        } ,
        {
          "x" : 30
          "y" : 6.0
          "color": "#bc5679"
        } ,
        {
          "x" : 25
          "y" : 7.2
          "color": "#bc5679"
        }
        {
          "x" : 20
          "y" : 9.0
          "color": "#bc5679"
        }
        {
          "x" : 15
          "y" : 12.0
          "color": "#bc5679"
        }
      ]
    }
  ]

  _initSmallGraph = ->
    nv.addGraph ->
      chart = nv.models.discreteBarChart()
        .transitionDuration(350)
        #.reduceXTicks(true)
        #.rotateLabels(0)
        .height(150)
        .tooltips(false)
        .width(400)
        .showValues(true)
        #.showControls(false)
        #.showLegend(false)
        #.groupSpacing(0.2)
        .margin({left: 55})

      chart.xAxis
        .axisLabel('Miles per gallon')
        .tickFormat(d3.format('f'))
        .showMaxMin(false)

      chart.yAxis
        .axisLabel("Annual tons of GHG*")
        .orient('left')
        .showMaxMin(false)

        # .tickFormat( (d) ->
        #   prefix = d3.formatPrefix(d)
        #   prefix.scale(d) + prefix.symbol
        # )


      d3.select('#greenhouse svg')
          .datum(dataForSmall)
          .call(chart);
      chart



  init: ->
    _initSmallGraph()

AFV.tab5a.init()
