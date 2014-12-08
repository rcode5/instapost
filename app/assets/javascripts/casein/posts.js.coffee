$ ->  
  $form = $('.edit_post, .new_post')
  if ($form.length)

    customButtons = 
      emphasis: (context) ->
        "<li>" + 
        '<div class="btn-group">' +
        '<a class="btn btn-xs btn-default" data-wysihtml5-command="bold" title="CTRL+B" tabindex="-1"><strong>B</strong></a>' +
        '<a class="btn btn-xs btn-default" data-wysihtml5-command="italic" title="CTRL+I" tabindex="-1"><em>I</em></a>' +
        '<a class="btn btn-xs btn-default" data-wysihtml5-command="underline" title="CTRL+U" tabindex="-1"><u>U</u></strong></a>' +
        '</div>' +
        "</li>"

    $form.find("#post_note").wysihtml5
      customTemplates: customButtons
      toolbar:
        size: 'xs'
        'font-styles': false,
        emphasis: true
        link: true
        fa: true
        image: false
        lists: false
        blockquote: false
  
