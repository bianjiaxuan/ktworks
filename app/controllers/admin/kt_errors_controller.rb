class Admin::KtErrorsController < AdminController
  inherit_resources

  def index
    index! {
      if params[:is_solve].present?
        @collection = collection.where("is_solved = ?",params[:is_solve].to_i)
      elsif params[:klass].present?
        @collection = collection.where("klass = ?",params[:klass].to_i)
      else
        @collection = collection
      end
    }
  end

  def solve
    resource.update_attributes is_solved: true

    redirect_to admin_kt_errors_path :notice => "操作成功"
  end
end
