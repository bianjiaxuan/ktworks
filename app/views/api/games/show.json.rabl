object @game

attributes :id, :country, :city, :place, :date, :time_start, :time_end, :checked_in, :opened, :introduction, :traffic_intro, :arround_intro
node(:time_start) { |g| hm(g.time_start) }
node(:time_end) { |g| hm(g.time_end) }
node(:place_img) { |g| resource_url_for(g.avatar.to_s) if g.avatar_file_name.present? }
node(:place_middle_img) { |g| resource_url_for(g.avatar(:middle).to_s) if g.avatar_file_name.present? }
node(:place_thumb_img) { |g| resource_url_for(g.avatar(:thumb).to_s) if g.avatar_file_name.present? }
