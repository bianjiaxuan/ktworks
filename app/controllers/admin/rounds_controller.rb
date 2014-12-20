# -*- coding: utf-8 -*-
class Admin::RoundsController < AdminController

  def destroy
    round = Round.find(params[:id])
    puts "--destroy-#{round.id}--#{round.pair_id}-"
    r2id=round.pair_id
    round2 = Round.find(r2id)
    delete_one_round!(round)
    delete_one_round!(round2)
    redirect_to :back
    
  end
  
  def delete_one_round!(round) 
    return if round.nil?
    unless round.result == -1  then
      round.user.scores = round.user.scores - round.score
      # 根据用户积分，重新计算等级
      round.user.grade = Level.fetch_grade(round.user.scores)
      round.user.save unless round.user.grade.blank?
    end
    round.destroy
  end

end
