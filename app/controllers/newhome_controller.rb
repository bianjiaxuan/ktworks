class NewhomeController < ApplicationController
  layout "new_application"
  def index

  end

  def about_kt

  end

  def range1v1

  end

  def range2v2

  end

  def rangeclub

  end

  def club

  end

  def playkt
    if params[:club].present?
      club = Club.where(:name => params[:club]).first
      @games = Game.where(:club_id => club.id)
    elsif params[:city].present?
      @games = Game.where(:city => params[:city])
    elsif params[:country].present?
      cities = Country.where(:kind=>"city",:parent => params[:country]).map(&:name)
      @games = Game.where("city in (?)", cities)
    else
      @games = Game.all
    end
    @games = @games.where("time_end > ?",Time.now)
  end

  def playkt_event

  end

  def profile

  end

  def qa

  end

  def setting

  end

  def team_profile

  end

  def register

  end

  def login

  end

  def coop

  end

  def about

  end

  def plan2026

  end

  def agreement

  end

  def contact
    if request.post?
      contact = Contact.new params[:contact]
      if contact.save
        flash[:notice] = "您的问题已经提交,我们会尽快联系您"
      else
        flash[:alert] = contact.errors.full_messages.join(" , ")
      end
      return render :contact
    end
  end

  def search
    keyword = params[:keyword]
    @clubs = Club.where("name LIKE ?","%#{keyword}%").limit(10)
    @users = User.where("nickname LIKE ?","%#{keyword}%").limit(10)
    render :json => {:content => render_to_string(:partial => "newhome/search_result")}
  end
end
