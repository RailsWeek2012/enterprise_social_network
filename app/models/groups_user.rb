class GroupsUser < ActiveRecord::Base
  attr_accessible :group_id, :status, :user_id

	belongs_to :group
	belongs_to :user
end
