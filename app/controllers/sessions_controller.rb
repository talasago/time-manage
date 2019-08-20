class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
        log_in(@user)
        flash[:success] = "#{@user.name}さん おかえりなさい"
        redirect_to user_path(@user.id)
    else
      flash.now[:danger] = "ユーザー名またはパスワードが違います"
      render "new"
    end
  end

  def destroy
    logout
    flash[:success] = "ログアウトしました"
    redirect_to root_path
  end
end
