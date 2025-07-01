require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create!(email: "email@example.com", password: "password")
    @user_2 = User.create(email: "test@example.com", password: "password1")
  end

  def get_url
    "/users"
  end

  test "return list of all users" do
    get get_url
    body = JSON.parse(response.body)

    assert_response :success
    assert_equal 2, body["users"].size
    assert_equal "email@example.com", body["users"][0]["email"]
    assert_equal "test@example.com", body["users"][1]["email"]
  end

  test "returns error message if no user is present" do
    User.destroy_all
    get get_url
    body = JSON.parse(response.body)

    assert_response :not_found
    assert_equal "No user is present.", body["errors"]["message"]
  end
end
