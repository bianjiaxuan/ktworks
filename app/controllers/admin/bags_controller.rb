# -*- coding: utf-8 -*-
class Admin::BagsController < AdminController
  inherit_resources
  respond_to :html, :json
  
  def initialize(*)
    super
    @clubs = Club.where("end_date>?",Time.zone.now.beginning_of_day).order("created_at")
  end
  
  
end
