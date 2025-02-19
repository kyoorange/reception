class Registrant < ApplicationRecord
  has_many :occupies

  def self.ransackable_attributes(auth_object = nil)
    [ "address1", "address2", "belongs", "city", "created_at", "details", "email", "found", "id", "job", "name", "number", "phone", "prefecture", "pronunciation", "updated_at" ]
  end
  def self.ransackable_associations(auth_object = nil)
    [ "occupies" ]
  end
end
