99.times do |n|
  name  = "user#{n+1}"
  password = "password"
  User.create!(name:  name,
    password:              password,
    password_confirmation: password
  )
end
