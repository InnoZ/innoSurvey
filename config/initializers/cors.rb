Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource /\A\/surveys\/\d{1}\z/,
      headers: :any,
      methods: [:get, :post, :options, :head],
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
      # max_age: 0
  end
end
