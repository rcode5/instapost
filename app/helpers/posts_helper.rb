module PostsHelper
  def more_button(page)
    if (Post.count.to_f / PostsController::PICS_PER_PAGE.to_f) > (page + 1.0)
      more = "More"
      content_tag 'div', class: 'load-more' do
        content_tag 'a', more, id: 'load-more', class: 'btn btn-localized', title: more, 'data-page' => (page.to_i + 1) do
          content_tag 'i', '', class: 'fa fa-arrow-circle-down', title: more
        end
      end
    end
  end
end
