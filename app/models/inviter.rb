# -*- coding: utf-8 -*-
class Inviter < ActiveRecord::Base
  #定时统计
  def self.static_lives
    #us=User.find_by_sql("select * from users where id in (select distinct invitor_id 
    # from users where invitor_id is not null)")
    @clubs = Club.where("end_date>?",Time.zone.now.beginning_of_day).order("created_at")
    rank_string=""
    # rank_string = " ('a@ao.in','a'), ('b@ao.in','b')"
    #User.connection.insert("INSERT INTO users (email, name) VALUES"+user_string) 
    @clubs.each do |cu|
      users_count,lives_count= self.oneclub_count(cu.id)
      rank_string << ",(#{cu.user_id},#{users_count},#{lives_count},now(),now())"
    end  
    rank_string.slice!(0,1)
    Inviter.destroy_all
    Inviter.connection.insert("INSERT INTO inviters
          (user_id,invitees_count,lives_count,updated_at,created_at) VALUES"+rank_string)
  end
  
  private
  def self.oneclub_count(club_id)
    users_count=lives_count=0
    @judges = User.where("is_judge=1 and judgeclub_id=#{club_id}")
    @judges.each do |ju|
      users_count += User.where("invitor_id=#{ju.id}").count
      lives_count += User.where("invitor_id=#{ju.id} and exists(select r.user_id from rounds r where r.user_id=users.id )").count
    end
    return users_count,lives_count
  end
  
end
