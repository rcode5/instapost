ready = ->
  debugger
  $('#load-more').on 'click', () ->
    $moreButton = $(@)
    page = parseInt($moreButton.data('page'),10)
    numPages = parseInt($moreButton.data('num-pages'),10)
    $.ajax
      url: '/posts'
      data:
        p: page
      success: (data) ->
        $data = $(data)
        $data.css("display", "none");
        $('.post-list .end-list').last().before($data);
        $data.slideDown();
        if (page < numPages)
          $moreButton.data('page', page + 1)
        else
          $('#load-more').remove()
        
        
$(document).ready ready
$(document).on 'page:load', ready
