class AddEndDateToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :end_date, :date

  end
end
