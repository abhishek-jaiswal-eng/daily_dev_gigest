require "test_helper"

class EventsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = User.create(email: "test@example.com", password: "password")
    @token = JsonWebToken.encode({ id: @user_1.id, email: @user_1.email})
    @event = @user_1.events.create(title: "Event 1", description: "Description 1")
  end

  def get_url id
    "/events/#{id}"
  end

  def params
    { token: @token, status: 'started', title: "Title 1" }
  end

  test "returns success response for event update" do
    put get_url(@event.id), params: params
    res = JSON.parse(response.body)

    assert_response :success
    assert_equal "Title 1", res["data"]["title"]
    assert_equal "Event updated successfully.", res["message"]
  end

  test "returns error response for event update" do
    put get_url(@event.id), params: params.merge(description: '')
    res = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_equal "Something went wrong", res["errors"]["message"]
  end
end
