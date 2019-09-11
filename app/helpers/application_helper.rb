module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    if page_title.empty?
      app_name
    else
      page_title + " - " + app_name
    end
  end

  #アプリ名を返します
  def app_name
    "TimeRecordShare"
  end
end
