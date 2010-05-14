indexing
	description	: "System's root class"
	author		: "Volkan Arslan, Yann Mueller, Piotr Nienaltowski."
	date		: "$Date: 28.05.2007$"
	revision	: "1.0.0"

class
	APPLICATION

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		do
			io.put_string ("Expanded types application%N")
			io.new_line
			create my_x.make

			r (my_x, 10)

		end

	r (x: attached separate X; i: INTEGER) is
			-- Launch x
		local
			e: E
		do
			if x.b then
				e := x.e
				print (e)
				io.new_line
			else
				io.put_string ("Else part ...")
				io.new_line
			end

			x.f (i)
		end

feature -- Access

	my_x: attached separate X

end -- class APPLICATION	
