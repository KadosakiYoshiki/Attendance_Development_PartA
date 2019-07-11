class CreateStamps < ActiveRecord::Migration[5.1]
  def change
    create_table :stamps do |t|
      t.integer :attendance_id
      t.integer :superior_id
      t.integer :status_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
