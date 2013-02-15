class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, only: :token

  def new
    super
  end


  def create
    super
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = t :signed_up, scope: [:devise, :registrations]
      redirect_to root_url
    else
      flash[:error] = t :failed_to_register, scope: [:devise, :registrations]
      render action: :new
    end
  end

  def update
    super
  end

  def edit

  end
end 