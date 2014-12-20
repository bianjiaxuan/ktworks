# -*- coding: utf-8 -*-
class SchoolItem < ActiveRecord::Base
  belongs_to :school_local
  belongs_to :company

  Provines = "北京|bj,安徽|ah,重庆|cq,福建|fj,甘肃|gs,广东|gd,广西自治区|gx," +
             "贵州|gz,海南|hn,河北|hb,黑龙江|hlj,河南|hen,湖北|hub,湖南|hun,江西|jx,江苏|js,吉林|jl," +
             "辽宁|ln,内蒙古自治区|nmg,宁夏自治区|nx,青海|qh,山东|sd,上海|sh,山西|sx,陕西|shx," +
             "四川|sc,天津|tj,新疆自治区|xj,西藏自治区|xz,云南|yn,浙江|zj,澳门特别行政区|am," +
             "香港特别行政区|xg,台湾|tw"
  
  def self.provinces_hash
    hash = {}
    Provines.split(',').collect do |p|
      ap = p.split('|')
      hash[ap.last.to_s] = ap.first 
    end
    hash
  end

  def self.provinces
    group('province').collect(&:province)
  end

  def province_name
    SchoolItem.provinces_hash[province]
  end
end
