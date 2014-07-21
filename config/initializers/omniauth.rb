Rails.application.config.middleware.use OmniAuth::Builder do
    if Rails.env.development?
      # The following is for facebook
      provider :facebook, '1497719563795251', '4e0f46858adfb45a2dd66ff869dcd340', {:provider_ignores_state => true}
      # If you want to also configure for additional login services, they would be configured here.
    else
      provider :facebook, '562596713782679', '81d3b07a8028e54c993625a2f8d80175', {:provider_ignores_state => true}
    end
end