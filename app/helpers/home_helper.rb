# -*- coding: utf-8 -*-
module HomeHelper

  def achievements?
    "累计胜场："+Round.where(:user_id=>"#{current_user.id}",:result => 1).count.to_s <<
       " 平场：" <<
       Round.where(:user_id=>"#{current_user.id}",:result=> 0).count.to_s <<
       " 负场：" <<
       Round.where(:user_id=>"#{current_user.id}",:result=> -1).count.to_s
  end

  def invitees_count?(inviter)
    inviter.present? ? inviter.invitees_count : "0"
  end

  def lives_count?(inviter)
    inviter.present? ? inviter.lives_count : "0"
  end
end
