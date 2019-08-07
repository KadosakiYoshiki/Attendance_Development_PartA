class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 未来の日付は編集不可
  validate :cannot_config_day_at_future
  
  enum status_id: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }, _prefix: true
  enum status_id_overtime: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }, _prefix: true
  validates_acceptance_of :next_day, allow_nil: true, on: :update_one_month
  validates_acceptance_of :permit, allow_nil: true, on: :update_attendances

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present? && !next_day
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
    
    if applying_started_at.present? && applying_finished_at.present? && !applying_next_day
      errors.add(:started_at, "より早い退勤時間は無効です") if applying_started_at > applying_finished_at
    end
  end
  
  def cannot_config_day_at_future
    if started_at.present? || finished_at.present?
      errors[:base] << "未来の日付の勤怠編集はできません" if Date.current < worked_on
    end
  end
end
