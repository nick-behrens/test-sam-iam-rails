class ApplicationController < ActionController::Base
  include Authentication

  def index
    render json: { test: @access_token.claims },
           status: 200
  end

  def protected
    if @access_token.scopes.include?('read:settlement_orders')
      render json: { test: @access_token.claims },
             status: 200
    else
      render json: { error: 'Insufficient Scope, a scope of read:settlement_orders is required.' },
             status: 403
    end
  end
end
