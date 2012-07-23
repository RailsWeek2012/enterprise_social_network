class PagesController < ApplicationController
  def home
	  gon.hide_sidebars = !user_signed_in?
	  if user_signed_in?
		  @posts = PostsHelper.get_all_posts current_user.company_id
		  render file: "posts/index"
	  else
	    render action: "home"
		end
  end
end
