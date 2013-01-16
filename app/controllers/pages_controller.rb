class PagesController < ApplicationController

	skip_before_filter :user_has_email

  def about
  end

  def terms
  end

  def privacy
  end

  def help
  end
end
