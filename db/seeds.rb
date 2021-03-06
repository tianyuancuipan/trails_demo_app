# Users
User.create!(name: "Anny Cui",
            email: "anny.cui@hotmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Baozi Bao",
            email: "tianyuancuipan@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Pikachu Charismatic",
            email: "annycuisz@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Happy Cat",
            email: "tianyuan.cui.sc@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Totoro Cute",
            email: "anny.cui@outlook.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Eating Cat",
            email: "annycuipan@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Flying Cat",
            email: "baoziannypan@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "Lazy Cat",
            email: "baoziannycuipan@gmail.com",
            password: "password",
            password_confirmation: "password",
            activated: true,
            activated_at: Time.zone.now)

50.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@example.com"
password = "password"
User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(10)
20.times do
  content = Faker::Lorem.sentence(2)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
following = users[8..50]
followers = users[8..40]
user_group = users[0..7]
user_group.each do |user|
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }
end

# Comments
microposts = Micropost.order(:created_at).take(50)
users = User.order(:created_at).take(5)
microposts.each do |micropost|
  users.each do |user|
    content = Faker::Lorem.sentence(2)
    micropost.comments.create!(content: content, user_id: user.id)
  end
end

# Likes
users = User.order(:created_at).take(8)
microposts = Micropost.order(:created_at).take(20)
comments = Comment.order(:created_at).take(20)
microposts.each do |micropost|
  users.each do |user|
    micropost.likes.create!(user_id: user.id)
  end
end
comments.each do |comment|
  users.each do |user|
    comment.likes.create!(user_id: user.id)
  end
end
