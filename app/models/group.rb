class Group < ActiveRecord::Base
  attr_accessible :name, :leader, :leader_id

  has_many :groups_users
  has_many :users, through: :groups_users
  has_many :posts
	belongs_to :leader, class_name: "User"

	def leader
		User.find(leader_id)
	end
end
