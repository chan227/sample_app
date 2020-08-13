20.times do |n|
  name = Faker::Name.name
  email = "user_1#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end
