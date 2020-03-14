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
