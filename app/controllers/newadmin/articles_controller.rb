class Newadmin::ArticlesController < NewadminController
  inherit_resources
  def show
    redirect_to "/newadmin/articles"
  end
end
