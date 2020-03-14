class Rental
	require 'date'
	attr_accessor :id, :start_date, :end_date, :distance, :car, :price, :commission, :options
	
	def initialize id, start_date, end_date, distance
		@id = id
		@start_date = Date.parse(start_date)
		@end_date = Date.parse(end_date)
		@distance = distance
	end

	def days
		(start_date..end_date).count
	end
end

class Car
	attr_accessor :id, :price_per_day, :price_per_km

	def initialize id, price_per_day, price_per_km
		@id = id
		@price_per_day = price_per_day
		@price_per_km = price_per_km
	end
end

# L3
class Commission
	attr_accessor :insurance_fee, :assistance_fee, :drivy_fee, :total, :owner_fee

	def initialize total, insurance_fee, assistance_fee, drivy_fee, owner_fee
		@total = total
		@insurance_fee = insurance_fee
		@assistance_fee = assistance_fee
		@drivy_fee = drivy_fee
		@owner_fee = owner_fee
	end
end

# L5
class Option
	attr_accessor :id, :rental_id, :type

	def initialize id, rental_id, type
		@id = id
		@rental_id = rental_id
		@type = type
	end
end