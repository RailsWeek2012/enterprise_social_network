class Company < ActiveRecord::Base
  attr_accessible :name, :owner

	has_many :users
  has_many :reservations
	belongs_to :owner, class_name: "User"
end
