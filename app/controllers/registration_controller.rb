class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :only => :token

  def new
    super
  end


  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def update
    super
  end

  def edit

  end
end 