# -*- coding: utf-8 -*-
class GameRecord < ActiveRecord::Base

  belongs_to :user
  belongs_to :league ,foreign_key:"user_id"
  belongs_to :game_vedio
  
end
