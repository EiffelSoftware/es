indexing
	description	: "Objects that describe the behaviour of a barber"
	author		: "Robin Stoll"
	date		: "2009/5/16"
	reviewer	: "Mohammad Seyed Alavi"
	revision	: "1.0.1"

class
	BARBER

create
	make

feature {NONE} -- Initialization

	make (a_shop: separate SHOP; a_time: INTEGER) is
			-- Creation procedure
			require
				a_shop /= void
			do
				shop := a_shop
				hair_cut_time := a_time
			end

feature {CUSTOMER} -- Basic access

	do_hair_cut (an_id: INTEGER):BOOLEAN is
			-- called from a customer who wants to get hair cut
			require
				an_id >= 0
			do
--				scoop_sleep (hair_cut_time)
				result := true
			end


feature {NONE} -- Implementation

	shop: separate SHOP
	hair_cut_time: INTEGER

invariant

	shop /= void

end
