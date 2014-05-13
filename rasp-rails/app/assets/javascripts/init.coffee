class Init
  constructor: ->

    $.ajaxSetup headers:
      "salt": "1235"
      # "hash": "1e1a642f16892ef7ca87b2307adafc09"
      "hash": "57b2e61b964e5ccdfd34d687db049885"

    @getTemperature()

  getTemperature: ->

    $.ajax
      # url: "http://uj-rasp.no-ip.org/api/temperature"
      url: "http://localhost:8080/api/temperature"
      type: "GET"
      dataType: "json"
      crossDomain: true
      complete: (data) ->
        data = JSON.parse(data.responseText);
        $('#temperature-value').html(data.value)
        return

jQuery ->
  window.init = new Init()
