require "redis"

REDIS_CLIENT = if Rails.env.production?
                 Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
else
                 Redis.new(host: "redis", port: 6379, db: 0)
end
