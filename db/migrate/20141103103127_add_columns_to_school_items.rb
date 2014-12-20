class AddColumnsToSchoolItems < ActiveRecord::Migration
  def change
    add_column :school_items, :company_id, :integer
    add_column :school_items, :phone, :string
    add_column :school_items, :address, :string
    add_column :school_items, :student_count, :integer, :default => 0
    add_column :school_items, :school_address, :string
    add_column :school_items, :contact, :string
    add_column :school_items, :contact_position, :string
    add_column :school_items, :contact_phone, :string
    add_column :school_items, :donate_require, :text
    add_column :school_items, :remark, :text
    add_column :school_items, :area, :string
    add_index :school_items, :company_id
  end
end