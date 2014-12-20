object false

node(:total_pages) { @vedios.num_pages }
node(:total_entries) { @vedios.total_count }
node(:current_page) { @vedios.current_page }
node(:first_page) { @vedios.first_page? }
node(:last_page) { @vedios.last_page? }

child @vedios do |vedio|
  attributes :id, :uri, :judger, :local, :time
  node(:user1) { |v| v.users[0].try(:nickname) }
  node(:uid1) { |v| v.users[0].try(:id) }
  node(:user1_avatar) { |v| user_avatar_url(v.users[0]) }
  node(:user2) { |v| v.users[1].try(:nickname) }
  node(:uid2) { |v| v.users[1].try(:id) }
  node(:user2_avatar) { |v| user_avatar_url(v.users[1]) }
end
