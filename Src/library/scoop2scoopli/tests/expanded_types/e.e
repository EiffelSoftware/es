indexing
	description	: "Expanded class E"
	author		: "Volkan Arslan, Yann Mueller, Piotr Nienaltowski."
	date		: "$Date: 28.05.2007$"
	revision	: "1.0.0"


expanded class
	E

feature -- Element change

	set_i (an_i: INTEGER) is
			-- Set `i' to `an_i'.
		do
			i := an_i
		ensure
			i_assigned: i = an_i
		end

feature

	i: INTEGER

	string: STRING

end
