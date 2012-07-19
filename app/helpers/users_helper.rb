module UsersHelper
	def back_to_list
		link_to "Back", users_path, class: "btn"
	end

	def link_show(user)
		link_to "Show", user, class: "btn"
	end

	def link_edit(user)
		link_to "Edit", edit_user_path(user), class: "btn"
	end
end
