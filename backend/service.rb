module Service
	require 'json'

	def self.json_file_to_object input
		begin
			file = File.read(input)
			data = JSON.parse(file)

			cars = data['cars'].map { |c| Car.new c['id'], c['price_per_day'], c['price_per_km'] }

			data['rentals'].map do |r|
				car = cars.find { |c| c.id == r['car_id'] }
				Rental.new r['id'], r['start_date'], r['end_date'], r['distance'], car
			end
		rescue
			[]
		end
	end

	def self.hash_result_to_file result, output
		File.open(output, 'w') do |f|
			f.write(JSON.pretty_generate(result))
		end
	end
end

module Business
	# L2
	DECREASING = [
		{
			after_day: 1,
			percent: 0.1
		},
		{
			after_day: 4,
			percent: 0.3
		},
		{
			after_day: 10,
			percent: 0.5
		}
	]

	# L3
	EX_RATE_EUR_CENT = 100
	
	COMMISSION = {
		total: 0.3, #30% price
		insurance_fee: 0.5, #50% total
		assistance_fee: 1 #1€/day goes to the roadside
	}
end