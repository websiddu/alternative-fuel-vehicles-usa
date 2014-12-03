AFV.legend = do ->

  max = ($ '#legend-max')
  min = ($ '#legend-min')

  getUints: (now) ->
    unit = ''
    switch now
      when 'carbon'
        unit = 'Million Metric Tons CO2 (MMTCO2)'
      when 'all'
        unit = 'Number of Alternative Fuel vehicles'
      when 'total'
        unit = 'Total Number of vehicles'
      when 'ratio'
        unit = 'Percentage of AFVs'

  generateGradient: ->
    now = localStorage['nowShowing']
    legendKey = ($ '.legend-key')
    colorArr = AFV.utils.getColorArray(now)

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

