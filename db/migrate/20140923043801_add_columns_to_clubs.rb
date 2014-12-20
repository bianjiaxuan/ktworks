class AddColumnsToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :setup_date, :date
    add_column :clubs, :intro, :text
    add_column :clubs, :email, :string
    add_column :clubs, :contact_phone, :string
    add_column :clubs, :contact, :string
  end
end
