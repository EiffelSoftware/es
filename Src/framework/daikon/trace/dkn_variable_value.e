note
	description: "Class that represents a value of a variable in Daikon trace file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_VARIABLE_VALUE

inherit
	DEBUG_OUTPUT
		redefine
			out
		end

	DKN_CONSTANTS
		undefine
			out
		end



create
	make

feature{NONE} -- Initialization

	make (a_variable: like variable; a_value: like value; a_modification_flog: INTEGER)
			-- Initialize Current.
		require
			value_valid: is_valid_value (a_variable, a_value, a_modification_flog)
		do
			variable := a_variable
			value := a_value.twin
			modification_flag := a_modification_flog
		end

feature -- Access

	variable: DKN_VARIABLE
			-- Variable

	value: STRING
			-- Value

	modification_flag: INTEGER
			-- Modification flag

	out, debug_output: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make (64)
			Result.append (variable.daikon_name)
			Result.append_character (',')
			Result.append_character (' ')
			Result.append (daikon_equality_sign)
			Result.append (value.out)
			Result.append_character (' ')
			Result.append_character ('(')
			Result.append (modification_flag.out)
			Result.append_character (')')
		end

feature -- Status report

	is_valid_value (a_variable: like variable; a_value: like value; a_modification_flag: INTEGER): BOOLEAN
			-- Does `a_variable', `a_value' and `a_modification_flog' represent a valid value?
		require
			a_valud_attached: a_value /= Void
		do
			Result := modification_flags.has (a_modification_flag)

			if a_value ~ daikon_nonsensical_value then
				Result := a_modification_flag = modified_flag_2
			end

			if Result then
				Result := a_variable.is_valid_value (a_value)
			end
		end

end
