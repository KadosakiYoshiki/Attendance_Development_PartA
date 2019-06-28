class Overtime < ApplicationRecord
  belongs_to :user
  
  validates :applied_on, presence: true
  validates :business_content, length: { maximum: 50 }
  validates :permit_note, length: { maximum: 50 }
end
