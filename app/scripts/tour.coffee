AFV.tour = do ->
  _init = ->
    t1 = """
      <div class="popover" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        <div class="popover-navigation">
            <a class="pull-right" href='' data-role="end">No thanks</a>
              <div class="text-center">
                <button  class="btn btn-default" data-role="next">Start a tour</button>
              </div>
          </div>
        </div>
      </div>
      """



    tour = new Tour(
      name: "tour"
      container: "body"
      orphan: true
      # backdrop: true
      template: """
      <div class="popover" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        <div class="popover-navigation">
          <button class="btn btn-sm btn-default" data-role="end">End tour</button>
          <div class="btn-group">
            <button class="btn btn-sm btn-success" data-role="prev">&laquo; Prev</button>
            <button class="btn btn-sm btn-success" data-role="next">Next &raquo;</button>
            <button class="btn btn-sm btn-success" data-role="pause-resume" data-pause-text="Pause" data-resume-text="Resume">Pause</button>
          </div>
        </div>
      </div>
      """

      steps: [
        {
          template: t1
          title: "Welcome, environment enthusiast!",
          content: """
            <p>While "Environmental conservation" has not been a consistent hot-button topic for political leaders for very long, climate change debating and advocacy have been increasing steadily over the last few decades. Developing countries, population spikes, the progression and supply of motor vehicles, and many more factors have made considerations to the planet’s environmental stability a necessity. We plan to utilize data from the Department of Energy to identify the trends and correlations of alternative fuel vehicles (AFVs) usage in the United States.
          </p>
          <ul class="list-inline afv-list">
            <li> <em class="icon icon-afv-sedan"></em></li>
            <li> <em class="icon icon-afv-suv"></em></li>
            <li> <em class="icon icon-afv-truck"></em></li>
            <li> <em class="icon icon-afv-van"></em></li>
          </ul>

          """
          backdrop: true
        },
        {
          element: ".js_tour_mapcontrols",
          title: "Change the map layer settings",
          content: """
            <p> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Omnis, quam, qui.</p>
          """
        },
        {
          element: "[data-year=2000]"
          title: 'Click on any year'
          content: """
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }

        {
          element: ".js_play_pause_icon"
          title: 'Play and pause'
          content: """
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }
        {
          element: ".js_tour_overview"
          placement: 'bottom'
          title: 'See the overview here'
          content: """
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }
        {
          element: ".js_tour_afv"
          title: 'All about the different vehicle types'
          placement: 'bottom'
          content: """
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }
        {
          element: ".js_tour_fuel"
          title: 'All about the different fuel types'
          placement: 'bottom'
          content: """

          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }

        {
          element: ".js_tour_manf"
          placement: 'bottom'
          title: 'All about the different fuel types'
          content: """
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laudantium inventore fuga reprehenderit, provident est, tenetur exercitationem ullam perspiciatis, dicta aliquam vero aspernatur quia labore dolores deserunt placeat enim accusantium neque.</p>

          """
        }

      ]
    );

    console.log tour

    tour.init()

    tour.start()
    return

  init: ->
    _init()

setTimeout ->
  AFV.tour.init()
, 600
