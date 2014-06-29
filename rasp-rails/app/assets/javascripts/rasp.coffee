class Rasp
  constructor: ->

    # $.ajaxSetup headers:
    #   "salt": "1235"
    #   # "hash": "1e1a642f16892ef7ca87b2307adafc09"
    #   "hash": "57b2e61b964e5ccdfd34d687db049885"

    $('#datepicker-from').fdatepicker()
    $('#datepicker-to').fdatepicker()

    $('#datepicker-from').fdatepicker().on('changeDate', (ev) ->
      console.log ev.date.valueOf()
      formattedDate = new Date(ev.date.valueOf() * 1000)
      console.log formattedDate
      d = formattedDate.getDate()
      console.log d
      m =  formattedDate.getMonth()
      m += 1  #JavaScript months are 0-11
      console.log m
      y = formattedDate.getFullYear()
      console.log y
    )

    if $("body").hasClass("recent")
      @getTemperature()

    $(document).on 'click', '#draw-chart', (event) =>
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
        console.log data
        data = JSON.parse(data.responseText);
        $('#temperature-value').html(data.value)
        return
    $.ajax
      url: "http://192.168.43.136:8080/api/temperature/3"
      # url: "http://uj-rasp.no-ip.org/api/temperature/1"
      # url: "http://localhost:8080/api/temperature/1"
      type: "GET"
      dataType: "json"
      crossDomain: true
      beforeSend: (xhr) ->
        xhr.setRequestHeader "salt", "1235"
        xhr.setRequestHeader "hash", "57b2e61b964e5ccdfd34d687db049885"
        return
      complete: (data) ->
        console.log data
        data = JSON.parse(data.responseText);
        date = new Date(data.timestamp * 1000)
        $('#historic-temperature-value').html(data.value)
        $('#historic-temperature-timestamp').html(data.timestamp)
        $('#historic-temperature-date').html(date)
        return

  generateChart: ->

    start_date = ""

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
        xhr.setRequestHeader "Start-Date", "2014-06-20 08:00:00"
        xhr.setRequestHeader "End-Date", "2014-06-21 12:00:00"
        return
      complete: (data) ->
        console.log data
        data = JSON.parse(data.responseText);
        return

    $("#chart").slideDown "slow", ->
      line1 = [
        [
          "2008-09-30 4:00PM"
          4
        ]
        [
          "2008-10-30 4:00PM"
          6.5
        ]
        [
          "2008-11-30 4:00PM"
          5.7
        ]
        [
          "2008-12-30 4:00PM"
          9
        ]
        [
          "2009-01-30 4:00PM"
          8.2
        ]
      ]
      plot1 = $.jqplot("chart", [line1],
        title: "Default Date Axis"
        axes:
          xaxis:
            renderer: $.jqplot.DateAxisRenderer

        series: [
          lineWidth: 4
          markerOptions:
            style: "square"
        ]
      )

jQuery ->
  window.rasp = new Rasp()
