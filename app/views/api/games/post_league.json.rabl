object false


collection @league
attributes :id, :name, :grade,:league_type, :scores, :usera_id, :userb_id
node(:avatar) { |g| league_avatar_url(g) }
child  @users do |user|
  attributes :id
  node(:avatar) { |u| user_avatar_url(u) }
end
