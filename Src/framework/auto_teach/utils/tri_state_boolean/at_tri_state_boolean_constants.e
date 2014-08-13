note
	description: "Summary description for {AT_TRI_STATE_BOOLEAN_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_TRI_STATE_BOOLEAN_CONSTANTS

feature {NONE} -- Constants

	-- TODO: uppercase

	tri_true: AT_TRI_STATE_BOOLEAN
		once
			create Result.make_defined (True)
		end

	tri_false: AT_TRI_STATE_BOOLEAN
		once
			create Result.make_defined (False)
		end

	tri_undefined: AT_TRI_STATE_BOOLEAN
		once
			create Result.make_undefined
		end

feature {NONE} -- Conversion from BOOLEAN

	to_tri_state (a_value: BOOLEAN): AT_TRI_STATE_BOOLEAN
			-- Conversion from BOOLEAN
		do
			create Result.make_defined (a_value)
		end

end
