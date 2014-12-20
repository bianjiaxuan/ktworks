class ChangeGameRecordColumn < ActiveRecord::Migration
  def up
    execute "alter table game_records drop created_at;"
    execute "alter table game_records drop updated_at;"
  end

  def down
    execute "alter table game_records add created_at datetime not null ;"
    execute "alter table game_records add updated_at datetime not null ;"
  end
end
