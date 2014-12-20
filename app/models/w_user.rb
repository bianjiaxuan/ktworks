class WUser < ActiveRecord::Base
  belongs_to :user
  has_many :answers, :class_name => WQuestionAnswer, :foreign_key => "w_user_id", dependent: :destroy
end
