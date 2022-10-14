class Counter < ApplicationRecord

	scope :by_year, lambda { |year| where('extract(year from created_at) = ?', year) }
	
end
