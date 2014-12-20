class Newadmin::StudentsController < NewadminController
  inherit_resources
  def show
    redirect_to action: "index"
  end
end
