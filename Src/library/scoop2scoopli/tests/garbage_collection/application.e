indexing
	description	: "System's root class"
	author		: "Volkan Arslan, Yann Mueller, Piotr Nienaltowski."
	date		: "$Date: 18.05.2007$"
	revision	: "1.0.0"

class
	APPLICATION

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			i: INTEGER
			x: separate X
		do
			-- create 100 objects of type X that do nothing
			from
				i := 1
			until
				i > 100
			loop
				create x.make (i)
				i := i + 1
			end

			-- create one instance of X that will block for one minute
			create x.make (i)
			call_x (x)

			io.put_string ("Caller (Application.make) terminated ...%N")
			-- the 100 separate object and their processor will be garbage collected since they are not referenced anymore
		end

	call_x (a_x: attached separate X) is
			-- Call f on a_x
		do
			a_x.f
		end

end -- class APPLICATION
