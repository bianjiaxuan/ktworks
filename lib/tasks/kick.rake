# -*- encoding : utf-8 -*-
namespace :kick do
  desc '查找用户第一次参赛的气场并绑定到用户'
  task :binding_code_to_user => :environment do

    BagTrace.find_each do |trace|
      code = trace.code
      game = trace.game
      if game
        rounds = game.rounds.order("created_at asc")
        if rounds.count > 0
          rounds.each do |round|
            user = round.user
            if user
              if user.binding_code.present?
                p "#{user.id}已经绑定过了"
              else
                user.binding_code = code
                user.save(:validate => false)
                p "#{user.id}绑定成功"
              end
            else
              p "#{trace.code} 气场没有用户"
            end
          end
        else
          p "#{trace.code} 气场没有比赛"
        end
      else
        p "#{trace.code} 气场没有赛事"
      end
    end
  end
end