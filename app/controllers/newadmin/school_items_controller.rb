class Newadmin::SchoolItemsController < NewadminController
  inherit_resources
  def show
    if resource.company_id.blank?
      redirect_to "/newadmin/school_items?type=0"
    else
      redirect_to "/newadmin/school_items?type=1"
    end
  end
end
