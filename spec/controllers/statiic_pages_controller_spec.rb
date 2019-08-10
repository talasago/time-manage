require 'rails_helper'
base_title = "時間管理app"

describe "Static pages" do
  describe "Home page" do
    it "homeが表示され、'時間管理webアプリ'と表示されること'" do
      visit '/'
      expect(page).to have_content('時間管理webアプリ')
      expect(page).to have_title('時間管理app')
    end
  end

  describe "問い合わせ" do
    it "問い合わせページが表示され、'問い合わせ先'と表示されること'" do
      visit '/contact'
      expect(page).to have_content('問い合わせ先')
      expect(page).to have_title "問い合わせ - #{base_title}"
    end
  end

end
