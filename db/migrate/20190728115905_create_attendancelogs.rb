class CreateAttendancelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :attendancelogs do |t|
      t.date :attendance_date
      t.datetime :first_started_at
      t.datetime :first_finished_at
      t.datetime :latest_started_at
      t.datetime :latest_finished_at
      t.integer :superior_id
      t.date :approvaled_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
