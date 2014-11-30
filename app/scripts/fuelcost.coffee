AFV.fuelcost = do ->

  _renderGraph = ->
    d3.json 'data/fuel.costs.json', (err, data) ->
      nv.addGraph ->
        chart = nv.models
          .lineChart()
          .margin(left: 55)
          .useInteractiveGuideline(true)
          .transitionDuration(350)
          .showLegend(true)
          .x( (d) -> return new Date(d['x']))
          .y( (d) -> return d['y'])
          #.showYAxis(true)
          #.showXAxis(true)
          # .controlLabels({
          #   stacked: "Total number"
          #   expanded: "Percent of total"
          # })
          #.height(320)

        chart.xAxis
          .axisLabel('Date')
          .showMaxMin(false)
          .tickFormat( (d) ->
            myDate = new Date(d)
            "#{myDate.getUTCMonth() + 1}/#{myDate.getUTCDate()}/#{myDate.getUTCFullYear()}"

          )

        chart.yAxis
          .axisLabel("Cost in per gallon ($)")
          .orient('left')


        d3.select("#fuel-cost svg").datum(data).call chart #Finally, render the chart!

        #d3.select("#multiline-split .nv-legendWrap").attr("class", "hide")

        nv.utils.windowResize ->
          chart.update()
          return

        chart




  init: ->
    _renderGraph()


AFV.fuelcost.init()
