AFV.utils = do ->

  setMinMax: (data, type) ->
    _flattenData = @flattenObject(data, type)
    _minMaxArr = []
    _splitData = {}
    console.log _flattenData
    for key, value of _flattenData
      # _splitData[key] = [] if _splitData[key] is undefined
      min = d3.min value, (d) -> d
      max = d3.max value, (d) -> d

      _minMaxArr.push(min)
      _minMaxArr.push(max)

      _splitData[key] = [min, max]

    @storeLocal(_splitData, type, 'minmax')
    minmax = [d3.min(_minMaxArr, (d) -> d), d3.max(_minMaxArr, (d) -> d)]
    @storeLocal(minmax, type, 'total_minmax')
    return minmax


  flattenObject: (data, type) ->
    _splitData = {}
    key = ''

    for key, value of data
      i = 0
      _splitData[key] = [] if _splitData[key] is undefined
      while i < window.years.length
        _splitData[key].push(parseFloat(value[years[i]]))
        i++
    @storeLocal(_splitData, type, 'data')
    return _splitData

  storeLocal: (data, type, subType) ->
    localStorage["#{type}_#{subType}"] = JSON.stringify data

  stripGeometry: (data) ->
    result = {}
    length = data.features.length
    i = 0
    while i < length
      result[data.features[i].properties.name] = data.features[i].properties
      i++
    return  result
