require "test_helper"

class EventsDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create(email: "test@example.com", password: "password")
    @token = JsonWebToken.encode({ id: @user_1.id, email: @user_1.email})
    @event = @user_1.events.create(title: "Event 1", description: "Description 1")
  end

  def get_url id
    "/events/#{id}"
  end

  def params
    { token: @token }
  end

  test "returns success response for event destruction" do
    delete get_url(@event.id), params: params
    res = JSON.parse(response.body)

    assert_response :success
    assert_equal "Event deleted successfully", res["message"]
  end
end
