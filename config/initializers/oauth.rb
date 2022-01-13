require 'sam/oauth2'

# Set up valid audience and issuers.
Sam::OAuth2.configure do |oauth|
  oauth.audience = Rails.configuration.oauth.audiences

  Rails.configuration.oauth.issuers.each do |issuer|
    oauth.add_openid_issuer(issuer)
  end
end
