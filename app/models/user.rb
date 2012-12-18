class User < ActiveRecord::Base
  # To use devise-twitter don't forget to include the :twitter_oauth module:
  # e.g. devise :database_authenticatable, ... , :twitter_oauth
  # IMPORTANT: If you want to support sign in via twitter you MUST remove the
  # :validatable module, otherwise the user will never be saved
  # since it's email and password is blank.
  # :validatable checks only email and password so it's safe to remove
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable,
  :validatable, :confirmable,
  :omniauthable, :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :username, :name, :login, :profile_image

  # attr_accessible :title, :body
  # Lägger till facebook-mailen till användarkontot när det registreras
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  # Hittar användare eller registrerar en ny
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

  require('json')
    puts "hej hej Facebook"
    puts auth.to_json

    unless user
      user = User.new(name:auth.extra.raw_info.name,
                        username:auth.extra.raw_info.username,
                        provider:auth.provider,
                        uid:auth.uid,
                        profile_image:auth.info.image,
                        email:auth.info.email,
                        password:Devise.friendly_token[0,20]
                      )
      user.skip_confirmation!
      user.save
    end
    return user
  end


  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
      
    require('json')

    puts "hej hej Twitter"
    puts auth.to_json  

    unless user
      user = User.new(name:auth.extra.raw_info.name,
                          username:auth.info.nickname,
                          provider:auth.provider,
                          uid:auth.uid,
                          profile_image:auth.info.image,
                          email:'tordbob@foo.se',
                          password:Devise.friendly_token[0,20]
                        )
      user.skip_confirmation!
      user.save
    end

    return user
  end

  # function to handle user's login via email or username
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def skip_confirmation!
   self.confirmed_at = Time.now
  end
end