class AutodataController < ApplicationController
  def index
    # Initial the rule data
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE level_rules")
    File.open("/home/sal/grade.txt", "r") do |infile|
      while (line = infile.gets)
        data = line.split(' ')
        LevelRule.create(
          :grade1 => data[0], 
          :grade2 => data[1], 
          :win_score => data[2], 
          :draw_score => data[3]
        )
      end
    end
    
    # Initial the level data
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE levels")
    Level.create(:grade => 0, :min_score => 0, :max_score => 50)
    Level.create(:grade => 1, :min_score => 50, :max_score => 250)
    Level.create(:grade => 2, :min_score => 250, :max_score => 750)
    Level.create(:grade => 3, :min_score => 750, :max_score => 1750)
    Level.create(:grade => 4, :min_score => 1750, :max_score => 4000)
    Level.create(:grade => 5, :min_score => 4000, :max_score => 7500)
    Level.create(:grade => 6, :min_score => 7500, :max_score => 1000000000)
  end
  
end
