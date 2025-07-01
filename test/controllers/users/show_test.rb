require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(email: "test@email.com", password: "password")
    @token = JsonWebToken.encode( { id: @user.id, email: @user.email } )
  end

  def get_url
    "/users/account_details"
  end

  test "returns error if token is not present" do
    get get_url, params: { token: nil }
    body = JSON.parse(response.body)

    assert_response :unauthorized
    assert_equal "Token not present.", body["errors"]["message"]
  end

  test "returns the user id if token is valid and present" do
    get get_url, params: { token: @token }
    body = JSON.parse(response.body)

    assert_response :success
    assert_equal "Account Details Fetched successfully.", body["message"]
  end
end
