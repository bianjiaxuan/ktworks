class AddWeiboLinkAndTipToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :weibo_link, :string
    add_column :pictures, :weibo_tip, :string
  end
end
