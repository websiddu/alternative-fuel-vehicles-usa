
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


  # Provide your access token
  # L.mapbox.accessToken = 'pk.eyJ1Ijoid2Vic2lkZHUiLCJhIjoibmRVS1NTYyJ9.pCvtUhjGjw_8JrW2GDYLug';

  _init = ->
    map = L.map('map', _options).setView([36.421, -71.411], 4)

    zoom = L.control.zoom
      position: 'bottomleft'

    map.addControl(zoom)

    L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>',
      id: 'examples.map-20v6611k'
    }).addTo(map);


    d3.json('data/us.states.json', (err, data) ->
      statesLayer = L.geoJson(data,
        style: getStyle
        onEachFeature: onEachFeature
      ).addTo(map)
    )

    onEachFeature = (feature, layer) ->
      layer.on
        mouseover: highlightFeature
        mouseout: resetHighlight


    resetHighlight = (e) ->
      statesLayer.resetStyle(e.target)


    highlightFeature = (e) ->
      layer = e.target;

      layer.setStyle
        weight: 1,
        color: '#666',
        dashArray: '',
        fillOpacity: 0.7

      if (!L.Browser.ie and !L.Browser.opera)
        layer.bringToFront()

      # info.update(layer.feature.properties);

    # statesData comes from the 'us-states.js' script included above
    getStyle = (feature) ->
      weight: 1
      opacity: 0.8
      color: '#fff'
      fillOpacity: 0.9
      fillColor: getColor(feature.properties.density)

    # get color depending on population density value
    getColor = (d) ->
      (if d > 1000 then "#8c2d04" else (if d > 500 then "#cc4c02" else (if d > 200 then "#ec7014" else (if d > 100 then "#fe9929" else (if d > 50 then "#fec44f" else (if d > 20 then "#fee391" else (if d > 10 then "#fff7bc" else "#ffffe5")))))))


  init: ->
    _init()


$(AFV.init)

