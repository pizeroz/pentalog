require '../model'
require '../service'

class Main2
	include Service
	include Business

	class << self
		def run
			rentals = Service.json_file_to_object './data/input.json'
			result = hash_result rentals
			Service.hash_result_to_file result, './data/output.json'
		end

		private

		def hash_result rentals
			return {} if rentals.empty?
			calc rentals
			{
				'rentals': rentals.map do |rental|
					{
						'id': rental.id,
						'price': rental.price
					}
				end
			}
		end

		def calc rentals
			rentals.each do |rental|
				rental.price = calc_price rental
			end
		end

		def calc_price rental
			return 0 unless car = rental.car
			return rental.days * car.price_per_day + rental.distance * car.price_per_km unless defined?(Business::DECREASING)

			days = rental.days
			prices = []

			Business::DECREASING.each_with_index do |decreasing, index|
				break unless days > 0

				after_day = decreasing[:after_day]
				previous_after_day = index == 0 ? 0 : Business::DECREASING[index - 1][:after_day]
				percent = index == 0 ? 0 : Business::DECREASING[index - 1][:percent]

				decreasing_days = after_day - previous_after_day
				prices << (days > decreasing_days ? decreasing_days : days) * (1 - percent)
				days -= decreasing_days

				prices << days * (1 - decreasing[:percent]) if index + 1 == Business::DECREASING.count
			end

			(prices.sum * car.price_per_day).round + rental.distance * car.price_per_km
		end
	end
end

Main2.run