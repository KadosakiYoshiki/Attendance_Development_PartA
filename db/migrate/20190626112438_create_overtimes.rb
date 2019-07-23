class CreateOvertimes < ActiveRecord::Migration[5.1]
  def change
    create_table :overtimes do |t|
      t.integer :user_id
      t.date :applied_on
      t.time :end_overtime
      t.string :business_content 
      t.integer :superior_id
      t.string :permit_note
      t.integer :status_id, default: 1, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
