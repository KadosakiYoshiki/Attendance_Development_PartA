# coding: utf-8

User.create!(name: "管理者",
             email: "admin@email.com",
             department: "総務部",
             employee_number: "0",	
             uid: "admin",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name: "上長",
             email: "superior@email.com",
             department: "総務部",
             employee_number: "1",	
             uid: "123456",
             password: "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name: "上長その２",
             email: "superior2@email.com",
             department: "開発部",
             employee_number: "2",
             uid: "abc",
             password: "password",
             password_confirmation: "password",
             superior: true)
             
User.create!(name: "上長その３",
             email: "superior3@email.com",
             department: "開発部",
             employee_number: "3",
             uid: "876573",
             password: "password",
             password_confirmation: "password",
             superior: true)
             
3.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  department = ["総務部", "人事部", "開発部", "営業部", "フリーランス部"].sample
  employee_number = rand(10..100)
  uid = (0...8).map{ (65 + rand(26)).chr }.join
  password = "password"
  User.create!(name: name,
               email: email,
               department: department,
               employee_number: employee_number,
               uid: uid,
               password: password,
               password_confirmation: password)
end