class Newadmin::CompaniesController < NewadminController
  inherit_resources
  def show
    redirect_to "/newadmin/companies?type=0"
  end
end
