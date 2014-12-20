class AddSchoolTypeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies,:company_type,:string,:default => ""
  end
end
