class BagTrace < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  def self.post_trace(params)
    bag = Bag.find_by_code (params[:code])
    return { :success => false, :message => "invalid post"} unless bag.present?
    bag_trace = BagTrace.new(
      :code =>params[:code],
      :city=>params[:city],
      :location => params[:location],
      :user_id =>params[:user_id],
      :game_id =>params[:game_id],
      :longitude  => params[:longitude],
      :latitude   => params[:latitude]
    )
    if bag_trace.save
      return { :success => true, :notice => "trace ok" }
    else
      return { :success => false, :message => bag_trace.errors.messages }
    end
  end

end
