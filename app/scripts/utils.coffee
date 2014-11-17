AFV.utils = do ->

  setMinMax: (data, type) ->
    _flattenData = @flattenObject(data, type)
    _minMaxArr = []
    _splitData = {}
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

  getTotalMinMax: (now) ->
    return JSON.parse localStorage["#{now}_total_minmax"]

  getMinMaxForYears: (now) ->
    if now is 'carbon'
      _yearsAvgOrTotal = JSON.parse localStorage["#{now}_years_avg"]
    else
      if localStorage["#{now}_years_sum"]
        _yearsAvgOrTotal = JSON.parse localStorage["#{now}_years_sum"]

    return [d3.min(_yearsAvgOrTotal, (d) -> d), d3.max(_yearsAvgOrTotal, (d) -> d)]

  flattenObject: (data, type) ->
    _splitData = {}
    _years = {}
    key = ''
    for key, value of data
      i = 0
      _splitData[key] = [] if _splitData[key] is undefined
      while i < window.years.length
        _years[years[i]] = [] if _years[years[i]] is undefined
        _years[years[i]].push(parseFloat(value[years[i]]))
        _splitData[key].push(parseFloat(value[years[i]]))
        i++
    @storeLocal(_years, type, 'years')
    @calculateAvg(_years, type) if type is 'carbon'
    @calculateSum(_years, type) if type isnt 'carbon'
    @storeLocal(_splitData, type, 'data')
    return _splitData

  calculateSum: (years, type) ->
    sumArr = []
    for key, value of years
      ttl = value.reduce (p, c, i, arr) ->
        p + c
      sumArr.push ttl
    @storeLocal(sumArr, type, 'years_sum')

    return sumArr

  calculateAvg: (years, type) ->
    avgArr = []
    for key, value of years
      ttl = value.reduce (p, c, i, arr) ->
        p + c
      avgArr.push ttl/value.length
    @storeLocal(avgArr, type, 'years_avg')

    return avgArr



  stripGeometry: (data) ->
    result = {}
    length = data.features.length
    i = 0
    while i < length
      result[data.features[i].properties.name] = data.features[i].properties
      i++
    return  result

  storeLocal: (data, type, subType) ->
    localStorage["#{type}_#{subType}"] = JSON.stringify data


  getColorArray: (type) ->
    set = []
    switch type
      when 'all'
        set = ['#ff9090', '#a20101']
      when 'carbon'
        set = ['#d8ffe3', '#004915']

    return set

  getMinMax: (type) ->
    return localStorage["#{type}_total_minmax"]


