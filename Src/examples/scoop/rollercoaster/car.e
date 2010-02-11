indexing
	description	: "Object representing a car."
	author		: "Martino Trosi & Matteo Cortonesi"
	date		: "Spring 2009"
	reviewer	: "Mohammad Seyed Alavi"
	revision	: "1.0.1"

class
	CAR

create
	make

feature

	make(a_capacity: INTEGER; a_trials_number: INTEGER) is
			-- Initialize an instance of CAR
		require
			valid_capacity: a_capacity >= 1
			valid_trials_number: a_trials_number >= 1
		do
			capacity := a_capacity
			trials_number := a_trials_number
			create passengers.make (capacity)
		ensure
			capacity_set: capacity = a_capacity
			trials_number_set: trials_number = a_trials_number
		end

	start is
			-- Start the car and repeat the 'load', 'run', 'unload' steps
			-- for the specified number of trials.
		local
			i: INTEGER
		do
			-- The exit door must be initially open in order for the car
			-- to function.
			is_exit_door_open := true
			io.put_string("car: start%N")
			from
				i := 1
			until
				i > trials_number
			loop
				io.put_string ("car: start, load " + is_entry_door_open.out + "," + is_exit_door_open.out + "%N")
				load (passengers)
				io.put_string ("car: start, run%N")
				run (passengers)
				io.put_string ("car: start, unload%N")
				unload (passengers)

				i := i + 1
			end
		end

	is_entry_door_open: BOOLEAN

	is_exit_door_open: BOOLEAN

	passengers: separate MY_HASH_TABLE

	capacity: INTEGER

	add_passenger(a_passenger: separate PASSENGER) is
			-- Add a passenger to the car
		require
			entry_door_is_open: is_entry_door_open
			car_not_ful: not is_full
		do
			add_passenger_to_passengers(a_passenger, passengers)
		end

	add_passenger_to_passengers(a_passenger: separate PASSENGER; the_passengers: separate MY_HASH_TABLE) is
			-- Add the passenger to the car
		do
			the_passengers.put (create {SEP_PASSENGER}.make (a_passenger), a_passenger.id)
			print("Passenger #" + a_passenger.id.out + " boarded the car.%N")
		end

	remove_passenger(a_passenger: separate PASSENGER) is
			-- Remove the passenger from the car
		require
			exit_door_is_open: is_exit_door_open
		do
			remove_passenger_from_passengers(a_passenger, passengers)
		end

	remove_passenger_from_passengers(a_passenger: separate PASSENGER; the_passengers: separate MY_HASH_TABLE) is
			-- Remove the passenger from the car
		do
			the_passengers.remove (a_passenger.id)
		end


	is_full: BOOLEAN is
			-- Is car full?
		do
			Result := is_passengers_full(passengers)
		end

	is_passengers_full(the_passengers: separate MY_HASH_TABLE): BOOLEAN is
			-- Is passengers hashtable full?
		do
			Result := the_passengers.count >= capacity
		end

	is_empty: BOOLEAN is
			-- Is car empty?
		do
			Result := is_passengers_empty(passengers)
		end

	is_passengers_empty(the_passengers: separate MY_HASH_TABLE): BOOLEAN is
			-- Is passengers hashtable empty?
		do
			Result := the_passengers.count = 0
		end

feature {NONE}

	trials_number: INTEGER

	load(the_passengers: separate MY_HASH_TABLE) is
			-- Close the exit door and open the entry door such
			-- that the passengers can board the car
		require
			entry_door_is_closed: not is_entry_door_open
			exit_door_is_open: is_exit_door_open
			car_is_empty: the_passengers.count = 0
		do
			is_exit_door_open := false
			print("Exit door closed.%N")

			print("Entry door opened.%N")
			is_entry_door_open := true
		ensure
			exit_door_is_closed: not is_exit_door_open
			entry_door_is_open: is_entry_door_open
		end

	run(the_passengers: separate MY_HASH_TABLE) is
			-- Run the car
		require
			car_is_full: the_passengers.count = capacity
			entry_door_is_open: is_entry_door_open
			exit_door_is_closed: not is_exit_door_open
		do
			is_entry_door_open := false
			print("Entry door closed.%N")

			print("Car running...%N")
		ensure
			entry_door_is_closed: not is_entry_door_open
		end

	unload(the_passengers: separate MY_HASH_TABLE) is
			-- Open the exit door and make the passengers unboard the car
		require
			entry_door_is_closed: not is_entry_door_open
			exit_door_is_closed: not is_entry_door_open
			car_is_full: the_passengers.count = capacity
		do
			from
				the_passengers.start
			until
				the_passengers.after
			loop
				unboard_passenger (the_passengers.item_for_iteration.passenger)
				the_passengers.forth
			end

			print("Exit door opened")
			is_exit_door_open := true
		ensure
			exit_door_is_open: is_exit_door_open
		end

	unboard_passenger(a_passenger: separate PASSENGER) is
			-- Unboards the passenger
		do
			a_passenger.unboard(current)
		end

	number_of_passengers(the_passengers: separate MY_HASH_TABLE): INTEGER is
			--
		do
			Result := passengers.count
		end

invariant
	car_has_at_most_capacity_passengers: number_of_passengers(passengers) <= capacity

end
