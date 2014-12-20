class MyController < ApplicationController
  before_filter :authenticate_user!
  layout "new_application"
  caches_action :rangeclub, :expires_in => 1.days

  def index

  end

  def setting
    if request.post?
      avatar = params[:avatar]
      nickname = params[:nickname]
      phone = params[:phone]
      country = params[:country]
      birthday = params[:birthday]
      email = params[:email]

      user = current_user
      profile = current_user.profile
      
      profile.avatar = avatar if avatar.present?
      user.nickname = nickname if nickname.present?
      user.phone = phone if phone.present?
      profile.country = country if country.present?
      user.birthday = birthday if birthday.present?
      user.email = email if email.present?

      unless user.save
        return redirect_to "/my/setting", :alert => user.errors.full_messages.join(" | ")
      end
      unless profile.save
        return redirect_to "/my/setting", :alert => profile.errors.full_messages.join(" | ")
      end
    end
  end

  def info1v1
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def info2v2
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def infoclub
    if params[:league_id].present?
      @league = League.find(params[:league_id])
    else
      @league = current_user.leagues.first
    end
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def range1v1
    @scores = scores(current_user)
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

  def range2v2
    if params[:league_id].present?
      @league = League.find(params[:league_id])
    else
      @league = current_user.leagues.first
    end
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    
    @league_scores=league_scores?
  end

  def rangeclub
    _clubs = current_user.clubs
    if _clubs.count > 0
      @club = _clubs.first
    end
    if params[:sort] = "member"
      @clubs = Club.all.sort{|a,b|b.bags.map(&:binding_users).flatten.uniq.count <=> a.bags.map(&:binding_users).flatten.uniq.count}
    else
      @clubs = Club.all
    end
  end

  def infomyclub
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end


end
