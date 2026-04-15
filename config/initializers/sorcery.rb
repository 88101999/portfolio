# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
#
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging,
# :magic_login, :external
Rails.application.config.sorcery.submodules = [:reset_password]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # --- user config ---
  config.user_config do |user|
    # -- core --
    # How many times to apply encryption to the password.
    # Default: 1 in test env, `nil` otherwise
    user.stretches = 1 if Rails.env.test?

    # -- reset_password --
    # REQUIRED:
    # Password reset mailer class.
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
    user.reset_password_expiration_period = 3600
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = "User"
end
