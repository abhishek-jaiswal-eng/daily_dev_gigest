require "test_helper"

class EventsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create(email: "test@example.com", password: "password")
    @token = JsonWebToken.encode({ id: @user_1.id, email: @user_1.email})
  end

  def get_url
    "/events"
  end

  def params
    { token: @token, event: { title: "Event 1", description: "Description" } }
  end

  test "returns the success response for create action" do
    post get_url, params: params
    res = JSON.parse(response.body)

    assert_response :created
    assert_equal "Event created successfully", res["message"]
    assert res["data"].present?
  end

  test "return error response if event is not saved into database" do
    post get_url, params: { token: @token, event: { title: "Title 1" } }
    res = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_equal "Something went wrong", res["errors"]["message"]
  end
end
