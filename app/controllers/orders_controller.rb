require 'net/http'

class OrdersController < ApplicationController
  def index
    # Setup the AccessTokenAgent with an Access Token URL, a Key and a Secret
    agent = Sam::OAuth2::AccessTokenAgent.new(
      oidc_provider_url: Rails.configuration.oauth.oidc_provider,
      client_id: Rails.configuration.oauth.client_id,
      client_secret: Rails.configuration.oauth.client_secret
    )

    # Retrieve an AccessToken instance
    access_token = agent.retrieve(audience: 'https://api.*.snpd.io/settlementorders', scopes: ['read:settlement_orders'])

    uri = URI('https://settlementorders.pce0.snpd.io')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request_get('/api/orders', Authorization: access_token.to_authorization_header)
    json = JSON.parse(response.body)
    case response
    when Net::HTTPSuccess
      render json: json, status: 200
    else
      render json: { error: 'something went wrong', response_from_service: json}, status: response.code
    end
  end
end
