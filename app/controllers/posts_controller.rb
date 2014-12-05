class PostsController < ApplicationController
  PICS_PER_PAGE = 20
  def index
    @posts = (Post.order created_at: :desc).limit(PICS_PER_PAGE)
  end
end
