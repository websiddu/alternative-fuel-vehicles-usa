AFV.countSlider = do ->
  years = ''
  interval = ''

  _init = (start, end, duraiton, target) ->
    i = start
    top = 0
    styles =
      height: '65px'
      "text-align": "center"
      #position: 'absolute'
      #top: '0px'
    while i < end
      year = $("<div class='year-text'>#{i}</div>")
      year.css styles
      # year.css
      #   top: top
      # top+=60
      target.append(year)
      i++
    pos = 0
    tracker = start
    interval = setInterval ->
      if(tracker == end-1)
        clearInterval(interval)
      tracker++
      target.css
        top: -pos
      pos+=65
    , duraiton


  _setInterveal = ->




  init: _init
