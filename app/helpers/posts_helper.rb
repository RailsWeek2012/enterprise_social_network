module PostsHelper
	def self.get_all_posts company_id
		return Post.where('company_id = ?', company_id).order('created_at DESC')
	end
end
