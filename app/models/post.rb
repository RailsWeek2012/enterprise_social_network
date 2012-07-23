class Post < ActiveRecord::Base
  attr_accessible :company_id, :group_id, :message, :user_id, :parent_id

	belongs_to :user
	belongs_to :group

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
end
