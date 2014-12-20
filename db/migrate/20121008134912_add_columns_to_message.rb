class AddColumnsToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :company, :string
    add_column :messages, :phone, :string
    add_column :messages, :address, :string
    add_column :messages, :donate_count, :string
    add_column :messages, :donate_school, :string
    add_column :messages, :donate_comment, :string
    add_column :messages, :contect_time, :string
  end
end
