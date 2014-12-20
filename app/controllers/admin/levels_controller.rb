# -*- coding: utf-8 -*-
class Admin::LevelsController < AdminController

  def index
    @levels = Level.all
  end
  
  def rules
    @rules = LevelRule.all
  end

end
