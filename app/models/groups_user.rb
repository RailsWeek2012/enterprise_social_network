class GroupsUser < ActiveRecord::Base
  attr_accessible :group_id, :status, :user_id

	belongs_to :group
	belongs_to :user

	def self.open_group_invitation(group_id, user_id)
		where('group_id = ? AND user_id = ? AND status = 0', group_id, user_id).first
	end
end
