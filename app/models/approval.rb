class Approval < ApplicationRecord
  belongs_to :user
  
  enum status_id: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 } 
  validates :month, presence: true
  validates_acceptance_of :permit, allow_nil: true, on: :update_approvals

end
