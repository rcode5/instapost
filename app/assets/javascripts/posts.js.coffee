$ ->
  $('#load-more').on 'click', () ->
    $moreButton = $(@)
    page = parseInt($moreButton.data('page'),10)
    numPages = parseInt($moreButton.data('num-pages'),10)
    $.ajax
      url: '/posts'
      data:
        p: page
      success: (data) ->
        $('.post-list .end-list').last().after(data);
        if (page < numPages)
          $moreButton.data('page', page + 1)
          $moreButton.data('num-pages', page + 1)
        else
          $('#load-more').remove()
        

        
