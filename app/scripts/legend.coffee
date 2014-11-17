AFV.legend = do ->

  max = ($ '#legend-max')
  min = ($ '#legend-min')

  renderLegend: ->
    now = localStorage['nowShowing']
    getMinMax = AFV.utils.getTotalMinMax(now)
    max.text(getMinMax[1])
    min.text(getMinMax[0])

  init: (target) ->
    @renderLegend target

