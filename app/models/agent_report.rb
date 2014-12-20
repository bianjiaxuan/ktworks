class AgentReport < ActiveRecord::Base
  
  belongs_to :user, class_name: "User", foreign_key: "agent_id"
  def self.agent_count
    as=User.find_by_sql("select city,id,agent from users where agent=1 order by city")
    as.each do |u|
      AgentReport.create(:agent_id=>u.id,:city=>u.city,:invitees_count=>u.get_inviter.invitees_count,:reg_count=>u.get_inviter.lives_count,:day=>Time.now.strftime("%Y-%m-%d"))
    end
  end
  
end
