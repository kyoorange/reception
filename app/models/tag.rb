class Tag < ApplicationRecord
  has_many :occupies
  # Ransackで使用可能なアソシエーション
  def self.ransackable_associations(auth_object = nil)
    [ "occupies" ]
  end

  # Ransackで使用可能な属性
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "number", "updated_at" ]
  end
end
