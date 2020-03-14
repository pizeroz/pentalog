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

	def self.calc_price rental
		return 0 unless car = rental.car
		rental.days * car.price_per_day + rental.distance * car.price_per_km
	end

	def self.calc_discount_price rental
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

	def self.calc_commision rental
		total_fee = rental.price * Business::COMMISSION[:total_fee]
		insurance_fee = total_fee * Business::COMMISSION[:insurance_fee]
		assistance_fee = rental.days * Business::COMMISSION[:assistance_fee] * Business::EX_RATE_EUR_CENT
		drivy_fee = total_fee - insurance_fee - assistance_fee
		owner_fee = rental.price - total_fee

		Commission.new total_fee.round, insurance_fee.round, assistance_fee.round, drivy_fee.round, owner_fee.round
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
		total_fee: 0.3, #30% price
		insurance_fee: 0.5, #50% total
		assistance_fee: 1 #1€/day goes to the roadside
	}
end