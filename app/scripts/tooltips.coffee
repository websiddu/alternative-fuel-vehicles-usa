AFV.tooltips = do ->

  getMapTooltip: (properties, currentYear) ->
    now = localStorage['nowShowing']
    index = window.years.indexOf(currentYear)
    carbon = JSON.parse(localStorage["carbon_data"])[properties.name][index]
    all = JSON.parse(localStorage["all_data"])[properties.name][index]
    total = JSON.parse(localStorage["total_data"])[properties.name][index]
    ratio = JSON.parse(localStorage["ratio_data"])[properties.name][index]
    percent = all * 100/total

    """
      <div class='tooltip-title'>
        #{properties.name}
        <small class='text-muted'> in </small>
        <span>#{currentYear}</span>
      </div>
      <table class="table table-striped tooltip-table">
        <tr>
          <td>
            Density
          </td>
          <td>
            <b>#{properties.density}</b> people per square mile
          </td>
        </tr>
        <tr>
          <td>
            CO2 Emission

          </td>
          <td>
            <b>#{carbon.toFixed(2) or carbon}</b> MMTCO2 in #{currentYear}
          </td>
        </tr>
        <tr>
          <td>
            AFVs
            <br>
            Total Vehicles
          </td>
          <td>
            <b>#{all}</b> AFVs in #{currentYear}
            <br>
            <b>#{total}</b> Vehicles in #{currentYear}
          </td>
        </tr>
        <tr>
          <td colspan="2" style="text-align: left;">
        Percentage of AFVs
        <div class="progress flat-progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: #{percent}%;">
            <span> #{percent.toFixed(2)}% </span>
          </div>
        </div>


          </td>
        </tr>

      </table>

    """
