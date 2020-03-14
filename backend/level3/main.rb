require '../model'
require '../service'

class Main3
	include Service
	include Business

	class << self
		def run input, output
			begin
				rentals = Service.json_file_to_object input
				result = hash_result rentals
				Service.hash_result_to_file result, output
				puts 'The calculation was successful! Please check the result in ' + output
			rescue
				puts 'Something went wrong!'
			end
		end

		private

		def hash_result rentals
			return {} if rentals.empty?
			calc rentals
			{
				'rentals': rentals.map do |rental|
					{
						'id': rental.id,
						'price': rental.price,
						'commission': {
							'insurance_fee': rental.commission.insurance_fee,
							'assistance_fee': rental.commission.assistance_fee,
							'drivy_fee': rental.commission.drivy_fee
						}
					}
				end
			}
		end

		def calc rentals
			rentals.each do |rental|
				rental.price = Service.calc_discount_price rental
				rental.commission = Service.calc_commision rental
			end
		end
	end
end

Main3.run './data/input.json', './data/output.json'