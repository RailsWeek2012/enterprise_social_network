class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :company_id, :email, :first_name, :last_name, :password, :password_confirmation

	belongs_to :company
	has_many :reservations
  has_many :groups_users
  has_many :groups, through: :groups_users
  has_many :posts

	validates :email, :first_name, :last_name, presence: true

	def full_name
		first_name+" "+last_name
	end

	def to_s
		full_name
	end
end
