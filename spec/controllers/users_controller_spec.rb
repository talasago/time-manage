require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#create" do
    before { get:new }
    let(:user) {
      User.new(
        name:  "TestUser002",
        password:              "foobarbaz",
        password_confirmation: "foobarbaz"
      )
    }
    it "common" do
      expect(response).to have_http_status(:ok)
    end

    context "user.save sucsess" do
      let(:user_name) {"TestUser002"}

      it "redirect to 'ユーザーホーム画面'" do
        expect do
          post :create, params: { user:
            {
              name:  user_name,
              password:              "foobarbaz",
              password_confirmation: "foobarbaz"
            }
          }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to user_path(User.find_by(name: user_name).id)
      end
    end

    context "user.save faild" do
      it "not redirect" do
        expect do
          post :create, params: { user:
            {
              name:  "TestUser002",
              password:              "foobarbaz",
              password_confirmation: ""
            }
          }
        end.not_to change(User, :count)
        expect(request.path_info).to eq(new_user_path)
      end
    end
  end
end
