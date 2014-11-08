AFV.years = do ->
  yearsHtml = ''
  interval = ''

  years = window.years
  afvCount = window.us_total_afv_line_y
  windowWidth = window.innerWidth
  windowHeight = window.innerHeight
  yearsWidth = windowWidth/1.82 - 60

  yearsScale = d3.scale.linear()
        .domain([afvCount[afvCount.length - 1], afvCount[0]])
        .range(['#900019', '#ff859a'])
        #.range(if (typeMode) then ['#00363b', '#00d7ed'] else ['#3c0d15', '#f13452'])

  _init = (duraiton, target) ->
    yearsCount = years.length
    yearWidth = yearsWidth/yearsCount
    i = 0
    while i < yearsCount
      console.log yearsScale(afvCount[i])
      toolTipContent = "<b class=afv-tooltip-title>#{afvCount[i]}</b> <br> Alt Fuel Vehicles"
      yearHtml = """
        <div class="year-box js_tooltip" data-year='#{years[i]}' style='width: #{yearWidth}px;' data-toggle="tooltip" data-placement="top" data-original-title="#{toolTipContent}">
          <div class="year-bar" style='background-color:#{yearsScale(afvCount[i])} '></div>
          <span class="year-text">#{years[i]}</span>
        </div>
      """
      i++
      target.append(yearHtml)

    # Initilize the tooltip
    _initTooltip()



  _initTooltip = ->
    $("[data-toggle='tooltip']").tooltip
      container: 'body'
      html: true

  setActiveYear: (year) ->
    ($ "[data-year]").removeClass('active')
    ($ "[data-year='#{year}']").addClass('active')

  init: _init
