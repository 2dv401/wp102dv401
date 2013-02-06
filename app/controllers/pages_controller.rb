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

  def api

    if user_signed_in?
      ## Hämta ut alla kartor användaren äger, dock endast publika kartor då privata kartor inte skall kunna bäddas in
      @maps = Map.order("created_at ASC").where("private = ?", false).find_all_by_user_id(current_user.id)
    end


  end

  def api_docs

  end
end
