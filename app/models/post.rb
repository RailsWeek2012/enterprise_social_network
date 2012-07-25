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
	  self.contains_link? && self.image_url?
  end

	def contains_link?
		!self.extract_link.nil?
	end

	def extract_link
		url = nil
		URI.extract(self.message) do |u|
			if u =~ URI.regexp
				unless u.match(/http[s]?:\/\//).nil?
					url = u
					break
				end
			end
		end
		return url
	end

  def extract_images
	  begin
	    self.get_link_infos.page.image_urls
	  rescue Exception => e
		  []
		end
  end

	def get_link_infos
		agent = Mechanize.new
		agent.get(self.extract_link)
		agent
	end
end
