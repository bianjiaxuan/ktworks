class BagsController < ApplicationController
  
  def search
    code = params['code']
    @bags = Bag.where("code = '#{code}'").order('code DESC').limit(10)
    respond_to do |format|
      format.js
    end
  end

end
