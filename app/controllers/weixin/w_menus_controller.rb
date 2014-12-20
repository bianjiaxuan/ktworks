class Weixin::WMenusController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_menus_path
  end

  def sync
    hash = { "button" => [] }
    WMenu.where("parent_id is null").order("sort asc").each_with_index do |_menu,_index|
      if _index < 3
        _hash = {}
        _hash["name"] = _menu.name
        if _menu.menu_type == 0
          _hash["type"] = "view"
          _hash["url"] = _menu.url
        else
          _hash["type"] = "click"
          _hash["key"] = _menu.key
        end
        if _menu.children.count > 0
          _hash["sub_button"] = []
          _menu.children.each_with_index do |_sub_menu,sub_index|
            _sub_hash = {}
            if sub_index < 5
              _sub_hash["name"] = _sub_menu.name
              if _sub_menu.menu_type == 0
                _sub_hash["type"] = "view"
                _sub_hash["url"] = _sub_menu.url
              else
                _sub_hash["type"] = "click"
                _sub_hash["key"] = _sub_menu.key
              end
            end
            _hash["sub_button"].push _sub_hash
          end
        end
        hash["button"].push _hash
      end
    end
    # if hash["button"].size < 3
    #   (3 - hash["button"].size).times do
    #     hash["button"].push({})
    #   end
    # end
    w_service = WService.first
    check_access_token(w_service)
    token = w_service.access_token
    #return render :json => hash
    result = JSON.parse(RestClient.post("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{token}",hash.to_json))
    puts result
    msg = result["errmsg"].present? ? result["errmsg"] : "同步成功"
    redirect_to weixin_w_menus_path, :notice => msg
  end

end

