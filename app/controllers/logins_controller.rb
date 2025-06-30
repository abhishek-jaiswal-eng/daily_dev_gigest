class LoginsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user.present?
      if user.authenticate(params[:password])
        render json: {
          data: ActiveModelSerializers::SerializableResource.new(user,
          each_serializer: UsersSerializer),
          user_token: encode(user),
          message: "Account Logged In Successfully."
        }, status: :ok
      else
        render json: { errors: { message: "Password doesn't match"}}, status: :unauthorized
      end
    else
      render json: { errors: { message: "User not found"}}, status: :not_found
    end
  end
end
