class Weixin::PagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "weixin"

  def index

  end

  def plan2026

  end

  def cities
    @cities = WCity.order("sort asc")
  end

  def show_city
    @city = WCity.find(params[:id])
  end

  def media
    media = WMedium.order("published_date desc")
    @media = media.where("is_title = 0")
    @top_medium = @media.where("is_title = 1").first
    if @top_medium.blank?
      @top_medium = @media.first
    end
  end

  def show_medium
    @medium = WMedium.find(params[:id])
  end

  def brands
    @brands = WBrand.order("sort asc")
  end

  def show_brand
    @brand = WBrand.find(params[:id])
  end

  def join_club

  end

  def contact

  end

  def about_kt

  end

  def cities_tmp

  end

  def brands_tmp

  end

  def train

  end
end
