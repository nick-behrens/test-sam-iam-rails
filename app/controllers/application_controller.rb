class ApplicationController < ActionController::Base
  include Authentication

  def index
    render json: { test: @token_claims },
           status: 200
  end
end
