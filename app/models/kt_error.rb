class KtError < ActiveRecord::Base

  enum_attr :klass, :in => [
    ['web',  0, '网站'],
    ['app',  1, 'APP'],
    ['admin',  2, '后台'],
    ['weixin',  3, '微信'],
    ['weixin_user',  4, '微信会员卡'],
    ['weixin_admin',  5, '微信后台']
  ]
end
