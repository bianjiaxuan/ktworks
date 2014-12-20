class AddLeagueTypeToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :league_type, :string,:default=>''

  end
end
