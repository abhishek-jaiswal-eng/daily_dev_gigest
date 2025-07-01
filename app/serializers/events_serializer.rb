class EventsSerializer < ApplicationSerializer
  attributes *[
    :title,
    :description,
    :status,
    :user
  ]

  attribute :user do |resource|
    user = User.find_by_id(resource.object.user_id)
    {
      id: user.id,
      email: user.email
    }
  end
end
