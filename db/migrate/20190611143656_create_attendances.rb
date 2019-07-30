class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :first_started_at
      t.datetime :first_finished_at
      t.boolean :next_day, null: false, default: false
      t.string :note
      t.integer :status_id, default: 1, null: false
      t.datetime :end_overtime
      t.string :business_content
      t.integer :superior_id_for_overtime
      t.integer :status_id_overtime, default: 1, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
