require 'test_helper'

class UsersCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(email: "test@email.com", password: "password")
  end


  test "returns error if user is already present" do
    post "/users", params: { user: { email: @user.email, password: 'password'}}
    body = JSON.parse(response.body)

    assert_equal "User Already Present. Please Login", body["errors"]["message"]
    assert_response :unprocessable_entity
  end

  test "return error if user is not valid" do
    post "/users", params: { user: { email: "test@example.com" } }
    body = JSON.parse(response.body)

    assert_equal "Something went wrong.", body["errors"]["message"]
    assert_response :unprocessable_entity
  end

  test "return success response if user is created" do
    post "/users", params: { user: { email: "test@example.com", password: "password" } }

    body = JSON.parse(response.body)
    assert_response :created
    assert body["user_token"].present?
    assert_equal "Account created successfully", body["message"]
  end
end
