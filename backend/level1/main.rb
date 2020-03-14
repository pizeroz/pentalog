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
				rental.price = Service.calc_price rental
			end
		end
	end
end

Main1.run