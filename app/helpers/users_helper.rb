module UsersHelper
	def back_to_users
		link_to "Back", users_path, class: "btn"
	end

	def profile_link(user)
		link_to user.full_name, user
	end

	def edit_profile(user)
		link_to "Edit", edit_user_path(user), class: "btn"
	end
end
