class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

	belongs_to :company
	has_many :reservations
  has_and_belongs_to_many :groups
  has_many :posts

	validates :email, :first_name, :last_name, presence: true

	def full_name
		first_name+" "+last_name
	end

	def to_s
		full_name
	end
end
