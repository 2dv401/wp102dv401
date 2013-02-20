class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, only: :token

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  def edit
    super
  end

  # redirects user to create the first map after signing up.
  def after_sign_up_path_for(resource)
    new_profile_map_path(resource.slug)
  end
end 