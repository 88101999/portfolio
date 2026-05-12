# The first thing you need to configure is which modules you need in your app.
Rails.application.config.sorcery.submodules = [ :reset_password, :external, :remember_me ]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # -- external --
  config.external_providers = [ :google ]

  config.google.key = ENV["GOOGLE_CLIENT_ID"]
  config.google.secret = ENV["GOOGLE_CLIENT_SECRET"]

  config.google.callback_url = if Rails.env.production?
    "https://portfolio-kvvz.onrender.com/oauth/callback?provider=google"
  else
    "http://localhost:3000/oauth/callback?provider=google"
  end

  config.google.user_info_mapping = {
    email: "email",
    name: "name"
  }

  config.google.scope = "email profile"
  config.google.user_info_url = "https://www.googleapis.com/oauth2/v1/userinfo"

  # --- user config ---
  config.user_config do |user|
    # -- core --
    user.stretches = 1 if Rails.env.test?

    # -- remember_me --
    user.remember_me_for = 604800
    # -- reset_password --
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
    user.reset_password_expiration_period = 3600

    # -- external --
    user.authentications_class = Authentication
  end

  config.user_class = "User"
end

# OmniAuth の設定
OmniAuth.config.allowed_request_methods = [ :post, :get ]
OmniAuth.config.silence_get_warning = true
