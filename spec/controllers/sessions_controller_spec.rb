require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "when user exist and authenticate success" do
      context "remember check_on" do
        it "redirect to 'ユーザーホーム画面' and" do
          expect do
            post :create, params: { session:
              {
                name:  @user.name,
                password:  @user.password,
                remember_me: "1"
              }
            }
          end.not_to change(User, :count)
          expect(flash[:success]).to eq "#{@user.name}さん おかえりなさい"
          expect(request).to redirect_to user_path(User.find_by(name: @user.name).id)
          expect(session[:user_id]).to eq @user.id
          expect(cookies.permanent.signed[:user_id]).to_not eq nil
          expect(cookies.permanent[:remember_token]).to_not eq nil
        end
      end

      context "remember check_off" do
        it "redirect to 'ユーザーホーム画面' and" do
          expect do
            post :create, params: { session:
              {
                name:  @user.name,
                password:  @user.password,
                remember_me: "0"
              }
            }
          end.not_to change(User, :count)
          expect(flash[:success]).to eq "#{@user.name}さん おかえりなさい"
          expect(request).to redirect_to user_path(User.find_by(name: @user.name).id)
          expect(session[:user_id]).to eq @user.id
          expect(cookies.permanent.signed[:user_id]).to eq nil
          expect(cookies.permanent[:remember_token]).to eq nil
        end
      end
    end

    context "when user exist and authenticate faild" do
      it "not redirect and displayd error message " do
        expect do
          post :create, params: { session:
            {
              name:  "",
              password:  @user.password
            }
          }
        end.not_to change(User, :count)
        expect(flash[:danger]).to eq "ユーザー名またはパスワードが違います"
        expect(request.path_info).to eq login_path
        expect(session[:user_id]).to eq nil
      end
    end
  end

  describe "delete #destroy" do
    context "when session[:user_id] exist" do
      before do
        post :create, params: { session:
          {
            name:  @user.name,
            password:  @user.password
          }
        }
      end

      it "redirect to 'ユーザーホーム画面'" do
        expect do
          delete :destroy
        end.not_to change(User, :count)

        expect(flash[:success]).to eq "ログアウトしました"
        expect(request).to redirect_to root_path
        expect(session[:user_id]).to eq nil
        expect(cookies.permanent.signed[:user_id]).to eq nil
        expect(cookies.permanent[:remember_token]).to eq nil
      end
    end

    context "when session[:user_id] not exist" do
      it "redirect to 'ユーザーホーム画面'" do
        expect do
          delete :destroy
        end.not_to change(User, :count)

        expect(flash[:success]).to eq "ログアウトしました"
        expect(request).to redirect_to root_path
        expect(session[:user_id]).to eq nil
        expect(cookies.permanent.signed[:user_id]).to eq nil
        expect(cookies.permanent[:remember_token]).to eq nil
      end
    end
  end
end
