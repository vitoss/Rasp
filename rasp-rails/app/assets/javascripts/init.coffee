class Init
  constructor: ->
    @getTemperature()

  getTemperature: ->
    $.ajax(
      url: "http://uj-rasp.no-ip.org/api/temperature"
      type: "GET"
      dataType: "json"
    ).complete (data) ->
      # console.log data.responseText
      $('#temperature-value').html(data.responseText)
      return

jQuery ->
  window.init = new Init()
