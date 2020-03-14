require '../model'
require '../service'

class Main1
	include Service

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
			rental.days * car.price_per_day + rental.distance * car.price_per_km
		end
	end
end

Main1.run