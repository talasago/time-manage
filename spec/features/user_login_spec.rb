require 'rails_helper'

RSpec.feature "UserLogin", type: :feature do
  before do
    visit login_path
    @user = FactoryBot.create(:user)
  end

  describe "common" do
    it "displayed 'ログイン'" do
      expect(page).to have_title("ログイン")
      expect(page).to have_http_status(:ok)
      expect(page).to have_content("ログイン")
      expect(page).to have_css("a[href=\"#{login_path}\"]")
    end

    it "'ユーザー新規登録' click to displayed 'ユーザー新規登録画面'" do
      expect do
        click_link "ユーザー新規登録"
      end.not_to change(User, :count)

      expect(page).to have_http_status(:ok)
      expect(page).to have_title("ユーザー新規登録")
      expect(page).to have_content("ユーザー新規登録")
    end
  end

  describe "login success" do
    it "user login and displayed 'ユーザーホーム画面' and logout" do
      #factory読み込み
      fill_in "session_name",	with: @user.name
      fill_in "session_password",	with: @user.password

      expect do
        click_button "ログイン"
      end.not_to change(User, :count)

      expect(page).to have_content("#{@user.name}さん おかえりなさい")
      expect(page).to have_css("h1", text: @user.name)
      expect(page).to have_title(@user.name)

      expect(page).not_to have_css("a[href=\"#{login_path}\"]")
      expect(page).to have_css("a[href=\"#{logout_path}\"]")
      expect(page).to have_css("a[href=\"#{user_path(@user)}\"]")

      click_on @user.name
      click_on "ログアウト"

      expect(page).to have_css("a[href=\"#{login_path}\"]")
      expect(page).not_to have_css("a[href=\"#{logout_path}\"]")
      expect(page).not_to have_css("a[href=\"#{user_path(@user)}\"]")
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

        expect(page).to have_selector("div.alert.alert-danger", text: "ユーザー名またはパスワードが違います")
        visit root_path
        expect(page).not_to have_css("div.alert.alert-danger")
      end
    end
  end

  #セッションがない状態でuser/:idとURLを入れたらログインにリダイレクトするか。
  describe "#show" do
    context "when not login_state" do
      it "redirect_to login page" do
        visit user_path @user.id
        expect(page).to have_title("ログイン")
        expect(page).to have_http_status(:ok)
        expect(page).to have_content("ログイン")
        expect(page).to have_css("a[href=\"#{login_path}\"]")
      end
    end
  end
end
