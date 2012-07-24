class Info < ActiveRecord::Base
  attr_accessible :key, :value, :company_id

	belongs_to :company
end
