class Import < ApplicationRecord
  require 'csv'
  
  CSV.read("*.csv", headers: true).each do |row|
  user = User.create!(
    name:                       row['name'],
    email:                      row['email'],
    department:                 row['affiliation'],
    employee_number:            row['employee_number'],	
    uid:                        row['uid'],
    basic_work_time:            row['basic_work_time'],
    designated_work_start_time: row['designated_work_start_time'],
    designated_work_end_time:   row['designated_work_end_time'],
    superior:                   row['superior'],
    admin:                      row['admin'],
    password:                   row['password'],
  )
  end
end
