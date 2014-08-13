note
	description: "Constants of the three possible values for tri-state booleans."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_TRI_STATE_BOOLEAN_CONSTANTS

feature {NONE} -- Constants

	Tri_true: AT_TRI_STATE_BOOLEAN
			-- True value
		once ("PROCESS")
			create Result.make_defined (True)
		end

	Tri_false: AT_TRI_STATE_BOOLEAN
			-- False value
		once ("PROCESS")
			create Result.make_defined (False)
		end

	Tri_undefined: AT_TRI_STATE_BOOLEAN
			-- Undefined value
		once ("PROCESS")
			create Result.make_undefined
		end

feature {NONE} -- Conversion from BOOLEAN

	to_tri_state (a_value: BOOLEAN): AT_TRI_STATE_BOOLEAN
			-- Conversion `a_value' from `BOOLEAN' to `AT_TRI_STATE_BOOLEAN'
		do
			create Result.make_defined (a_value)
		end

end
