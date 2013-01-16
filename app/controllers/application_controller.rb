class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :user_has_email

  ## Om användaren inte har någon mejl, skicka till en sida och tvinga besökaren att ange mejl.
  def user_has_email
    if current_user
      if current_user.email.blank?
       # redirect_to :controller => 'foo', :action => 'bar'
      end
    end
  end
end