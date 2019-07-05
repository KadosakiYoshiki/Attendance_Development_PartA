# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             department: "総務部",
             employee_number: "1",	
             uid: "atem",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name: "上長",
             email: "sample-0@email.com",
             department: "総務部",
             employee_number: "3",	
             uid: "seto",
             password: "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name: "上長その２",
             email: "sample-1@email.com",
             department: "開発部",
             employee_number: "4",
             uid: "ago",
             password: "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name: "部下",
             email: "sample-2@email.com",
             department: "セクシーコマンドー部",
             employee_number: "5",
             uid: "commander",
             password: "password",
             password_confirmation: "password")
=begin
60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  department = ["総務部", "人事部", "開発部", "営業部"].sample
  password = "password"
  User.create!(name: name,
               email: email,
               department: department,
               password: password,
               password_confirmation: password)
end
=end