class Center < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :attendance_type, presence: true
end
