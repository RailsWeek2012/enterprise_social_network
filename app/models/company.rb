class Company < ActiveRecord::Base
  attr_accessible :name, :owner, :owner_id

	has_many :users
  has_many :reservations
  has_many :infos
	belongs_to :owner, class_name: "User"

	validates :name, presence: true

	def create_default_infos
		["Headquarters", "Year of foundation", "Industry", "Description"].each do |i|
			x = Info.create(key: i, value: "")
			self.infos.push(x)
		end
		self.save
	end
end
