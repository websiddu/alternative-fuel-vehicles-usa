AFV.legend = do ->

  max = ($ '#legend-max')
  min = ($ '#legend-min')

  getUints: (now) ->
    unit = ''
    switch now
      when 'carbon'
        unit = 'Million Metric Tons CO2 (MMTCO2)'
      when 'all'
        unit = 'Number of cars'


  generateGradient: ->
    now = localStorage['nowShowing']
    legendKey = ($ '.legend-key')
    colorArr = AFV.utils.getColorArray(now)
    console.log "linear-gradient(to right, #{colorArr[0]}, #{colorArr[1]})"
    legendKey.css
      background: "linear-gradient(to right, #{colorArr[0]}, #{colorArr[1]})"

  renderLegend: ->
    now = localStorage['nowShowing']
    getMinMax = AFV.utils.getTotalMinMax(now)
    max.text(getMinMax[1])
    min.text(getMinMax[0])
    @generateGradient()
    ($ '.units').text(@getUints(now))

  init: (target) ->
    @renderLegend target

