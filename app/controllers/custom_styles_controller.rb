class CustomStylesController < ApplicationController

  def show
    @custom = Customization.current;
    unless @custom
      render text: '' and return
    end
  end
end
