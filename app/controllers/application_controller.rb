class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :user_has_email

   rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    ## to avoid deprecation warnings with Rails 3.2.x (and incidentally using Ruby 1.9.3 hash syntax)
    ## this render call should be:
    # render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end
  
  ## Om användaren inte har någon mejl, skicka till en sida och tvinga besökaren att ange mejl.
  def user_has_email
    if current_user
      if current_user.email.blank?
       # redirect_to :controller => 'foo', :action => 'bar'
      end
    end
  end

  def after_sign_in_path_for(user)
    # Mergar kontona informationen från facebook-session med användaren som försöker logga in
    # OM sessionfinns OCH användaren som loggar in inte har facebook-koppling OCH om uid inte är kopplat
    if session["facebook_data"] && current_user.provider != "facebook" && current_user.uid.nil?
      current_user.provider = session["facebook_data"]["provider"]
      current_user.uid = session["facebook_data"]["uid"]
      current_user.name = session["facebook_data"]["info"]["name"]
      current_user.profile_image = session["facebook_data"]["info"]["image"]
      current_user.save(:validate => false)
    end
    # Tar bort sessionen
    session.keys.grep(/^facebook/).each { |k| session.delete(k) }
    super
  end
end