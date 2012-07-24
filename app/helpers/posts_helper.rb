module PostsHelper
	def self.get_all_posts company_id
		return Post.where('company_id = ? AND group_id IS NULL', company_id).order('created_at DESC')
	end

	def like_button(post)
		check_like = Like.where('user_id = ? AND post_id = ?', current_user.id, post.id)
		if check_like.count == 0
			link_to content_tag(:i, nil, class: "icon-thumbs-up")+" Like", like_post_path(post.id), remote: true, method: :post, class: "btn btn-mini"
		else
			link_to content_tag(:i, nil, class: "icon-thumbs-down")+" Unlike", unlike_post_path(post.id), remote: true, method: :post, class: "btn btn-mini"
		end
	end

	def url_preview(post)
		begin
			result = ""
			li = post.get_link_infos
			result += image_tag(li.page.images.first) if li.page.images.length > 0
	    result += content_tag(:b, li.page.title[0..50]+(li.page.title.length > 50 ? "...":""))
		rescue Exception => e
			result = ""
		end
		result = link_to post.extract_link, target: "_blank" do
			result.html_safe
		end
		result.html_safe
	end
end
