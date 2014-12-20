class AddUniqueNicknameToUsers < ActiveRecord::Migration
  def change
    execute "ALTER TABLE `users` ADD UNIQUE `unique_nickname` (`nickname`)"
  end
end
