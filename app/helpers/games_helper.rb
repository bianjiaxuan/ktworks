module GamesHelper
  def gameUrl game
    url= "/activities/#{ymd(game.date)}/#{game.url}/"
    title= "#{truncate(strip_tags(game.introduction), :length => 60, :omission => '...')}"
    body= "#{game.city}-#{game.place}-#{game.date}"
    body+= " Coming Soon..." if game.date > Date.today
    url= "<a href=\"#{url}\" target=\"_blank\" title=\"#{title}\">#{body}</a>"
  end

  def recommend_gameUrl? gv_id
    game = GameVedio.find(gv_id).game
    url= "/activities/#{ymd(game.date)}/#{game.url}/"
    title= "更多-#{game.date}－#{game.city}-#{game.place}活动..."
    url= "<a href=\"#{url}\" target=\"_blank\" title=\"#{title}\">#{title}</a>"
  end

  def check_score?(game_vedio_id)
    flag = false
    gv = GameVedio.find_by_sql("select count(*) as count from game_vedios v where v.id in
        (select game_vedio_id from game_records where game_vedio_id=#{game_vedio_id} and
        user_id=#{current_user.id} and score=0) and v.created_at > date_sub(now(),interval 7 day)").first
    flag = (gv.count > 0)
    flag
  end

  def goals_panna_kt?
      goals = Round.where("user_id = ?",current_user.id).map(&:goals).sum
      kt = Round.where("user_id =#{current_user.id} and panna_ko = true").count
      pannas = Round.where("user_id=#{current_user.id} ").map(&:pannas).sum
      "个人累计进球数：#{goals} 个人累计KT数：#{kt} 个人累计穿裆: #{pannas}"
  end

end
