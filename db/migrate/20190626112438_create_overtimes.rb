class CreateOvertimes < ActiveRecord::Migration[5.1]
  def change
    create_table :overtimes do |t|
      t.integer :user_id
      t.date :applied_on
      t.datetime :end_overtime
      t.string :business_content 
      t.integer :superior_id
      t.string :permit_note
      t.boolean :permit
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
