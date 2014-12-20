class Round < ActiveRecord::Base
  require 'sms'
  include Sms

  belongs_to :user 
  belongs_to :league, :class_name => "League", :foreign_key => "user_id"  
  belongs_to :game
  # 绑定到气场
  belongs_to :code
  has_one :pair, class_name: "Round", foreign_key: "pair_id"

  def self.find_by_game_and_number game_id, number
    find(:first, conditions: {game_id: game_id, game_number: number})
  end

  def self.create_by_game_and_user_id game_id, user_id
    Round.create!(game_id: game_id, user_id: user_id, varified: true)
  end

end
