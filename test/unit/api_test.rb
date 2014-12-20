# -*- coding: utf-8 -*-
require 'net/http'
require 'uri' 
require 'json'
require 'rest_client'
class TestAPI

  # {"success":true,"access_token":"qxtenUs7aB4G5qf4n5YH",
  #  "user":{"id":1201,"nickname":"testa4","email":"testa4@t.cn","phone":"","admin":false,"grade":0,"scores":0,
  #    "created_at":"2013-05-11T14:34:20+08:00","is_vip":null,"start_vip_time":null,"end_vip_time":null,
  #    "has_subscribed_sms":true,"invitor_id":null,"invitees_count":0,"users_count":0,"is_judge":false,
  #    "rank":326,"showtimes":0,"wins":0,"draws":0,"loses":0,
  #    "qrcode_img_url":"http://chart.googleapis.com/chart?chs=180x180&cht=qr&chl=1201",
  #    "birthday":null,"sex":null,"province":null,"city":null,"area":null,"age_group":"U8",
  #    "avatar":"http://qt.kicktempo.cn/assets/default_avatar.jpg",
  #    "auth_info":["weibo"]}}
  def login
    url = URI.parse('http://localhost:3000/api/users/login')
    #url = URI.parse('http://qt.kicktempo.cn/api/users/login')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'password'=>'asdfg','email'=> 'testa4@t.cn' })
      puts URI.decode(http.request(req).body)
    end
  end

  #'user[sex]'=>'GG',
  #     'user[province'=>'山东',
  #    'user[birthday]'=>'2000-09-09'
  def sign_up
    url = URI.parse('http://localhost:3000/api/users/sign_up')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'user[email]' => 'testa114@t.cn', 
          'user[nickname]' => 'testa114',
          'user[password]'=>'asdfg',
          'user[password_confirmation]'=> 'asdfg'
        })
      body = http.request(req).body
      puts body
      msgs = JSON.parse(body)
      puts msgs["messages"]["email"] unless msgs.nil? or msgs["messages"].nil?
      puts msgs["messages"]["nickname"] unless msgs.nil? or msgs["messages"].nil?
      puts msgs["messages"]["password"] unless msgs.nil? or msgs["messages"].nil?
    end
  end

  def user_info
    url= URI.parse('http://localhost:3000//api/users/user_info')
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    request["ACCESSTOKEN"] = "GqvHkEc1gwKF8Jyy5qvu" 
    puts http.request(request).body 
  end
  
  def update_profile
    url= URI.parse('http://localhost:3000/api/users/update_profile')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req["ACCESSTOKEN"] = "GqvHkEc1gwKF8Jyy5qvu"
      req.set_form_data({'profile[city]' => '北京',
          'profile[avatar]'=> '/Users/ephraim/Desktop/demoAa.png'
        })
      body = http.request(req).body
      puts body
      msgs = JSON.parse(body)
    end
  end
  
  def post_face
    url= URI.parse('http://localhost:3000/api/games/post_face')
    
  end
  
  def citys
	  #  url = URI.parse('http://localhost:3000/api/games/citys')
    url = URI.parse('http://www.kicktempo.cn/api/games/citys')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      puts http.request(req).body
      puts URI.decode(http.request(req).body)
    end
  end 

  def countrys
    url = URI.parse('http://localhost:3000/api/games/countrys')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      cities= http.request(req).body
      puts cities
      puts URI.decode(http.request(req).body)
      cities = JSON.parse(cities)
      p  URI.decode(cities[URI.escape("中国")])
    end
  end

  def create_game
    url = URI.parse('http://localhost:3000/api/games/create_game')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'game[country]' => URI.escape('中国'), 'game[city]' => URI.escape('贵阳'),'game[place]'=>URI.escape("地点一个#{Time.new}"),
          'game[date]' => "2012-12-12",'game[time_start]' => "08:00",'game[time_end]' => "18:00",'game[avatar]' => nil ,
          'game[introduction]' => URI.escape('比赛详细介绍'),'game[traffic_intro]' => URI.escape('比赛交通说明'),
          'game[arround_intro]' => URI.escape('比赛周边信息'),
          'game[user_id]'=>1 })
      puts http.request(req).body
    end
  end

  def agent_create_game
    url = URI.parse('http://localhost:3000/api/games/create_game')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'game[country]' => URI.escape('中国'),'game[city]' => URI.escape('上海'),'game[place]'=>URI.escape("地点一个#{Time.new}"),
          'game[date]' => "2014-06-12",'game[time_start]' => "08:00",'game[time_end]' => "18:00",'game[avatar]' => nil ,
          'game[introduction]' => URI.escape('比赛详细介绍'),'game[traffic_intro]' => URI.escape('比赛交通说明'),
          'game[arround_intro]' => URI.escape('比赛周边信息'),
          'game[user_id]'=>1 })
      body = http.request(req).body
     
      msgs = JSON.parse(body)
      puts msgs["messages"]["date"]
    end
  end

  def agent_create_game_timestart
    url = URI.parse('http://localhost:3000/api/games/create_game')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'game[country]' => URI.escape('中国'),'game[city]'=>URI.escape('上海'),'game[place]'=>URI.escape("城市#{Time.new}"),
          'game[time_start]' => "2014-06-12",'game[time_end]' => "2014-06-13",'game[avatar]' => nil ,
          'game[introduction]' => URI.escape('比赛详细介绍'),'game[traffic_intro]' => URI.escape('比赛交通说明'),
          'game[arround_intro]' => URI.escape('比赛周边信息'),
          'game[user_id]'=>1 })
      body = http.request(req).body
     
      msgs = JSON.parse(body)
      puts msgs
    end
  end  
  def postscore
    url = URI.parse('http://localhost:3000/api/games/post_score')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'game_id' =>'115','goals1'=>'1' ,'goals2'=>'2' ,
          'fouls1'=>'2' ,'fouls2'=>'3', 'flagrant_fouls1'=>'4' ,'flagrant_fouls2'=>'6',
          'pannas1'=>'5','pannas2'=>'5', 'panna_ko1'=>'1','panna_ko2'=>'0',
          'abstained1'=>'2','abstained2'=>'3','uid1' => '380', 'uid2' => '381',
          'uri'=>'XNTQ3MzY2MDc2','judger'=> '以法','local'=> '上海','time'=>'2013-05-09 15:30:30' })
      #puts http.request(req).body
      puts URI.decode(http.request(req).body)
      #p  URI.decode(cities[URI.escape("中国")])
    end
  end
  
  def league_postscore
    url = URI.parse('http://localhost:3000/api/games/post_score')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'game_id' =>'115','goals1'=>'1' ,'goals2'=>'2' ,
          'fouls1'=>'2' ,'fouls2'=>'3', 'flagrant_fouls1'=>'4' ,'flagrant_fouls2'=>'6',
          'pannas1'=>'5','pannas2'=>'5', 'panna_ko1'=>'1','panna_ko2'=>'0',
          'abstained1'=>'2','abstained2'=>'3','uid1' => '3', 'uid2' => '4',
          'uri'=>'XNTQ3MzY2MDc2','judger'=> '以法','local'=> '上海','time'=>'2013-05-09 15:30:30','game_type'=>'1' })
      #puts http.request(req).body
      puts URI.decode(http.request(req).body)
      #p  URI.decode(cities[URI.escape("中国")])
    end
  end

  def postvedio
    url = URI.parse('http://localhost:3000/api/game_vedios/post_vedio')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'uid1' => 157, 'uid2' => 158,'uri'=>'XNTQ3MzY2MDc2','judger'=> '以法','local'=> '上海','time'=>'2013-05-09 15:30:30','game_id'=>1,'user_id'=>5 })
      puts http.request(req).body
    end
  end
  
  def league_postvedio
    url = URI.parse('http://localhost:3000/api/game_vedios/post_vedio')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'uid1' => 3, 'uid2' => 4,
          'uri'=>'XNTQ3MzY2MDc2','judger'=> '以法',
          'local'=> '上海','time'=>'2013-05-09 15:30:30',
          'game_id'=>2,'user_id'=>5,'game_type'=>1 })
      puts http.request(req).body
    end
  end

  def fetchvedio
    url = URI.parse('http://localhost:3000/api/users/1/vedios')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      puts http.request(req).body
    end	
  end
  
  def rank
    url = URI.parse('http://localhost:3000/api/games/rank')
    #url = URI.parse('http://www.kicktempo.cn/api/games/rank')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      req.set_form_data({'search[city]'=>'上海'})
      puts http.request(req).body
    end	
  end

  def page_rank
    url = URI.parse('http://localhost:3000/api/games/page_rank')
    #url = URI.parse('http://www.kicktempo.cn/api/games/page_rank')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      #req.set_form_data({'search[city]'=>'上海','[page]'=>3})
      req.set_form_data({'[user_id]'=>4})
      puts http.request(req).body
    end	
  end
  
  
  def page_league_rank
    url = URI.parse('http://localhost:3000/api/games/page_league_rank')
    #url = URI.parse('http://www.kicktempo.cn/api/games/page_league_rank')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      #根据城市查询
      #req.set_form_data({'search[city]'=>'上海','[page]'=>1})
      #默认查询
      req.set_form_data({'[user_id]'=>'6'}) 
      puts http.request(req).body
    end	
  end
  
  def check_video
    uri = URI('http://player.youku.com/embed/XNDY0MjYyMjttgw')
    res = Net::HTTP.get_response(uri)
    puts res.body
  end


  def youku_token
    #curl http://www.kicktempo.cn/api/admin/youku_token -H "ACCESSTOKEN:GyysqAQK9rFNcVT1y6La"
    r="http://qt.kicktempo.cn/api/admin/youku_token"
    #r="http://localhost:3000/api/admin/youku_token"
    uri = URI.parse(r)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    #local
    #request["ACCESSTOKEN"] = "Nu2JcxueyfR9NLbu6zy1"
    #qt
    request["ACCESSTOKEN"] = "GyysqAQK9rFNcVT1y6La" 
      
    #request["Accept"] = "*/*"
    puts http.request(request).body 
  end
   
  def game_intro
    url = URI.parse('http://www.kicktempo.cn/api/articles/game_intro')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      body= http.request(req).body
      puts body
      body = JSON.parse(body)
      puts body["articles"]
    end 
  end
  
  def games_index
    url = URI.parse('http://localhost:3000/api/games')
    url = URI.parse('http://www.ktfootball.com/api/games')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      req.set_form_data({'search[city]'=>'上海','search[country]'=>'中国','[page]'=>2})
      body= http.request(req).body
      puts body
      body = JSON.parse(body)
      puts body["articles"]
    end 
  end

  def city_games
    url = URI.parse('http://localhost:3000/api/games/city_games')
    
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      req.set_form_data({'city'=>'上海'})
      puts URI.decode(http.request(req).body)
    end
  end 
  
  def checkin_game
    url = URI.parse('http://localhost:3000/api/users/base_info')
    #url = URI.parse('http://www.kicktempo.cn/api/users/base_info')
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Get.new(url.path)
      req.set_form_data({'user_id'=>'173'})
      body = URI.decode(http.request(req).body)
      body = JSON.parse(body)
      puts body
    end
  end
  def post_league
    url = URI.parse('http://localhost:3000/api/games/post_league')
    
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      #req.set_form_data({'user1_id'=>'3','user2_id'=>'13','user3_id'=>'111','user4_id'=>'12'})
      #req.set_form_data({'user1_id'=>'112','user2_id'=>'4'})
      req.set_form_data({'user1_id'=>'2','user2_id'=>'4'})
      req.set_form_data({'user1_id'=>'2','user2_id'=>'7'})
      puts URI.decode(http.request(req).body)
    end
  end 
  
  def bag_trace
    url = URI.parse('http://localhost:3000/api/games/bag_trace')
    
    Net::HTTP.start(url.host, url.port) do |http|
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({'user_id'=>'3','game_id'=>'13','city'=>'上海',
          'location'=>'世纪大道','code'=>'KT','longitude'=>'31.1981','latitude'=>'121.345'})
      puts URI.decode(http.request(req).body)
    end
  end
  
  def post_face
    #:game_album=> File.new('/Users/ephraim/works/kicktempo-201306/public/logo.png',:game_id=>1,:user_id=>2))
    RestClient.post('http://localhost:3000/api/games/post_face',
      {
        :game_album => {
          :game_id => '1',
          :user_id => '2',
          :face => File.new('/Users/ephraim/works/kicktempo-201306/public/logo.png', 'rb')
        }
      })
  end
  
end

t=TestAPI.new
#t.sign_up
#t.login
#t.postscore
#t.league_postscore
#t.city_games
#t.games_index
#t.post_league
#t.postvedio
#t.league_postvedio
#t.create_game
#t.agent_create_game
#t.agent_create_game_timestart
#t.checkin_game
#t.bag_trace
#t.user_info
#t.update_profile
#t.post_face
#t.rank
#t.page_rank
t.page_league_rank