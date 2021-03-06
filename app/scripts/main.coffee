
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

  _playerDataTotal = null
  _playerDataRatio = null

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
    AFV.sidebar.totalAFVs(tab1_data)
    #AFV.sidebar.initCarbonEmissions(us_total_carbon)
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

    $('.js_restart_tour').on 'click', _reinitTour

  _reinitTour = (e) ->
    e.preventDefault()
    AFV.tour.restart()

  _firstRun = ->
    for key in ['all', 'total', 'ratio', 'carbon']
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
      when 'total'
        d3.json 'data/us.states.total.json', (err, data) ->
          _playerDataTotal = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataTotal, 'total')
          _playerData = data
          _invokeAll()
      when 'carbon'
        d3.json('data/us.states.carbon.json', (err, data) ->
          _playerDataCarbon = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataCarbon, 'carbon')
          _playerData = data
          _invokeAll()
          _firstRunFlag = true
        )
      when 'ratio'
        d3.json('data/us.states.ratio.json', (err, data) ->
          _playerDataRatio = AFV.utils.stripGeometry(data)
          _minMax[_nowShowing] = AFV.utils.setMinMax(_playerDataRatio, 'ratio')
          _playerData = data
          _invokeAll()
          _firstRunFlag = true
        )



  _invokeAll = ->
    AFV.pausePlayer()
    # _initPlayer()
    ## Activate last
    setTimeout ->
      $('.js_year:last').addClass('active').click()
    , 100
    AFV.years.init ($ '#year')
    AFV.legend.init ($ '#legend')

  _initPlayer = ->
    interval = setInterval ->
      if currentYear > 2011
        AFV.pausePlayer()
        AFV.years.reachedEnd()
        currentYear = 1994
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

      $("#stateSelector").select2('val', '[]')
      #AFV.sidebar.initCarbonEmissions(AFV.sidebar.prepareData(e.target, 'carbon'))
      AFV.sidebar.totalAFVs(AFV.sidebar.prepareData(e.target))
      AFV.tab2.loadByStateVehicleTypeGraph(e.target)
      AFV.tab3.loadByStateFuelTypeGraph(e.target)
      AFV.fc.loadByStateFuelConsumptionGraph(e.target)
      # _initLineChart _prepartData(e.target)

      $('.currentState').text(e.target.feature.properties.name)

      statesLayer.setStyle _setDisableStyle
      aStateIsActive = true
      AFV.pausePlayer()
      e.target.setStyle _highlightOnClick(e)
      e.target.feature.properties['isActive'] = true
    else
      statesLayer.eachLayer (layer) ->
        layer.setStyle _getStyle(layer.feature)
      aStateIsActive = false
      $('.currentState').text('USA')
      e.target.feature.properties['isActive'] = false
      AFV.sidebar.totalAFVs(window.tab1_data)
      AFV.tab2.loadInitalVehicleTypeGraph()
      AFV.tab3.loadInitalVehicleTypeGraph()
      AFV.fc.loadInitalVehicleTypeGraph()
      # AFV.sidebar.initCarbonEmissions(us_total_carbon)

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
    return d3.scale.linear()
      .domain(_minMax[_nowShowing]).range(AFV.utils.getColorArray(_nowShowing)).interpolate(d3.interpolateLab)(data)

  _yearsHeatMap =  (years) ->
    years = us_total_afv_line_y


  _prepopulateState = ->
    opts = $("#source").html()
    opts2 = "<option></option>" + opts
    $("select.populate").each ->
      e = $(this)
      e.html (if e.hasClass("placeholder") then opts2 else opts)
      return

    $("#stateSelector").select2
      placeholder: "Select multiple states"
      maximumSelectionSize: 4

    $("#stateSelector").on 'change', _renderCompareCharts

  _setCurrentStateComparision = (data) ->
    if(typeof data is 'string')
      $('.js_currentState').text(data)
    else
      $('.js_currentState').text(data.join(', '))

  _renderCompareCharts = (e) ->
    if e.val.length isnt 0
      _setCurrentStateComparision(e.val)
      AFV.sidebar.totalAFVs(AFV.sidebar.prepareDataSelect(e.val))
    else
      _setCurrentStateComparision('USA')
      AFV.sidebar.totalAFVs(window.tab1_data)


  loadCurrentYearMap: (year) ->
    currentYear = year
    _renderCMap()

  pausePlayer: ->
    clearInterval(interval)

  resumePlayer: ->
    _initPlayer()

  init: ->
    _prepopulateState()

    $('[data-toggle="tooltip"]').tooltip
      container: 'body'
    _init()


$(AFV.init)

