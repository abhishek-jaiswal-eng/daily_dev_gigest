require "test_helper"

class EventsShowTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create(email: "test@example.com", password: "password")
    @token = JsonWebToken.encode({ id: @user_1.id, email: @user_1.email})
    @event = @user_1.events.create(title: "Event 1", description: "Description 1")
  end

  def get_url id
    "/events/#{id}"
  end

  test "return success response" do
    get get_url(@event.id), params: { token: @token }
    body = JSON.parse(response.body)

    assert_response :success
    assert_equal "Event fetched successfully.", body["message"]
    assert_equal @event.id, body["data"]["id"]
  end

  test "return error response if event is not present" do
    get get_url(0), params: { token: @token }
    body = JSON.parse(response.body)

    assert_response :not_found
    assert_equal "No event found with 0", body["errors"]["message"]
  end
end
