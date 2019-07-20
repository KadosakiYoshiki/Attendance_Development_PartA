class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|
      t.integer :user_id
      t.date :month
      t.integer :superior_id
      t.integer :status_id, default: 2, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
