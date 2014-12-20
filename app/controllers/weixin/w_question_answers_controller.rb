class Weixin::WQuestionAnswersController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_question_answers_path
  end
end
