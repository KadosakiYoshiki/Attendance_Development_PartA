class AddApplyingNextDayOvertime < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day_for_overtime, :boolean, null: false, default: false
  end
end
