require 'rails_helper'
base_title = "TimeRecordShare"

describe "Static pages" do
  describe "Home page" do
    it "homeが表示され、'TimeRecordShare'と表示されること'" do
      visit '/'
      expect(page).to have_content(base_title)
      expect(page).to have_title(base_title)
    end
  end

  describe "問い合わせ" do
    it "問い合わせページが表示され、'問い合わせ先'と表示されること'" do
      visit '/contact'
      expect(page).to have_content(base_title)
      expect(page).to have_title "問い合わせ - #{base_title}"
    end
  end
end
