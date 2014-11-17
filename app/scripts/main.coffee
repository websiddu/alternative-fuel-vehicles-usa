
window.AFV = do ->
  statesLayer = null
  map = null
  southWest = L.latLng(-40.011, -96.548)
  northEast = L.latLng(79.063, -69.565)
  bounds = L.latLngBounds(southWest, northEast)
  _options =
    maxZoom: 5
    minZoom: 3
    # maxBounds: bounds
    zoomControl: false

  min = 990
  max = 66366
  currentYear = 1994
  interval = null

  DURATION = 700

  _playerData = null
  _playerDataAll = null
  _playerDataCarbon = null

  _carbonMinMax = []
  _playerMinMax = []

  _nowShowing = ''

  _minMax = {}

  popup = new L.Popup({ autoPan: false })
  closeTooltip = null
  aStateIsActive = false
  dataLayer = ''


  tilesUrl = "https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png"
  attributions =
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'examples.map-20v6611k'

  # Provide your access token
  # L.mapbox.accessToken = 'pk.eyJ1Ijoid2Vic2lkZHUiLCJhIjoibmRVS1NTYyJ9.pCvtUhjGjw_8JrW2GDYLug';

  _init = ->
    _initLineChart(window.us_total_afv_line)
    _initCarbonEmissions()
    _yearsHeatMap()
    map = L.map('map', _options).setView([36.421, -71.411], 4)

    zoom = L.control.zoom
      position: 'bottomleft'

    tiles = L.tileLayer(tilesUrl, attributions)

    map.addControl(zoom)
    tiles.addTo(map)
    _renderMasterMap()

    $('#dataLayer').on 'change', (e) ->
      AFV.pausePlayer()
      _renderMasterMap(e)

  _renderMasterMap = ->
    dataLayer = $('#dataLayer').val()
    _nowShowing = dataLayer
    localStorage['nowShowing'] = _nowShowing
    switch dataLayer
      when 'all'
        d3.json('data/us.states.json', (err, data) ->
          _playerDataAll = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataAll, 'all')
          _playerData = data
        )
      when 'carbon'
        d3.json('data/us.states.carbon.json', (err, data) ->
          _playerDataCarbon = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataCarbon, 'carbon')
          _playerData = data
        )

    _initPlayer()
    AFV.years.init ($ '#year')
    AFV.legend.init ($ '#legend')

  _initPlayer = ->
    interval = setInterval ->
      if currentYear > 2011
        currentYear = 1994
        AFV.pausePlayer()
        AFV.years.reachedEnd()
      else
        _renderCMap()
        AFV.years.setActiveYear(currentYear)
        currentYear+=1
    , DURATION

  _renderCMap = ->
    map.removeLayer(statesLayer) if statesLayer?
    statesLayer = L.geoJson(_playerData,
      style: _getStyle
      onEachFeature: _onEachFeature
    ).addTo(map)

  _onEachFeature = (feature, layer) ->
    feature.properties.isActive = false
    layer.on
      mousemove: _showTooltip
      mouseover: _highlightFeature
      mouseout: _resetHighlight
      click: _loadStatesRelatedGraphs

  _loadStatesRelatedGraphs = (e) ->
    if e.target.feature.properties['isActive'] isnt true
      statesLayer.eachLayer (layer) ->
        layer.feature.properties.isActive = false
      # map.fitBounds(layer.getBounds())

      _initLineChart _prepartData(e.target)

      statesLayer.setStyle _setDisableStyle
      aStateIsActive = true
      AFV.pausePlayer()
      e.target.setStyle _highlightOnClick(e)
      e.target.feature.properties['isActive'] = true
    else
      statesLayer.eachLayer (layer) ->
        layer.setStyle _getStyle(layer.feature)
      aStateIsActive = false
      e.target.feature.properties['isActive'] = false
      _initLineChart(window.us_total_afv_line)

  _highlightFeature = (e) ->
    e.target.setStyle _getHoverStyles(e)

  _getHoverStyles = (e) ->
    if aStateIsActive and e.target.feature.properties.isActive isnt true
      weight: 2
      color: '#fff'
      dashArray: ''
      fillOpacity: 0.3
    else
      weight: 2
      color: '#fff'

  _highlightOnClick = (layer) ->
    weight: 1
    color: '#fff',
    dashArray: '',
    fillOpacity: 1

  _setDisableStyle = (e) ->
    weight: 0
    dashArray: ''
    fillOpacity: 0.3

  _getResetStyles = (e) ->
    if aStateIsActive and e.target.feature.properties.isActive isnt true
      weight: 0
      color: '#fff'
      dashArray: ''
    else
      weight: 1
      opacity: 0.8
      color: '#fff'
      fillOpacity: 0.9

  _resetHighlight = (e) ->
    e.target.setStyle _getResetStyles(e)

    closeTooltip = window.setTimeout(->
      map.closePopup()
      return
    , 100)

  _showTooltip = (e) ->
    layer = e.target
    popup.setLatLng e.latlng
    popup.setContent """
        <div class='marker-title'>
          #{layer.feature.properties.name}
        </div>
        #{layer.feature.properties.density} people per square mile
      """
    popup.openOn map  unless popup._map
    window.clearTimeout closeTooltip

    layer.bringToFront()  if not L.Browser.ie and not L.Browser.opera

    # info.update(layer.feature.properties);

  _getStyle = (feature) ->
    weight: 1
    opacity: 0.8
    color: '#fff'
    fillOpacity: 0.9
    fillColor: yearsScale(feature.properties[currentYear])

  yearsScale = (data) ->
    return d3.scale.linear().domain(_minMax[_nowShowing]).range(AFV.utils.getColorArray(_nowShowing))(data)

  _prepartData = (layer) ->
    properties = layer.feature.properties
    renderedData = []
    values = []
    for i in window.years
      point =
        x: i
        y: properties[i]

      values.push(point)

    renderedData.push
      values: values
      key: 'AF Vehicles'

    renderedData

  _initCarbonEmissions = ->
    sidebarWidth = $('.sidebar').width()
    $('.ng-svg').css('width', sidebarWidth)

    nv.addGraph ->
      chart = nv.models.lineChart()
        .useInteractiveGuideline(true)
        .transitionDuration(350)
        .showLegend(true)
        .showYAxis(true)
        .showXAxis(true)
        .width(sidebarWidth)

      chart.xAxis
        .axisLabel('Year')
        .tickFormat(d3.format('r'))

      chart.yAxis
        .axisLabel('Count (thousnds)')

      d3.select('#linegraph-carbon svg')
          .datum(window.us_total_carbon)
          .call(chart);
      chart

  _initLineChart = (data) ->
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
        .axisLabel('Count (thousnds)')
        .tickFormat (d) ->
          parseInt(d/1000) + 'K'
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



  _yearsHeatMap =  (years) ->
    years = us_total_afv_line_y

  loadCurrentYearMap: (year) ->
    currentYear = year
    _renderCMap()

  pausePlayer: ->
    clearInterval(interval)

  resumePlayer: ->
    _initPlayer()

  init: ->
    _init()


$(AFV.init)

