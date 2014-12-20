class Weixin::WQuestionsController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_questions_path
  end
end
