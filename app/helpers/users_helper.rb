module UsersHelper
	def profile_link(user)
		link_to content_tag(:span, gravatar_image_tag(user.email, alt: user.full_name), class: "image")+" "+user.full_name, user, class: "profile-link"
	end

	def edit_profile(user)
		link_to "Edit", edit_user_path(user), class: "btn"
	end

	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end

	def current_user
		return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.record
	end

	def user_signed_in?
		current_user.present?
	end
end
