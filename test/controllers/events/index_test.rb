require "test_helper"

class EventsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create(email: "test@example.com", password: "password")
    @token = JsonWebToken.encode({ id: @user_1.id, email: @user_1.email})
    @event = @user_1.events.create(title: "Event 1", description: "Description 1")
  end

  def get_url
    "/events"
  end

  def params
    { token: @token }
  end

  test "return success response with events for current user" do
    get get_url, params: params
    body = JSON.parse(response.body)

    assert_response :success
    assert_equal "Events fetched successfully", body["message"]
    assert_equal @event.id, body["data"][0]["id"]
    assert_equal @event.title, body["data"][0]["title"]
  end

  test "returns error message if event is not present for current user" do
    @event.destroy
    get get_url, params: params
    body = JSON.parse(response.body)

    assert_response :not_found
    assert_equal "No events are present for current user", body["errors"]["message"]
  end
end
