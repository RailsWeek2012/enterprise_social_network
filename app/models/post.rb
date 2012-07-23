class Post < ActiveRecord::Base
  attr_accessible :company_id, :group_id, :message, :user_id, :parent_id

	belongs_to :user
	belongs_to :group
end
