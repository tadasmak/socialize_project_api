require "redis"

$redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0")
