module PostsHelper
  def more_button(page)
    npages = (Post.count.to_f / PostsController::PICS_PER_PAGE.to_f)
    next_page = page + 1.0
    if next_page <= npages
      more = "More"
      col_classes = %w|col-sm-8 col-sm-offset-2 col-xs-12 col-md-6 col-sm-8 col-md-offset-3|.join(" ")
      btn_classes = %w|btn btn-localized|.join(" ")
      content_tag 'div', class: col_classes do
        content_tag 'a', more, id: 'load-more', class: btn_classes, title: more, 'data-num-pages' => npages, 'data-page' => (page.to_i + 1) do
          content_tag 'i', '', class: 'fa fa-arrow-circle-down', title: more
        end
      end
    end
  end
end
