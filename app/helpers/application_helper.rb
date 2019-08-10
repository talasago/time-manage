module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "時間管理app"
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end
end
