if @user
  node(:success) { true }
  child @user do
    attributes :id, :nickname, :grade, :scores, :is_vip, :rank, :showtimes, :wins, :draws, :loses
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
  node(:message) { '没有此用户' }
end
