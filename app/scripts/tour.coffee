AFV.tour = do ->
  tour = null
  _init = ->
    t1 = """
      <div class="popover" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        <div class="popover-navigation">

              <div class="pull-right">
                <a class="tour-link" href='' data-role="end">No thanks</a>
                  &nbsp;&nbsp;&nbsp;&nbsp;
                <button  class="btn btn-default tour-button" data-role="next">Start a tour &rarr;</button>
              </div>
          </div>
        </div>
      </div>
      """

    e = """
      <div class="popover" role="tooltip">
        <div class="arrow"></div>
        <h3 class="popover-title"></h3>
        <div class="popover-content"></div>
        <div class="popover-navigation">
          <a class="btn btn-sm btn-default tour-end" href='' data-role="end">End tour</a>
          <div class="btn-group">
            <button class="btn btn-sm btn-success" data-role="prev">&laquo; Prev</button>
            <button class="btn btn-sm btn-success" data-role="end">Got it!</button>
            <button class="btn btn-sm btn-success" data-role="pause-resume" data-pause-text="Pause" data-resume-text="Resume">Pause</button>
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
          <a class="btn btn-sm btn-default tour-end" href='' data-role="end">End tour</a>
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
          title: "Welcome!",
          content: """
          <div class="row">
            <div class="col-lg-8">
              <p>Alternative fuels have been moving into the spotlight of discussion for ways to reduce carbon emissions from vehicles. We created this visualization to support exploration of data regarding alternative fuel vehicles (AFVs).
              </p>

               <p>The following tour will help to orient you and give you some ideas of how to look at the information.
              </p>

            </div>
            <div class="col-lg-4">
              <img src="images/afvlogo.svg" alt="" class="img-responsive">
            </div>
          </div>
          <div class="row">
            <div class="col-lg-12">

              <p> <small>You may close this tour at any time, or reopen it by pressing the ‘Tour’ button in the top right of the screen.</small></p>

            </div>
          </div>

          <h5 style="margin-bottom: 2px;">Data from</h5>
          <p><small>http://www.afdc.energy.gov/</small></p>

          <h5>Technologies used</h5>
          <p>
            <img src="images/credits.svg" alt="" height="25px">
          </p>

          """
          backdrop: true
        },
        {
          element: ".js_tour_mapcontrols",
          title: "Change the map layer setting",
          placement: 'bottom'
          content: """
            <p> Use the dropdown to view different data on the U.S. map.</p>
          """
        },
        {
          element: "[data-year=2000] .year-bar"
          placement: 'top'
          title: 'View data by year'
          content: """
          <p>Click any year to view that data by state.</p>

          """
        }

        {
          element: ".js_play_pause_icon"
          title: 'View slideshow'
          content: """
          <p>Press Play to view the yearly progression as a slideshow.</p>

          """
        }
        {
          element: ".js_tour_overview"
          placement: 'bottom'
          title: 'View overview tab'
          content: """
          <p>This tab shows the total number of AFVs and carbon emissions by year. Select a state on the left to see data for just that state. Click the state again to deselect it.</p>

          """
        }
        {
          element: ".js_tour_afv"
          title: 'All about the different vehicle types'
          template: e
          placement: 'bottom'
          content: """
          <p>Use these tabs to view more in-depth information about AFVs, fuel types, and AFV manufacturers.</p>

          """
        }
      ]
    );

    tour.init()

    tour.start()
    return

  restart: ->
    tour.restart()

  init: ->
    _init()

setTimeout ->
  AFV.tour.init()
, 600
