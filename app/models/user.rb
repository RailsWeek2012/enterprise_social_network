class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

	belongs_to :company
	has_many :reservations

	validates :email, :first_name, :last_name, presence: true
end
