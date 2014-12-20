if @user
  node(:success) { true }
  node(:access_token) { @user.authentication_token }
  child @user do
    attributes :id, :nickname, :email, :phone, :admin, :grade, :scores, :created_at, :is_vip, :start_vip_time, :end_vip_time, :has_subscribed_sms, :invitor_id, :invitees_count, :users_count, :is_judge, :rank, :showtimes, :wins, :draws, :loses
    node(:qrcode_img_url) { user_qrcode_img_url(@user) }
    node(:birthday) { @user.profile.birthday }
    node(:sex) { @user.profile.gender }
    node(:province) { @user.profile.province }
    node(:city) { @user.profile.city }
    node(:area) { @user.profile.area }
    node(:age_group) { @user.profile.age_group }
    node(:avatar) { user_avatar_url(@user) }
  end
else
  node(:success) { false }
  node(:message) { '登录名或密码不匹配' }
end
