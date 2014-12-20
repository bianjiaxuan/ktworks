Kicktempo::Application.routes.draw do
  captcha_route
  mount Ckeditor::Engine => '/ckeditor'
  
  mount ChinaCity::Engine => '/china_city'

  match 'newhome/:action' => 'newhome', via: [:get,:post]
  match 'my/:action' => 'my', via: [:get,:post]

  resources :game_albums do
    collection do
      get 'face'
      get 'show/:user_id' => 'game_albums#show'
      put 'upload_face'
    end
  end
  resources :leagues do

    collection do
      post :search_friends
      post :invite
      get  :invite_check
      get  :check_name
      post :update_league
      get  'ignore/:id'=> 'leagues#ignore',as: :ignore
      get  'accept/:id'=> 'leagues#accept',as: :accept
      post :accept
    end
  end
  get  'my_leagues'=>'leagues#my_leagues', as: :my_leagues
  #get 'game_albums/face'

  get "autodata/index"

  get  '/games' => 'games#index'
  get  '/games/list' => 'games#list'
  post '/games/registration' => 'games#registration'
  get  '/games/terms' => 'games#game_terms', as: :game_terms
  get  '/games/rank' => 'games#rank'
  get  '/games/scores_list'=> 'games#scores_list'
  get  '/games/league_scores_list'=> 'games#league_scores_list'
  get  '/games/next_vedio' => 'games#slide'
  get  '/games/one_next_vedio' => 'games#one_slide'
  get  '/games/check_score'
  put  '/games/score'
  get  '/bags/search' => 'bags#search'

  get  '/games/show' => 'games#show'
  post  '/games/join' => 'games#join'
  post  '/games/invite' => 'games#invite'


  match '/activities/:year/:month/:day/:url/' => 'games#scene', :constraints => { :url => /.+/ }, via: [:get,:post]

  get  '/new_plant' => 'new_plant#index'
  get  '/about_us' => 'new_plant#about_us'
  get  '/support_our_plant' => 'new_plant#support_our_plant'
  get  '/kicktempo_story' => 'new_plant#kicktempo_story'
  get  '/school_list' => 'new_plant#school_list'
  get  '/donate' => 'new_plant#donate'
  get  '/donated_citys' => 'new_plant#donated_citys'
  get  '/donated_schools' => 'new_plant#donated_schools'
  get  '/plant_news' => 'new_plant#plant_news'
  get  'support_kicktempo' => 'new_plant#support_kicktempo'
  get  'gas_intro' => 'new_plant#gas_intro'
  get  'company' => 'new_plant#company'
  post 'send_message' => 'new_plant#send_message'
  post 'send_donate_message' => 'new_plant#create_donate_message'

  get  '/confirm_phone' => 'users#confirm_phone', as: :confirm_phone
  get  '/invite' => 'users#invite', as: :invite
  get  '/connect_auths' => 'users#connect_auths', as: :connect_auths
  get  '/subscribe_sms' => 'users#subscribe_sms', as: :subscribe_sms
  get  '/myorders' => 'users#myorders', as: :myorders
  get  '/myclubbers/:type/:manager' => 'users#myclubbers', as: :myclubbers
  post '/varify_phone' => 'users#varify_phone', as: :varify_phone
  post '/varify_subscribe_sms' => 'users#varify_subscribe_sms', as: :varify_subscribe_sms
  get  '/send_varification_code' => 'users#send_code', as: :send_code
  post '/varify_code' => 'users#varify_code', as: :varify_code
  get  '/my_space' => 'users#myspace', as: :myspace
  get  '/user/:user_id' => 'users#home', as: :user_home
  get  '/shows/my' => 'game_vedios#my_shows', as: :my_shows
  get  '/shows/:id' => 'game_vedios#show'
  get  '/my_scores' => 'users#my_scores'
  #get  '/user/:user_id/game_vedios' => 'game_vedios#index', as: :user_game_vedios

  match '/users/auth/Youku/callback(.:format)' => 'admin/admission#set_youku', via: [:get,:post]

  devise_for :users, controllers: {
    sessions:           :sessions,
    omniauth_callbacks: :authentications,
    registrations: :registrations
  }

  devise_scope :user do
    #get '/sign_up' => "registrations#new", as: :sign_up
    get '/sign_in' => "devise/sessions#new", as: :sign_in
    get '/sign_out' => "devise/sessions#destroy", as: :sign_out
    post  '/sign_up'  => 'registrations#create'
    post '/get_authcode' => 'registrations#get_authcode'
    put '/authuser_update' => 'registrations#authuser_update', as: :authuser_update
  end

  # weixin
  get '/wx_callback' => "weixin/weixin_api#callback_get"
  post '/wx_callback' => "weixin/weixin_api#callback_post"
  get '/weixin/train' => "weixin/pages#train"

  resources :clubs

  namespace :api do
    resources :users, only: [] do
      get 'vedios', on: :member
      collection do
        get 'user_info'
        post 'login'
        post 'sign_up'
        get 'base_info'
        post 'update_profile'
        post 'auth_connect'
        post 'share'
        get 'auth_info'
        get 'auth_redirect_uri'
        post 'oauth_login'
        post 'oauth_signup'
      end
    end

    resources :games, only: [:index, :show] do
      collection do
        post 'post_score'
        get 'citys'
        get 'countrys'
        get 'country_cities'
        get 'rank'
        get 'page_rank'
        get 'page_league_rank'
        post 'create_game'
        post 'post_league'
        get 'city_games'
        post 'bag_trace'
        post 'post_face'
      end
    end

    resources :admin, only: [] do
      get 'youku_token', on: :collection
      get 'refresh_youkutoken', on: :collection
    end

    resources :articles, only: [:index, :show] do
      get 'game_intro', on: :collection
      get 'game_terms', on: :collection
    end

    resources :game_vedios, only: [:index, :show] do
      post 'post_vedio', on: :collection
    end
  end

  namespace :weixin do
    get 'w_services/get_gz_reply_content' => 'w_services#get_gz_reply_content'
    get 'w_services/get_auto_reply_content' => 'w_services#get_auto_reply_content'

    resources :w_services do
      member do
        get 'first_gz'
        get 'auto_reply'
      end
    end

    match 'w_replies/get_reply_content' => 'w_replies#get_reply_content', via: [:get]
    resources :w_replies

    resources :w_users do
      get 'unbind', on: :member
    end
    resources :materials do
      get 'preview', on: :member
    end
    resources :multiple_materials do
      get 'edit_list', on: :member
      post 'update_list', on: :member
      get 'preview', on: :member
    end
    resources :multiple_material_lists do
      get 'preview', on: :member
    end
    resources :audio_materials
    resources :w_questions
    resources :w_question_answers

    resources :w_menus do
      get 'sync', on: :collection
    end
    resources :w_cities
    resources :w_media
    resources :w_brands

    match 'users/:action' => 'users', via: [:get,:post]
    match 'pages/:action' => 'pages', via: [:get,:post]

  end
  get '/weixin/w_users/:id/unbind' => 'weixin/w_users#unbind'
  get '/time' => 'home#time'
  
  namespace :newadmin do
    resources :games do
      get 'view_applications', on: :member
    end
    resources :kt_errors do
      get 'solve', on: :member
    end
    resources :online_courses
    resources :students
    resources :coaches

    resources :donate_messages
    resources :school_items
    resources :companies
    resources :albums do
      get 'upload', on: :member
      post 'upload', on: :member
    end
    resources :articles
  end

  namespace :admin do
    get  '/index' => 'home#index'
    resources :games
    resources :gifts
    resources :orders
    resources :rounds
    resources :messages
    resources :donate_messages
    resources :companies
    resources :school_locals
    resources :school_items
    resources :countries
    resources :clubs
    resources :bags
    resources "bag_traces"
    resources :albums do
      resources :pictures, only: [] do
        get 'multi_edit', as: :multi_edit, on: :collection
        post 'multi_update', as: :multi_update, on: :collection
      end
    end
    resources :pictures do
      collection do
        get 'uploads', as: :uploads
      end
    end

    post '/games/open'
    post '/games/close'
    post '/games/start'
    post '/games/finish'

    get  '/users' => 'users#index'
    get  '/users/search' => 'users#search'
    get  '/users/profile' => 'users#profile'
    get  '/users/subscribed_sms'  => 'users#subscribed_sms'
    get  '/users/unsubscribed_sms'  => 'users#unsubscribed_sms'
    post  '/users/cancel_subscribed_sms'  => 'users#cancel_subscribed_sms'
    post  '/users/confirm_subscribed_sms'  => 'users#confirm_subscribed_sms'
    get  '/users/agent_list' => 'users#agent_list'
    get  '/users/judge_list' => 'users#judge_list'

    post  '/users/check_sms'  => 'users#check_sms'
    post  '/users/uncheck_sms'  => 'users#uncheck_sms'
    post  '/users/selected_sms'  => 'users#selected_sms'
    post  '/users/cancel_selected_sms'  => 'users#cancel_selected_sms'


    post '/users/admin' => 'users#admin'
    get '/users/setjudge' => 'users#setjudge'
    put '/users/judge' => 'users#judge'
    get '/users/setagent' => 'users#setagent'
    put '/users/agent' => 'users#agent'
    get  '/users/new' => 'users#new'
    get  '/users/tally' => 'users#tally'
    get  '/users/day_top_scores' => 'users#day_top_scores'
    get  '/users/day_rounds' => 'users#day_rounds'
    get  '/users/day_goals' => 'users#day_goals'
    get  '/users/day_games' => 'users#day_games'
    post '/users' => 'users#create'
    post '/users/registration' => 'users#registration'
    post '/users/admission' => 'users#admission'
    post '/users/phone' => 'users#phone'
    post '/users/area' => 'users#area'
    post '/users/destroy' => 'users#destroy'
    post '/users/batch_signup' => 'users#batch_signup'
    get '/users/batch_index' => 'users#batch_index'
    get '/users/setvip' => 'users#setvip'
    put '/users/updatevip' => 'users#updatevip'
    get '/users/cancelvip' => 'users#cancelvip'

    get  '/admission' => 'admission#index'
    post '/admission/admit' => 'admission#admit'
    get  '/admission/entered' => 'admission#entered'

    get  '/scores' => 'scores#index'
    post '/scores/submit' => 'scores#submit'
    get  '/scores/list' => 'scores#list'

    get '/levels' => 'levels#index'
    get '/levels/rules' => 'levels#rules'


    get '/articles/:id/set_visit' => 'articles#set_visit'

    resources :articles
    resources :new_plants

    resources :info_urls

    get  '/sms/new' => 'sms#new'
    post '/sms/clear_selected' => 'sms#clear_selected'

    resources :sms
    resources :kt_errors do
      get 'solve', on: :member
    end
    resources :contacts
    resources :contact_replies
  end

  namespace :ckeditor do
    resources :pictures
  end

  resources :articles do
    get 'detail', on: :member
  end
  resources :albums, only: [:index, :show]
  resources :pictures, only: [:show] do
    collection do
      post 'save_uploads', as: :save_uploads
    end
  end


  get  'profile/change' => 'profile#change'
  get  'checkemail/:id' => 'profile#checkemail'
  get  'profile/avatar' => 'profile#avatar'
  put  'profile/upload_avatar' => 'profile#upload_avatar'
  put  'profile' => 'profile#update'
  resources :profile



  # resources :rounds
  get 'orders/:id/show' => 'orders#show'
  resources :orders do
    collection do
      post 'exchange'
    end
  end
  get '/terms' => 'home#terms', as: :terms
  get '/business', to: 'home#business'
  get '/about_kicktempo', to: 'home#kt'
  get '/navAsyn', to: 'home#navAsyn'
  get '/plan2026',to: 'home#plan_2026'
  get '/agent_scopes' => 'home#agent_scopes'
  get '/agent_reports/:city' => 'home#agent_reports'
  get '/football_games',to: 'home#game'
  get '/exchange' => 'home#exchange'
  get '/buy' => 'home#buy'

  get '/score_ranks',to: 'home#rank'
  get '/rank1', to: 'home#rank1'
  get '/rank2', to: 'home#rank2'
  get '/judge_ranks',to: 'home#judge_ranks'
  get '/check_identity', to: 'orders#check_identity'
  get '/check_scores/:id', to: 'orders#check_scores'
  get "/address/:id", to: 'orders#address'
  get '/cooperation',to: 'home#cooperate'
  get '/agency_service',to: 'home#agency'
  get '/join_us',to: 'home#join_us'
  get '/old',to: 'home#index'
  root to: "newhome#index"
end
