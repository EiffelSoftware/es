note
	description: "A mathematical term composed by a variable and its multiplicative coefficient."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TERM

create
	make

feature {NONE} -- Initialization

	make (a_variable: VARIABLE; a_coefficient: DOUBLE)
		require
			variable_not_void: a_variable /= Void
		do
			variable := a_variable
			coefficient := a_coefficient
		ensure
			variable_set: variable = a_variable
			coefficient_set: coefficient = a_coefficient
		end

feature -- Access

	variable: VARIABLE assign set_variable

	coefficient: DOUBLE assign set_coefficient

feature -- Change

	set_variable (a_variable: like variable)
		do
			variable := a_variable
		ensure
			variable_set: variable = a_variable
		end

	set_coefficient (a_coefficient: like coefficient)
		do
			coefficient := a_coefficient
		ensure
			coefficient_set: coefficient = a_coefficient
		end

end
