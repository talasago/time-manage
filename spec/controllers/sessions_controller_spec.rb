require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "user.save success" do
      expect do
        post :create, params: { user:
          {
            name:  user.name,
            password:  user.password
          }
        }
      end.not_to change(User, :count)
      expect(flash[:success]).to eq "#{user.name}さん ようこそ"
      expect(request.path_info).to eq(user_path(User.find_by(name: user_name).id))
    end

    #it "user.save faild" do
    #  post :create, params: { :name
    #    {
    #        name:  user_name,
    #        password:              "foobarbaz",
    #        password_confirmation: "foobarbaz"
    #    }
    #  }.not_to change(User, :count)
    #end

    #post送信時のパラメータ
    #userのsave成功時
      #expect(flash[:success]).to eq "#{user.name}さん ようこそ"
      #ユーザホーム画面にリダイレクトしている
    #userのsave失敗時
      #flashにdangerの値が入っていること
      #urlがga/loginとなること

  end
end
