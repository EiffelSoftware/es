indexing
	description	: "System's root class"
	author		: "Martino Trosi & Matteo Cortonesi"
	date		: "Spring 2009"
	reviewer	: "Mohammad Seyed Alavi"
	revision	: "1.0.1"

class
	ROLLERCOASTER

create
	make

feature -- Initialization

	make is
		-- Creation procedure.
	local
		i: INTEGER
		a_passenger: separate PASSENGER
	do
		-- Create a car instance with the specified capacity and number of trials
		create car.make (car_capacity, car_trials_number)

		-- Create the passengers and make them board the car
		from
			i := 0
		until
			-- In our case we have 'car_capacity * car_trials_number' passengers.
			-- This is just a convenience way to make sure the execution ends after
			-- the car executed the specified number of runs. This condition doesn't
			-- affect the generality of the problem.
			i >= car_capacity * car_trials_number
		loop
			create a_passenger.make_with_id(i)
			board_passenger(a_passenger, car)

			i := i + 1
		end
		io.put_string ("Starting car%N")
		-- Start the car
		start_car(car)
	end

feature {NONE}

	car: separate CAR

	start_car(a_car: separate CAR) is
			--
		do
			a_car.start
		end

	board_passenger(a_passenger: separate PASSENGER; a_car: separate CAR) is
			--
		local
			attached_car: separate CAR
		do
			print("Passenger #" + a_passenger.id.out + " wants to board the car.%N")
			attached_car ?= a_car
			a_passenger.board(attached_car)
		end

	car_capacity: INTEGER is 4
		-- Car's capacity

	car_trials_number: INTEGER is 5
		-- Number of runs the cars will do

end -- class APPLICATION	
