class ApplicationController < ActionController::Base
  before_action :require_login
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :success, :danger

  private

  def not_authenticated
    flash[:danger] = "ログインしてください"
    redirect_to login_path
  end

  # Rails 7.2対応: Sorceryのリダイレクトで外部URLを許可
  def redirect_to(options = {}, response_options = {})
    # Googleの認証URLへのリダイレクトを許可
    if options.is_a?(String) && options.start_with?("https://accounts.google.com")
      response_options[:allow_other_host] = true
    end
    super(options, response_options)
  end
end
