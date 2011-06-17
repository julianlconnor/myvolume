# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, '155945684474895', '23194757c86ffffbfb3543eddfd0d999', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '155945684474895', '23194757c86ffffbfb3543eddfd0d999', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end