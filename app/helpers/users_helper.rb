module UsersHelper
	def profile_link(user)
		link_to content_tag(:span, gravatar_image_tag(user.email, alt: user.full_name), class: "image")+" "+user.full_name, user, class: "profile-link"
	end

	def edit_profile(user)
		link_to "Edit", edit_user_path(user), class: "btn"
	end
end
