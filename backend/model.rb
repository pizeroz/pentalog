class Rental
	require 'date'
	attr_accessor :id, :start_date, :end_date, :distance, :car, :price, :commission

	def initialize id, start_date, end_date, distance, car
		@id = id
		@start_date = Date.parse(start_date)
		@end_date = Date.parse(end_date)
		@distance = distance
		@car = car
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
	attr_accessor :insurance_fee, :assistance_fee, :drivy_fee

	def initialize insurance_fee, assistance_fee, drivy_fee
		@insurance_fee = insurance_fee
		@assistance_fee = assistance_fee
		@drivy_fee = drivy_fee
	end
end