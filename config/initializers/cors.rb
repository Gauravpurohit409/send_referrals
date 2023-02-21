Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3001'
      resource '*', 
      headers: :any, 
      methods: [:get, :post, :delete, :put, :patch],
      expose: %i[access-token expiry token-type uid client]
    end
  end