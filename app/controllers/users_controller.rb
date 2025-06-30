class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  def index
    render json: { users: User.all }, status: 200  and return if User.any?
    render json: { message: "No user is present." }, status: :not_found
  end

  def create
    render json: { errors: { message: 'User Already Present. Please Login'}}, status: 422 and return if check_existing_user(user_params)
    user = User.new(user_params)
    debugger
    if user.valid? && user.save
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(user, each_serializer: UsersSerializer),
        user_token: encode(user),
        message: "Account created successfully"
      }, status: :created
    else
      render json: { errors: { message:  'Something went wrong.' }}, status: 422
    end
  end

  def show
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@current_user,
      each_serializer: UsersSerializer),
      message: "Account Details Fetched successfully."
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def check_existing_user params
    user = User.find_by_email(params[:email])
    return user.present? ? true : false
  end
end
