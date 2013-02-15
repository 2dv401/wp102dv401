module RegistrationHelper
  
  # Kontrollerar om facebooksession finns
  def facebook?
    session["facebook_data"]
  end
end
