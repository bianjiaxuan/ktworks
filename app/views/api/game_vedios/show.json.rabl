object @vedio

attributes :id, :uri, :judger, :local, :time
node(:user1) { |v| v.users[0].try(:nickname) }
node(:uid1) { |v| v.users[0].try(:id) }
node(:user1_avatar) { |v| user_avatar_url(v.users[0]) }
node(:user2) { |v| v.users[1].try(:nickname) }
node(:uid2) { |v| v.users[1].try(:id) }
node(:user2_avatar) { |v| user_avatar_url(v.users[1]) }
