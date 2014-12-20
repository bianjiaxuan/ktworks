class Authentication < ActiveRecord::Base
  # attr_accessible :user_id, :provider, :uid, :access_token, :access_secret

  belongs_to :user

  validates :provider, :uid, :access_token, presence: true
  validates :provider,
    uniqueness: { scope: :uid },
    inclusion: { in: %w(weibo renren qq_connect) }

  def update_token_form_hash omniauth
    update_column(:access_token, omniauth.credentials.token)
  end

  def self.create_from_hash(user_id, omniauth)
    self.create!(
      user_id:      user_id,
      provider:     omniauth.provider,
      uid:          omniauth.uid,
      access_token: omniauth.credentials.token
    )
  end
end
