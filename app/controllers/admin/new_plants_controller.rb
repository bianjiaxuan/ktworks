class Admin::NewPlantsController < AdminController

  def show
  end
  
  def update
    @new_plant.update_attributes(params[:new_plant])
    redirect_to admin_new_plant_path(@new_plant)
  end

end
