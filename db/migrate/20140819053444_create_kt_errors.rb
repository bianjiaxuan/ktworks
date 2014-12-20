class CreateKtErrors < ActiveRecord::Migration
  def change
    create_table :kt_errors do |t|
      t.string :name
      t.string :url
      t.integer :klass   # 0 网站 1 APP 2 后台 3 微信 4 微信会员卡 5 微信后台
      t.text :message
      t.text :backtrace
      t.boolean :is_solved , default: false
      t.timestamps
    end
  end
end
