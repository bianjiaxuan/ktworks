class Newadmin::CoachesController < NewadminController
  inherit_resources
  def show
    redirect_to action: "index"
  end
end
