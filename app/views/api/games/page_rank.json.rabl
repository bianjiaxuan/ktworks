object false

node(:total_pages) { @users.num_pages }
node(:total_entries) { @users.total_count }
node(:current_page) {@users.current_page }
node(:first_page) { @users.first_page? }
node(:last_page) { @users.last_page? }

child @users do |user|
  attributes :rank, :nickname, :grade, :scores, :showtimes, :wins, :draws, :loses
  node(:avatar) { |user| user_avatar_url(user) }
end


