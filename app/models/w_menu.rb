class WMenu < ActiveRecord::Base
  validates :name, :presence => true

  belongs_to :parent, :class_name => WMenu, :foreign_key => "parent_id"
  has_many :children, :class_name => WMenu, :foreign_key => "parent_id"

  enum_attr :klass, :in => [
    ['main',  0, '主菜单'],
    ['sub',  1, '子菜单']
  ]
  enum_attr :menu_type, :in => [
    ['link',  0, 'Link'],
    ['key',  1, 'Key']
  ]


end
