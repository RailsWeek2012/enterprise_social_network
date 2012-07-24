module PostsHelper
	def self.get_all_posts company_id
		return Post.where('company_id = ? AND group_id IS NULL', company_id).order('created_at DESC')
	end

	def like_button post
		check_like = Like.where('user_id = ? AND post_id = ?', current_user.id, post.id)
		if check_like.count == 0
			link_to content_tag(:i, nil, class: "icon-thumbs-up")+" Like", like_post_path(post.id), remote: true, method: :post, class: "btn btn-mini"
		else
			link_to content_tag(:i, nil, class: "icon-thumbs-down")+" Unlike", unlike_post_path(post.id), remote: true, method: :post, class: "btn btn-mini"
		end
	end
end
