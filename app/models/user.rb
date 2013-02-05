class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]
  
  has_many :status_updates, :dependent => :destroy
  has_many :status_comments, :dependent => :destroy
  has_many :maps, :dependent => :destroy
  has_many :marks, :dependent => :destroy

  acts_as_follower
  acts_as_liker

  # To use devise-twitter don't forget to include the :twitter_oauth module:

  # e.g. devise :database_authenticatable, ... , :twitter_oauth
  # IMPORTANT: If you want to support sign in via twitter you MUST remove the
  # :validatable module, otherwise the user will never be saved
  # since it's email and password is blank.
  # :validatable checks only email and password so it's safe to remove
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:validatable,
  :recoverable, :rememberable, :trackable,
  :omniauthable, :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field remote 'username'
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :username,
                  :name, :login, :profile_image, :likes

  validates_uniqueness_of :username


  ## Ser till att e-post inte behövs vid Twitter registrering.
  def email_required?
    super && provider.blank?
  end

  # Lägger till facebook-mailen till användarkontot när det registreras
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
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
      
    # Fullösning. Fixa
    nummer = rand(1+1000)+1000
    foonummer = nummer.to_s << "@gmail.com"
 

    unless user
      user = User.new(name:auth.extra.raw_info.name,
                          username:auth.info.nickname,
                          provider:auth.provider,
                          uid:auth.uid,
                          profile_image:auth.info.image,
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
