class InstagramController < ApplicationController

  ## KORTARE BESKRIVINIG!
  ## KOPPLAR UPP MOT INSTAGRAMS API OCH MED HJÄLP AV INSTAGRAM GEMET KAN MAN GÖRA EN DEL FÖRFFRÅGNINGAR
  ## DETTA FUNKAR JUST NU
  ## KOPPLA UPP SIG
  ## FÅ TILLBAKA ACCESS_TOKEN
  ## GÖRA FÖRFRÅGNINGAR MOT API:ET
  ## MAN KAN ANVÄNDA OPEN() FÖR ATT GÖRA YTTERLIGARE FRÅGOR SOM GEMET INTE HAR STÖD FÖR
  ## DETTA ÄR KANSKE INGET PRIO-PROJEKT I PROJEKTET, MEN HADE INGET BÄTTRE FÖR MIG JUST NU.
  ## HINNER VI INTE MED DETTA SÅ SKIPPAR VI DET HELT ENKELT.

  ## TANKEN ÄR UNGEFÄR SÅ HÄR JUST NU
  ## KUNNA HÄMTA INSTAGRAM BILDER SOM LIGGER NÄRA KNUTET TILL SIN KARTAS CENTER - SJÄLVKLART FRIVILLIGT
  ## VÄLJA ETT ANTAL TAGGAR MAN VILL HÄMTA BILDER PÅ, TEX #BADPLATS - OCKSÅ FRIVILLIGT SÅKLART!

  def index


    ## UTVECKLING PÅGÅR!!!!!!!

    ## Gör första anrop mot Instagram
    ## @client gör sedan anrop mot tex media_serach( koordinater )
    client = Instagram.client(:access_token => session[:access_token])



    ## Gör HTTP-anrop mot instagram, när Instagram gemet inte har stöd för sakerna längre.
    require 'open-uri'
    @content = open("https://api.instagram.com/v1/tags/tikko/media/recent?access_token=638572.1d1130b.51853b81cda94eff96fc3d19fb88ffa2").read

   ## Konverterar om JSON till Ruby object!
   ## @foo = ActiveSupport::JSON.decode(@content)

  @map = current_user.maps.first()

    puts "LAT"
    puts @map.location.latitude

    puts "LNG"
    puts @map.location.longitude
    @nearby = client.media_search(@map.location.latitude, @map.location.longitude)
    puts "NEARBY"
    puts @nearby
 end

  def new
  end

  ## Aktiverings vy
  def activate

  end

  ## Skickar förfrågan mot Instagram
  def auth
    Instagram.configure do |config|
      config.client_id = "1d1130b10bf14d84b0a80b34dd08d32a"
      config.client_secret = "a172883fc38c48a0bff249aa1f5113dc"
    end

    redirect_to Instagram.authorize_url(:redirect_uri => "http://localhost:3000/instagram/callback")
  end

  ## Redirect från Instagram
  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => "http://localhost:3000/instagram/callback")
    session[:access_token] = response.access_token

    redirect_to instagram_path
  end
end
