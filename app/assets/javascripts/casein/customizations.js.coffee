ready = ->
  $sampler = $('#sampler p');

  if $sampler.length && availableColors
    setSelectColor = () ->
      $colorSelector = $('form #customization_color');
      currentColor = availableColors[$colorSelector.val()] || 'inherit';
      $colorSelector.css('background-color', currentColor)
      $sampler.css('background-color', currentColor)

    setSelectColor()
    $('form #customization_color').on 'change', setSelectColor

    setSelectFont = () ->
      $fontSelector = $('form #customization_font');
      currentFont = availableFonts[$fontSelector.val()] || 'inherit';
      $fontSelector.css('font-family', currentFont)
      $sampler.css('font-family', currentFont)

    setSelectFont()
    $('form #customization_font').on 'change', setSelectFont

$(document).ready ready
$(document).on 'page:load', ready
