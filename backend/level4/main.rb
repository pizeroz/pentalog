require '../model'
require '../service'

class Main4
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
						'actions': [
							{
								'who': 'driver',
								'type': 'debit',
								'amount': rental.price
							},
							{
								'who': 'owner',
								'type': 'credit',
								'amount': rental.commission.owner_fee
							},
							{
								'who': 'insurance',
								'type': 'credit',
								'amount': rental.commission.insurance_fee
							},
							{
								'who': 'assistance',
								'type': 'credit',
								'amount': rental.commission.assistance_fee
							},
							{
								'who': 'drivy',
								'type': 'credit',
								'amount': rental.commission.drivy_fee
							}
						]
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

Main4.run