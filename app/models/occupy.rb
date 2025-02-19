class Occupy < ApplicationRecord
  belongs_to :registrant
  belongs_to :tag, optional: true

  enum status: { created: 0, in_use: 1, returned: 2, canceled: 3 }

  validates :registrant_id, presence: true
  validates :tag_id, presence: true
  validates :status, presence: true

  private

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "returned_at", "time_length", "updated_at" ]
  end
  def set_default_status
    self.status ||= "in_use"
  end
  def self.ransackable_associations(auth_object = nil)
    [ "registrant", "tag" ]
  end
end
