class CreateCenters < ActiveRecord::Migration[5.1]
  def change
    create_table :centers do |t|
      t.integer :number, null: false
      t.string :name, null: false
      t.string :attendance_type, null: false

      t.timestamps
    end
  end
end
