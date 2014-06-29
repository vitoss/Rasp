class Rasp
  constructor: ->

    $('#datepicker-from').fdatepicker()
    $('#datepicker-to').fdatepicker()

    if $("body").hasClass("recent")
      @getTemperature()

    $(document).on 'click', '#draw-chart', (event) =>
      @generateChart()

    if $("body").hasClass("chart")
      if $("#data").hasClass("true")
        @generateChart()

  getTemperature: ->

    $.ajax
      url: "http://192.168.43.136:8080/api/temperature"
      # url: "http://uj-rasp.no-ip.org/api/temperature"
      # url: "http://localhost:8080/api/temperature"
      type: "GET"
      dataType: "json"
      crossDomain: true
      beforeSend: (xhr) ->
        xhr.setRequestHeader "salt", "1235"
        xhr.setRequestHeader "hash", "57b2e61b964e5ccdfd34d687db049885"
        return
      complete: (data) ->
        # console.log data
        data = JSON.parse(data.responseText);
        $('#temperature-value').html(data.value)
        return
    # $.ajax
    #   url: "http://192.168.43.136:8080/api/temperature/3"
    #   # url: "http://uj-rasp.no-ip.org/api/temperature/1"
    #   # url: "http://localhost:8080/api/temperature/1"
    #   type: "GET"
    #   dataType: "json"
    #   crossDomain: true
    #   beforeSend: (xhr) ->
    #     xhr.setRequestHeader "salt", "1235"
    #     xhr.setRequestHeader "hash", "57b2e61b964e5ccdfd34d687db049885"
    #     return
    #   complete: (data) ->
    #     console.log data
    #     data = JSON.parse(data.responseText);
    #     date = new Date(data.timestamp * 1000)
    #     $('#historic-temperature-value').html(data.value)
    #     $('#historic-temperature-timestamp').html(data.timestamp)
    #     $('#historic-temperature-date').html(date)
    #     return

  generateChart: ->

    $.ajax
      url: "http://192.168.43.136:8080/api/temperature"
      # url: "http://uj-rasp.no-ip.org/api/temperature/1"
      # url: "http://localhost:8080/api/temperature/1"
      type: "GET"
      dataType: "json"
      crossDomain: true
      beforeSend: (xhr) ->
        xhr.setRequestHeader "salt", "1235"
        xhr.setRequestHeader "hash", "57b2e61b964e5ccdfd34d687db049885"
        xhr.setRequestHeader "Start-Date", $("#data").data("from")
        xhr.setRequestHeader "End-Date", $("#data").data("to")
        return
      complete: (data) ->
        # console.log data.responseText
        data = JSON.parse(data.responseText);
        # console.log data
        values = []
        for d in data
          cos = []
          if d.value < 50
            # dat = new Date(d.timestamp.split(' ').join('T'))
            cos.push d.timestamp
            cos.push d.value
            values.push cos
        # console.log values
        if values.length isnt 0
          $("#chart").slideDown "slow", ->
            plot1 = $.jqplot("chart", [values],
              title: "Temperatury"
              axes:
                xaxis:
                  renderer: $.jqplot.DateAxisRenderer
                  tickOptions:
                    formatString: ""

              series: [
                lineWidth: 2
                markerOptions:
                  show: false
                  style: "circle"
              ]
            )
        else
          $("#notice").html("Brak danych w podanym przedziale.").show()
        return

jQuery ->
  window.rasp = new Rasp()
