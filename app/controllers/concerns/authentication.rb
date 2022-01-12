require 'sam/oauth2'

# Public: A Concern, that when mixed into controllers, causes requests to be Authenticated by SAM.
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    rescue_from Sam::OAuth2::OAuthError, with: :rescue_oauth_error
  end

  private

  def authenticate_request!
    if ENV['SKIP_AUTHENTICATION'] == 'true' && Rails.env.development?
      return true
    end

    # Parse the header value
    access_token = Sam::OAuth2::AccessToken.from_authorization_header(request.headers['Authorization'])

    # Authenticate the Access Token
    begin
      access_token.authenticate!
    rescue Sam::OAuth2::OAuthError => e
      # Custom error handling could go here, we will re-raise and delegate to the error handler here.
      raise e
    end

    @access_token = access_token

    true
  end

  def rescue_oauth_error(_error)
    response.set_header('WWW-Authenticate', _error.to_http_www_authenticate_header)
    render json: { error: 'Invalid token' },
           status: _error.to_http_response_code
  end
end