class Post < ActiveRecord::Base
  attr_accessible :company_id, :group_id, :message, :user_id, :parent_id

	belongs_to :user
	belongs_to :group
  has_many :likes

  validates :message, :user_id, :company_id, presence: true

	def comment_count
		self.comments.count
	end

  def comments
	  Post.where('parent_id = ?', self.id)
  end

	def parent
		Post.find(self.parent_id)
	end

	def contains_link?
		url = URI.extract(self.message)
		url.length > 0
	end

	def extract_link
		URI.extract(self.message).first
	end

	def get_link_infos
		agent = Mechanize.new
		agent.get(self.extract_link)
		agent
	end

	def get_group_posts
		where('company_id = ? AND group_id = ?', current_user.company_id, params[:group]).order('created_at DESC')
	end
end
