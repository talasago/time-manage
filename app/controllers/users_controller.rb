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

  def show_detail
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    redirect_to(root_path) unless accessed_user_logged_in?(@user)
  end

  def update
    @user = User.find(params[:id])
    redirect_to(root_path) unless accessed_user_logged_in?(@user)

    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    redirect_to(root_path) unless accessed_user_logged_in?(user)
    user.destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to root_path
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
