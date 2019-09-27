require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do
  before { visit new_user_path }
  let(:user_name) {"TestUser003"}

  describe "common" do
    it "displayed 'ユーザー新規登録'" do
      expect(page).to have_http_status(:ok)
      expect(page).to have_title("ユーザー新規登録")
    end
  end

  describe "signup success" do
    it "user insert and displayed 'ユーザーホーム画面'" do
      fill_in "user_name",	with: user_name
      fill_in "user_password",	with: "password&4"
      fill_in "user_password_confirmation",	with: "password&4"
      expect do
        click_on "利用規約に同意の上、ユーザを作成する"
      end.to change(User, :count).by(1)

      expect(page).to have_content(user_name + "さん ようこそ")
      expect(page).to have_content(user_name)
      expect(page).to have_title(user_name)
    end
  end

  describe "signup faild" do
    context "password_confirmation difference" do
      it "user not insert because password_confirmation difference" do
        fill_in "user_name",	with: user_name
        fill_in "user_password",	with: "password"
        fill_in "user_password_confirmation",	with: "password&4"
        expect do
          click_on "利用規約に同意の上、ユーザを作成する"
        end.not_to change(User, :count)

        expect(page).to have_css "div#error_explanation"
        expect(page).to have_css "div.field_with_errors"
        expect(page).to have_css "form[action=\"#{new_user_path}\"]"
      end
    end
  end
end