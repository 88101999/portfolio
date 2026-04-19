class OauthsController < ApplicationController
  skip_before_action :require_login
  skip_forgery_protection only: :callback
  before_action :validate_provider

  def oauth
    login_at(params[:provider])
  rescue StandardError => e
    Rails.logger.error "OAuth redirect error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    redirect_to login_path, alert: 'ログインに失敗しました'
  end

  def callback
    provider = params[:provider]
    
    @user = login_from(provider) || create_from(provider)

    if @user&.persisted?
      reset_session
      auto_login(@user)
      redirect_to root_path, notice: 'ログインしました'
    else
      handle_oauth_failure(@user)
    end
  rescue StandardError => e
    handle_oauth_error(e)
  end

  def failure
    redirect_to login_path, alert: 'ログインに失敗しました'
  end

  private

  def validate_provider
    allowed_providers = %w[google]
    unless allowed_providers.include?(params[:provider])
      redirect_to login_path, alert: '無効なプロバイダーです'
    end
  end

  def handle_oauth_failure(user)
    error_messages = user&.errors&.full_messages&.join(', ') || '不明なエラー'
    Rails.logger.error "OAuth failed: #{error_messages}"
    redirect_to login_path, alert: "ログインに失敗しました: #{error_messages}"
  end

  def handle_oauth_error(error)
    Rails.logger.error("OAuth Error: #{error.message}")
    Rails.logger.error(error.backtrace.join("\n"))
    redirect_to login_path, alert: 'ログインに失敗しました。もう一度お試しください。'
  end
end