# app/serializers/application_serializer.rb
class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
end
