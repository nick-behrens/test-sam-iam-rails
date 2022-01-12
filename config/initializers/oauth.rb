require 'sam/oauth2'

# Set up valid audience and issuers.
Sam::OAuth2.configure do |oauth|
  oauth.valid_audience = Rails.configuration.oauth.valid_audiences

  Rails.configuration.oauth.valid_issuers.each do |issuer|
    oauth.add_openid_issuer(issuer)
  end
end
