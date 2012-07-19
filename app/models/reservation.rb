class Reservation < ActiveRecord::Base
  attr_accessible :company_id, :email, :inviter_id, :token

	belongs_to :company
	belongs_to :inviter, class_name: "User"
end
