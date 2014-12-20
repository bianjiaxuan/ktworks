# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

1.upto(8) do |i|
  InfoUrl.create!({usage: "index_slide", url: "index_slide_#{i.to_s}.jpg", description: "KickTemp Slide #{i.to_s}"})
end
1.upto(3) do |i|
  InfoUrl.create!({usage: "index_show", url: "index_show_#{i.to_s}.jpg", description: "Show#{i.to_s}"})
  InfoUrl.create!({usage: "game_image", url: "game_image_#{i.to_s}.jpg", description: "Show#{i.to_s}"})
  InfoUrl.create!({usage: "game_intro", url: "game_intro_#{i.to_s}.jpg", description: "Show#{i.to_s}"})
  InfoUrl.create!({usage: "game_exp", title: "Player#{i}", description: "Exp#{i}"})
end
InfoUrl.create!({usage: "game_video", url: "http://player.youku.com/player.php/sid/XMzgxMDQ4NzI4/v.swf"})
InfoUrl.create!({usage: 'game_announce', description: 'Announces'})
puts "Initialized InfoUrl."

User.create!({email: 'admin@tempot.com', nickname: 'kicktempo', password: 'kicktempo@2012', password_confirmation: 'kicktempo@2012', admin: true, confirmed_at: Time.now}, without_protection: true)
puts "Admin@kicktempo.cn created."

NewPlant.create!(support_counter: 0, indentify: "kicktempo_2026_info")
