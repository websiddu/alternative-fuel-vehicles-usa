AFV.tab5 = do ->
  _fullData = null

  _renderChart = (data) ->
    nv.addGraph ->
      #showDist, when true, will display those little distribution lines on the axis.
      chart = nv.models
        .scatterChart()
        #.showDistX(true)
        .margin({left: 70})
        #.showDistY(true)
        .y( (d) -> d['y'] )
        .x( (d) -> d['x'])
        .size( (d) -> d['money'])
        .transitionDuration(350)
        #.color(d3.scale.category10().range())

      #Configure how the tooltip looks.
      chart.tooltipContent (key, xVal, yVal, e, chart) ->
        car = e.point
        """
          <div class="si-tooltip">
            <div class="si-arrow"></div>
            <div class="si-header">
              <span class="si-make">#{car.make} &mdash; </span>
              <br>
              <span class="si-model"> #{car.model} </span>
              <small class="si-year"> (#{car.year}) </small>
            </div>
            <div class="si-toolitp-body">
              <div class="si-tooltip-first-half">
                <small>Milage</small> <br>
                <span class="si-mpg">
                  #{car.x.toFixed(2)}  <small>mpg</small>
                </span>
                <br>
                <small>Carbon emissions</small> <br>
                <span class="si-carbon">
                  #{car.y.toFixed(2)}  <small>co2 per ton</small>
                </span>
              </div>
              <div class="si-tooltip-second-half">
                  <small>Save/Spend</small> <br>
                  <span class="si-mpg">
                  #{car.money.toFixed(2)} <small>$</small>
                  </span>
              </div>
            </div>
          </div>
        """

      chart.yAxis
        .axisLabel("Carbon emissions")
        .orient('left')
        .showMaxMin(false)
        .tickFormat d3.format("f")

      chart.xAxis
        .axisLabel("Miles per gallon")
        .orient('bottom')
        .showMaxMin(false)
        .tickFormat d3.format(".02f")

      #Axis settings
      # chart.xAxis
      #   .tickFormat d3.format(".02f")

      # chart.yAxis
      #   .tickFormat d3.format(".02f")

      #We want to show shapes other than circles.
      #chart.scatter.onlyCircles false

      d3.select("#models svg").datum(data).call chart
      nv.utils.windowResize chart.update
      chart

  _initChart = ->
    d3.json 'data/afv.models.json', (err, dat) ->
      _fullData = dat
      localStorage['vehFullData'] = JSON.stringify(dat)


  _initSelect2 = ->
    $("#s_years").select2()

    $('#s_make').select2
      multiple: true
      query: (query) ->
        data = {
          results: makeData
        }
        query.callback(data);

    $("#s_years").on 'change', _renderCompareCharts
    $("#s_make").on 'change', _renderCompareCharts

  _prepareData = (years, makes) ->
    filteredData = JSON.parse(localStorage['vehFullData'])
    _fullDataCopy = JSON.parse(localStorage['vehFullData'])
    filtered = []
    for key, val of _fullDataCopy
      console.log val
      valCopy = val.values
      filtered = valCopy.filter (ele) ->
        if(_.contains(makes, ele.make) and _.contains(years, ele.year+"") )
          return true
        else
          return false

      if(filtered.length is 0)
        _fullDataCopy.splice _fullDataCopy.indexOf(_fullDataCopy[key]), 1
      else
        if(_fullDataCopy[key] is undefined)
          _fullDataCopy[key] = {}

        _fullDataCopy[key].values = filtered

    return _fullDataCopy


  _renderCompareCharts = (e) ->
    years = $("#s_years").select2('val')
    makes = $("#s_make").select2('val')
    data = null
    if years.length isnt 0 and makes.length isnt 0
      _fullData = _fullData
      data = _prepareData(years, makes)
      _renderChart(data)
    else
      console.log "Fuck you!!"

  init: ->
    _initSelect2()
    _initChart()



AFV.tab5.init()
