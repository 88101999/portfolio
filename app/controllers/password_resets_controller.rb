class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    
    # セキュリティ上、存在しないメールアドレスでも同じメッセージを表示
    redirect_to root_path, success: "パスワードリセットの手順を記載したメールを送信しました。"
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    if @user.blank?
      redirect_to root_path, danger: 'パスワードリセットのリンクが無効か、有効期限が切れています'
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?
    
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password(params[:user][:password])
      redirect_to login_path, success: "パスワードをリセットしました。新しいパスワードでログインしてください。"
    else
      flash.now[:danger] = "パスワードのリセットに失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end
end