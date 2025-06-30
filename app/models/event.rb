class Event < ApplicationRecord

  belongs_to :user, foreign_key: :user_id
  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: %w(pending started completed)

  before_validation :set_status

  def set_status
    self.status = 'pending'
  end
end
