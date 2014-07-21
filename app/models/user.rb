class User < ActiveRecord::Base

  attr_accessor :password, :new_password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :shop_name, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :username, :on => :create
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end


 def self.authenticate_by_email(email, password)
  user = find_by_email(email)
  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    user
  else
    nil
  end
end

def self.authenticate_by_username(username, password)
  user = find_by_username(username)
  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    user
  else
    nil
  end
end

validates_confirmation_of :new_password, :if => Proc.new {|user| !user.new_password.nil? && !user.new_password.empty? }
#validates_presence_of :email, :if => Proc.new {|user| 
  #user.previous_email.nil? || user.email != user.previous_email}

#validates_presence_of :username, :if => Proc.new {|user| 
  #user.previous_username.nil? || user.username != user.previous_username}

#validates_uniqueness_of :email, :if => Proc.new {|user| 
  #user.previous_email.nil? || user.email != user.previous_email}

#validates_uniqueness_of :username, :if => Proc.new {|user| 
 # user.previous_username.nil? || user.username != user.previous_username}
  
def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.token = auth.credentials.token
    user.user_type='client'
    #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!(:validate => false)
  end
end


end
