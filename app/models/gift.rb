# -*- coding: utf-8 -*-
class Gift < ActiveRecord::Base

  def category_desc?
    category.eql?(0)?"兑换":"KT装备"
  end
end
