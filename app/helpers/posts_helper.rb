module PostsHelper
	def self.get_all_posts company_id
		return Post.where('company_id = ? AND group_id IS NULL', company_id).order('created_at DESC')
	end
end
