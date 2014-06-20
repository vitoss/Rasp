class Rasp
  constructor: ->

    $.ajaxSetup headers:
      "salt": "1235"
      # "hash": "1e1a642f16892ef7ca87b2307adafc09"
      "hash": "57b2e61b964e5ccdfd34d687db049885"

    @getTemperature()

  getTemperature: ->

    $.ajax
      url: "http://178.37.157.22:8080/api/temperature"
      # url: "http://uj-rasp.no-ip.org/api/temperature"
      # url: "http://localhost:8080/api/temperature"
      type: "GET"
      dataType: "json"
      crossDomain: true
      complete: (data) ->
        data = JSON.parse(data.responseText);
        $('#temperature-value').html(data.value)
        return
    $.ajax
      url: "http://178.37.157.22:8080/api/temperature/1"
      # url: "http://uj-rasp.no-ip.org/api/temperature/1"
      # url: "http://localhost:8080/api/temperature/1"
      type: "GET"
      dataType: "json"
      crossDomain: true
      complete: (data) ->
        data = JSON.parse(data.responseText);
        date = new Date(data.timestamp * 1000)
        $('#historic-temperature-value').html(data.value)
        $('#historic-temperature-timestamp').html(data.timestamp)
        $('#historic-temperature-date').html(date)
        return

jQuery ->
  window.rasp = new Rasp()
