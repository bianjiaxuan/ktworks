class AddPriorityAndStatusToInfoUrl < ActiveRecord::Migration
  def change
    add_column :info_urls, :priority, :integer,:default=>0

    add_column :info_urls, :status, :boolean,:default=>true

  end
end
