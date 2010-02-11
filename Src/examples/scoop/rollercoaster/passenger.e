indexing
	description	: "Object representing a passenger."
	author		: "Martino Trosi & Matteo Cortonesi"
	date		: "Spring 2009"
	reviewer	: "Mohammad Seyed Alavi"
	revision	: "1.0.1"

class
	PASSENGER

create
	make_with_id

feature {NONE}

	make_with_id(an_id: INTEGER) is
			-- Initialize an instance of passenger
		do
			id := an_id
		end

feature

	board(a_car: separate CAR) is
			-- board a car
		require
			entry_door_is_open: a_car.is_entry_door_open
			car_not_full: not a_car.is_full
		do
			print ("passenger: car door open -- " + a_car.is_entry_door_open.out + "%N")
			a_car.add_passenger (Current)
		end

	unboard(a_car: separate CAR) is
			-- board a car
		require
			exit_door_is_open: a_car.is_exit_door_open
		do
			a_car.remove_passenger (Current)
		end

	id: INTEGER

end
