class PostsController < ApplicationController
  PICS_PER_PAGE = 3
  def index
    @page = params[:p].to_i 
    offset = @page * PICS_PER_PAGE
    @posts = (Post.order created_at: :desc).limit(PICS_PER_PAGE).offset(offset)
    if request.xhr?
      # render without template
      render @posts, layout: false
    end
  end

end
