object false

node(:total_pages) { @games.num_pages }
node(:total_entries) { @games.total_count }
node(:current_page) { @games.current_page }
node(:first_page) { @games.first_page? }
node(:last_page) { @games.last_page? }

child @games do |game|
  attributes :id, :country, :city, :place, :date, :time_start, :time_end, :checked_in, :opened,:user_id
  node(:place_img) { |g| resource_url_for(g.avatar.to_s) if g.avatar_file_name.present? }
  node(:place_middle_img) { |g| resource_url_for(g.avatar(:middle).to_s) if g.avatar_file_name.present? }
  node(:place_thumb_img) { |g| resource_url_for(g.avatar(:thumb).to_s) if g.avatar_file_name.present? }
  node(:user_avatar) { |g| user_avatar_url(g.user) unless g.user.nil?  }
end
