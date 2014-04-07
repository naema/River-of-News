# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  $("#user_font_name").select2
    placeholder: 'select a color'

  # News Container Preview
  addGoogleFont = (font) ->
    $("head").append("<link href='https://fonts.googleapis.com/css?family=" + font + "' rel='stylesheet' type='text/css'>")

  $(document).on 'change', '#user_box_color', (event) ->
    $("#news-box").css("background-color", "#{$(this).val()}")

  $(document).on 'change', '#user_border_color', (event) ->
    $("#news-box").css("border", "5px solid #{$(this).val()}")

  $(document).on 'change', '#user_font_color', (event) ->
    $(".text").css("color", "#{$(this).val()}")
    $(".text a").css("color", "#{$(this).val()}")

  $(document).on 'change', '#user_font_name', (event) ->
    addGoogleFont($(this).val().split(' ').join('+'))
    $(".text h4 a").css("font-family", "#{$(this).val()}")
    $(".text p").css("font-family", "#{$(this).val()}")

  $(document).on 'change', '#user_font_size', (event) ->
    $(".text h4 a").css("font-size", "#{5+parseInt($(this).val(), 10)}px")
    $(".text p").css("font-size", "#{$(this).val()}px")

  # News River grid
  $container = $('#river-news-container')

  $container.imagesLoaded ->
    $container.masonry
      itemSelector: '.news-container'
    $container.masonry('bindResize')

  # Poll channel for 'realtime' update
  # TODO: could be replaced with websockets
  autoupdateRiver = ->
    if $('#river-news-container').length
      newElements = [] # elements queue
      fetchElements = ->
        @timestamp = Date.now()
        # read data-published-at of first .news-container to get
        # the latest published date
        publishedAt = $('.news-container').first().data('published-at') or '0'
        $.get(
          document.location+"?newest_published_at=#{publishedAt}"
        ).done (data) ->
          # insert new elements into queue, oldest first
          $('.news-container',data).each (index, element) ->
            newElements.unshift $(element)

        setTimeout(fetchElements, 60000) # vaguely relate to server cache timeout
    setTimeout(fetchElements, 1000)

    # prepend news elements to river
    prependElements = ->
      if $('#river-news-container').length
        if newElements.length > 0
          $element = newElements.shift()
          $container = $('#river-news-container')
          $container.prepend($element)
          $container.masonry('prepended', $element)
          $container.masonry('reloadItems')
          $container.masonry('layout')
        # only show the latest 50 news boxes to save memory and not overload the DOM
        # TODO: make configurable
        maxElements = 50
        if (elementsCount = $('.news-container').length) > maxElements
          $elements = $('.news-container').slice(-(elementsCount-maxElements))
          $('#river-news-container').masonry('remove', $elements)

        # serve items evenly distributed over 60 seconds which equals the server cache timeout
        timePassed = Date.now() - @timestamp
        timeout = if newElements.length > 0 then ((60000-timePassed)/newElements.length) else 10000
        setTimeout(prependElements, timeout)

    setTimeout(prependElements, 1200)
  autoupdateRiver()
