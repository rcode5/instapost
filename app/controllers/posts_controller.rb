class PostsController < ApplicationController
  PICS_PER_PAGE = 20
  def index
    @posts = (Post.where(:created_at > params[:s]).order created_at: :desc).limit(PICS_PER_PAGE)
  end
end
