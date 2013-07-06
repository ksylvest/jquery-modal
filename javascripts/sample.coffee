$ ->
  $('.try').click (event) ->
    event.preventDefault()
    event.stopPropagation()
    $('.modal').modal()
