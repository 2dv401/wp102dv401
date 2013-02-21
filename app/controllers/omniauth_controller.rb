class OmniauthController < ApplicationController


	CALLBACK_URL = "http://localhost:3000/omniauth/callback"


  def instagram



  	Instagram.configure do |config|
  		config.client_id = "1d1130b10bf14d84b0a80b34dd08d32a"
  		config.client_secret = "a172883fc38c48a0bff249aa1f5113dc"
	end	

	puts "_____________________INSTAGRAM_________"

	 Instagram.authorize_url(redirect_uri: CALLBACK_URL)

	redirect_to action: "callback"


  end

  def callback
  		response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)

  		puts response

  		session[:access_token] = response.access_token
 	
  end

end
