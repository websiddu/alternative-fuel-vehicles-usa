
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
  _firstRunFlag = false

  tilesUrl = "https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png"
  attributions =
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'examples.map-20v6611k'

  # Provide your access token
  # L.mapbox.accessToken = 'pk.eyJ1Ijoid2Vic2lkZHUiLCJhIjoibmRVS1NTYyJ9.pCvtUhjGjw_8JrW2GDYLug';

  _init = ->
    AFV.sidebar.totalAFVs(window.us_total_afv_line)
    AFV.sidebar.initCarbonEmissions(us_total_carbon)
    _yearsHeatMap()
    map = L.map('map', _options).setView([36.421, -71.411], 4)

    zoom = L.control.zoom
      position: 'bottomleft'

    tiles = L.tileLayer(tilesUrl, attributions)

    map.addControl(zoom)
    tiles.addTo(map)
    _firstRun()
    _renderMasterMap($('#dataLayer').val())

    $('#dataLayer').on 'change', (e) ->
      map.removeLayer(statesLayer) if statesLayer?
      AFV.pausePlayer()
      dataLayer = $('#dataLayer').val()
      _nowShowing = dataLayer
      _renderMasterMap(_nowShowing)

  _firstRun = ->
    for key in ['all', 'carbon']
      _nowShowing = key
      _renderMasterMap key

  _renderMasterMap = (now) ->
    AFV.pausePlayer()
    localStorage['nowShowing'] = now
    switch now
      when 'all'
        d3.json('data/us.states.json', (err, data) ->
          _playerDataAll = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataAll, 'all')
          _playerData = data
          _invokeAll()
        )
      when 'carbon'
        d3.json('data/us.states.carbon.json', (err, data) ->
          _playerDataCarbon = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataCarbon, 'carbon')
          _playerData = data
          _invokeAll()
          _firstRunFlag = true
        )


  _invokeAll = ->
    AFV.pausePlayer()
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


      AFV.sidebar.initCarbonEmissions(AFV.sidebar.prepareData(e.target, 'carbon'))
      AFV.sidebar.totalAFVs(AFV.sidebar.prepareData(e.target, 'all'))
      AFV.tab2.loadByStateVehicleTypeGraph(e.target)
      # _initLineChart _prepartData(e.target)

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
      AFV.sidebar.totalAFVs(window.us_total_afv_line)
      AFV.sidebar.initCarbonEmissions(us_total_carbon)

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
    popup.setContent AFV.tooltips.getMapTooltip(layer.feature.properties, currentYear)
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

