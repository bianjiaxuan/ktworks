class BatchUser < ActiveRecord::Base
  
  def self.inviter! (user)
    bu = BatchUser.find_by_email_and_status(user.email,false)
    if bu
      BatchUser.update(bu.id, status: true) 
      User.update(user.id, invitor_id: bu.agent_id) 
      agent=User.find(bu.agent_id)
      User.update(agent.id, users_count: (agent.users_count+1))
    end
  end
  
end
