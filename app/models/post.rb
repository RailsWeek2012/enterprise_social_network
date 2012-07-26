#encoding: utf-8
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

  def has_preview?
	  # check if post message contains link and image_url is set
	  self.contains_link? && self.image_url?
  end

	def contains_link?
		!self.extract_link.nil?
	end

	def extract_link
		# extracts first link in message
		url = URI.extract(self.message, ["http", "https", "ftp"]).first
	end

  def extract_images
	  # extracts image urls from external link (img-tags only)
	  begin
	    self.get_link_infos.page.image_urls
	  rescue Exception => e
		  []
		end
  end

	def get_link_infos
		agent = Mechanize.new
		agent.get(self.extract_link, Rack::Utils.parse_nested_query(URI.parse(self.extract_link).query))
		agent
	end
end
