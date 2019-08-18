require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do
  before { visit login_path }
  let(:user_name) {"TestUser003"}

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
      fill_in "user_name",	with: user_name
      fill_in "user_password",	with: "password&4"
      fill_in "user_password_confirmation",	with: "password&4"

      expect do
        click_on "ログイン"
      end.to not_change_(User, :count)

      expect(page).to have_content(user_name + "さん ようこそ")
      expect(page).to have_content(user_name)
      expect(page).to have_title(user_name)

      expect(page).to have_css "a[half=?]", login_path, count: 0
      expect(page).to have_css "a[half=?]", logout_path, count: 0
      expect(page).to have_css "a[half=?]", user_path(user)
    end
  end

  describe "login faild" do
    context "password_confirmation difference" do
      it "user not insert because password_confirmation difference" do
        fill_in "user_name",	with: ""
        fill_in "user_password",	with: ""
        fill_in "user_password_confirmation",	with: "password&4"
        expect do
           click_on "ログイン"
        end.not_to change(User, :count)

        expect(page).to have_css "div#error_explanation"
        expect(page).to have_css "div.field_with_errors"

        visit root_path

      end
    end
  end
end