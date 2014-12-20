collection @scores

attributes :rank, :nickname, :grade, :scores, :showtimes, :wins, :draws, :loses
node(:avatar) { |user| user_avatar_url(user) }

