AFV.years = do ->
  yearsHtml = ''
  interval = ''

  years = window.years
  afvCount = window.us_total_afv_line_y
  windowWidth = window.innerWidth
  windowHeight = window.innerHeight
  yearsWidth = windowWidth/1.82
  _yearsAvgOrTotal = null

  _yearsScale = (data) ->
    now = localStorage['nowShowing']
    domain = AFV.utils.getMinMaxForYears(now)
    return d3.scale.linear().domain(domain)
      .range(AFV.utils.getColorArray(now))(data)

  _init = (target) ->
    # Render the years UI
    _renderYearsUI(target)
    # Bind all the events
    _bindEvents()
    # Initilize the tooltip
    _initTooltip()

  _generateTootip = (index) ->
    carbon = JSON.parse(localStorage["carbon_years_avg"])[index]
    all = JSON.parse(localStorage["all_years_sum"])[index] if localStorage["all_years_sum"]
    """<b class=afv-tooltip-title>
        #{carbon.toFixed 2}</b>
        <br> MMTCO2
        <br>
        <br>
        <b class=afv-tooltip-title>
        #{all}</b>
        <br>
        Alt Fuel Vehicles
    """

  _renderYearsUI = (target) ->
    target.empty()
    yearsCount = years.length
    yearWidth = yearsWidth/(yearsCount + 1)

    now = localStorage['nowShowing']

    if now is 'carbon'
      _yearsAvgOrTotal = JSON.parse localStorage["#{now}_years_avg"]
    else
      if localStorage["#{now}_years_sum"]
        _yearsAvgOrTotal = JSON.parse localStorage["#{now}_years_sum"]

    i = 0
    playPauseButton = """
      <div class="playControls js_play_pause_controls" data-play-state="play" style='width: #{yearWidth}px'><em class="icon icon-pause js_play_pause_icon"></em></div>
    """
    target.append(playPauseButton)

    while i < yearsCount

      toolTipContent = _generateTootip(i)

      yearHtml = """
        <div class="year-box js_tooltip js_year" data-year='#{years[i]}' style='width: #{yearWidth}px;' data-toggle="tooltip" data-placement="top" data-original-title="#{toolTipContent}">
          <div class="year-bar" style='background-color:#{_yearsScale(_yearsAvgOrTotal[i])} '></div>
          <span class="year-text">#{years[i]}</span>
        </div>
      """
      i++
      target.append(yearHtml)

  _bindEvents = ->
    $(document).on 'click', '[data-year]', _handleYearClick
    $(document).on 'click', '.js_play_pause_controls', _handlePlayer

  _handlePlayer = (event) ->
    _this = ($ @)
    currentPlayState = _this.data('playState')
    if currentPlayState is 'play'
      AFV.pausePlayer()
      _this.data('playState', 'pause')
      _setPlayPauseIcon('play')
    else
      AFV.resumePlayer()
      _this.data('playState', 'play')
      _setPlayPauseIcon('pause')



  _setPlayPauseIcon = (playerState) ->
    ($ '.js_play_pause_icon').removeClass('icon-play icon-pause').addClass("icon-#{playerState}")

  _clearHighlights = ->
    ($ "[data-year]").removeClass('active')

  _handleYearClick = (event) ->
    year = ($ @).data('year')
    AFV.pausePlayer()
    AFV.years.setActiveYear(year)
    AFV.loadCurrentYearMap(year)

  _initTooltip = ->
    $("[data-toggle='tooltip']").tooltip
      container: 'body'
      html: true
      animation: true

  reachedEnd: ->
    playPauseButton = ($ '.js_play_pause_controls')
    playPauseButton.data('playState', 'pause')
    _setPlayPauseIcon('play')

  setActiveYear: (year) ->
    _clearHighlights()
    ($ "[data-year='#{year}']").addClass('active')

  init: _init
