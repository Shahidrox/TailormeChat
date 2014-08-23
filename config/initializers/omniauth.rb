Rails.application.config.middleware.use OmniAuth::Builder do
    if Rails.env.development?
      # The following is for facebook
      provider :facebook, 'xxx', '4e0f46858adfb45a2dd66ff869dcd340', {:provider_ignores_state => true}
      # If you want to also configure for additional login services, they would be configured here.
    else
      provider :facebook, 'xxx', 'f9e734301b0e4fb7112a3b11567f01f3', {:provider_ignores_state => true}
    end
end