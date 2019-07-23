class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.time :started_at
      t.time :finished_at
      t.boolean :next_day, null: false, default: false
      t.string :note
      t.integer :status_id, default: 1, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
