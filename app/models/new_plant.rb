class NewPlant < ActiveRecord::Base
 # attr_accessible :recommend_art_ids, :thanks_people, :other_a, :youku_info, :youku_token, :youku_refresh_token, :youku_username
 serialize :youku_info

  def refresh_youku_token
    token = begin
      body = RestClient.post('https://openapi.youku.com/v2/oauth2/token.json', {
        'client_id' => SERVICES['youku']['api_key'].to_s,
        'client_secret' => SERVICES['youku']['api_secret'].to_s,
        'refresh_token' => youku_refresh_token,
        'grant_type' => 'refresh_token'
      })
      MultiJson.load(body)
    rescue
      nil
    end
    update_attributes(:youku_refresh_token => token['refresh_token'], :youku_token => token['access_token'] ) if token
  end

end
