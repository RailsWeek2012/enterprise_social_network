class Group < ActiveRecord::Base
  attr_accessible :name, :leader, :leader_id

	has_and_belongs_to_many :users
  has_many :posts
	belongs_to :leader, class_name: "User"

	def leader
		User.find(leader_id)
	end
end
