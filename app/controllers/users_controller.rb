class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index show]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "#{@user.name}さん ようこそ！"
      redirect_to user_path(@user.id)
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation,
      "birth_date(1i)", "birth_date(2i)", "birth_date(3i)",
      :age_birth_checkflg, :age, :gender, :employment, :hobby, :remarks)
  end

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end
end
