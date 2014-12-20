object false

node(:total_pages) { @leagues.num_pages }
node(:total_entries) { @leagues.total_count }
node(:current_page) {@leagues.current_page }
node(:first_page) { @leagues.first_page? }
node(:last_page) { @leagues.last_page? }

child @leagues do |league|
  attributes :rank, :name, :usera_id,:userb_id,:grade, :scores, :showtimes, :wins, :draws, :loses
  node(:avatar) { |league| league_avatar_url(league) }
  node(:usera_nickname) { |league| league.usera.nickname }
  node(:usera_avatar) { |league| user_avatar_url(league.usera) }
  node(:userb_nickname) { |league| league.userb.nickname }
  node(:userb_avatar) { |league| user_avatar_url(league.userb) }
end


