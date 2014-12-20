class Weixin::WUsersController < AdminController
  inherit_resources
  def unbind
  	wuser = WUser.find(params[:id])
  	if wuser.user_id
  		wuser.user_id=nil
  	end
  	wuser.save
  	redirect_to :back
  end
end
