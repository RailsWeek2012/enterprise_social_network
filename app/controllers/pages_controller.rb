class PagesController < ApplicationController
  def home
	  gon.hide_sidebars = !user_signed_in?
	  if user_signed_in?
		  # shows mainstream
		  @posts = PostsHelper.get_all_posts current_user.company_id
		  @company = current_user.company
		  render file: "posts/index"
	  else
		  # shows welcome page
	    render action: "home"
		end
  end
end
