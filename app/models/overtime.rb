class Overtime < ApplicationRecord
  belongs_to :user
  
  validates :applied_on, presence: true
  validates :business_content, length: { maximum: 50 }
  validates :permit_note, length: { maximum: 50 }
  enum status_id: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 } 
  validates_acceptance_of :permit, allow_nil: true, on: :update_overtimes
end
