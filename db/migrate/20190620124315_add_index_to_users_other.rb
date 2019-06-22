class AddIndexToUsersOther < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number,            :integer
    add_column :users, :uid,                        :string, unique: true
    add_column :users, :designated_work_start_time, :time
    add_column :users, :designated_work_end_time,   :time
  end
end
