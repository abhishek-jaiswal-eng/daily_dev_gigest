class ApplicationController < ActionController::API

  def authorize
    token = params[:token] || request.headers['token']
    render json: { errors: { message: 'Token not present.'}}, status: :unauthorized and return unless token.present?
    begin
      @decoded_token = JsonWebToken.decode(token)
      @current_user = User.find_by_id(@decoded_token[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def encode user
    JsonWebToken.encode(
      {
        id: user.id,
        email: user.email
      }
    )
  end
end
