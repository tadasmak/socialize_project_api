class Rack::Attack
  throttle("limit_all_requests", limit: 100, period: 1.minute) do |req|
    req.env["warden"].user&.id || req.ip
  end
  # Throttle requests to POST /api/v1/activities to 5 requests per minute per user
  throttle("limit_activity_creation", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/activities" && req.post?
      # Use the user's ID or IP address as the identifier
      req.env["warden"].user&.id || req.ip
    end
  end

  # Custom response for throttled requests
  self.throttled_response = lambda do |env|
    [ 429, { "Content-Type" => "application/json" }, [ { error: "Rate limit exceeded. Try again later." }.to_json ] ]
  end
end
