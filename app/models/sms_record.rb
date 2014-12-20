class SmsRecord < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user

  # --- 校验方法
  validates :user, :presence => true

  validates :content, 
    :presence => true,
    :length => 1..65
end
