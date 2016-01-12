# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:change", ->
  $("#reviews-link").click (event) ->
    # Prevent the default behaviour of linking to # which is scrolling to
    # the top of the page
    event.preventDefault()
    $("#reviews-section").fadeToggle()
