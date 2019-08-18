require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do
  before { visit login_path }
  let(:user) { FactoryBot.create(:user) }

  describe "common" do
    it "displayed 'ログイン'" do
      expect(page).to have_title("ログイン")
      expect(page).to have_http_status(:ok)
      expect(page).to have_content("ログイン")
    end

    it "'ユーザー新規登録' click to displayed 'ユーザー新規登録画面'" do
      expect do
        click_on "ユーザー新規登録"
      end.not_to change(User, :count)

      expect(page).to have_http_status(:ok)
      expect(page).to have_title("ユーザー新規登録")
      expect(page).to have_content("ユーザー新規登録")
    end
  end

  describe "login success" do
    it "user login and displayed 'ユーザーホーム画面'" do

      #fixture読み込み
      fill_in "session_name",	with: user.name
      fill_in "session_password",	with: user.password

      expect do
        click_button "ログイン"
      end.not_to change(User, :count)

      expect(page).to have_content(user.name "#{user.name}さん ようこそ")
      expect(page).to have_css("h1##{user.name}")
      expect(page).to have_title(user.name)

      expect(page).to have_css("a[half=?]", login_path, count: 0)
      expect(page).to have_css("a[half=?]", logout_path)
      expect(page).to have_css("a[half=?]", user_path(user))
    end
  end

  describe "login faild" do
    context "password_confirmation difference" do
      it "user not insert because password_confirmation difference" do
        fill_in "session_name",	with: ""
        fill_in "session_password",	with: ""
        expect do
          click_button "ログイン"
        end.not_to change(User, :count)

        #expect(flash[:danger]).not_to be_empty.to eq "ユーザー名またはパスワードが異なります"
        expect(page).to have_css("div#error_explanation")
        expect(page).to have_css("div.field_with_errors")
        visit root_path
        expect(flash[:success]).to be_empty
      end
    end
  end
end