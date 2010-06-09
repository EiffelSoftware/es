note
	description: "Daikon trace record"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_TRACE_RECORD

inherit
	DEBUG_OUTPUT
		redefine
			out
		end

	DKN_CONSTANTS
		undefine
			out
		end

	DKN_SHARED_EQUALITY_TESTERS
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_program_point: like program_point)
			-- Initialize Current.
		do
			program_point := a_program_point
			create values.make (variables.count)
			values.set_key_equality_tester (daikon_variable_equality_tester)
		end

feature -- Access

	program_point: DKN_PROGRAM_POINT
			-- Program point associated with current trace record

	variables: DS_HASH_SET [DKN_VARIABLE]
			-- Variables available at current trace record
		do
			Result := program_point.variables
		end

	values: DS_HASH_TABLE [DKN_VARIABLE_VALUE, DKN_VARIABLE]
			-- Values of variables at current trace record

	out, debug_output: STRING
			-- String representation of current.
		local
			l_cursor: like values.new_cursor
			l_value: DKN_VARIABLE_VALUE
		do
			create Result.make (4096)

			Result.append (program_point.daikon_name)
			Result.append_character ('%N')

			from
				l_cursor := values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.key.daikon_name)
				Result.append_character ('%N')
				l_value := l_cursor.item
				Result.append (l_value.value)
				Result.append_character ('%N')
				Result.append (l_value.modification_flag.out)
				Result.append_character ('%N')
				l_cursor.forth
			end
			Result.append_character ('%N')
		end

feature -- Status report

	is_complete: BOOLEAN
			-- Is current trace record complete?
			-- That is: every variable in `variables' has its associated value in `values'.
		do
			Result := variables.for_all (agent values.has)
		end

feature -- Basic operations

	complete
			-- Complete current record by provide nonsensical values to
			-- variables which do not have any values yet.
		local
			l_cursor: like variables.new_cursor
			l_values: like values
			l_var: DKN_VARIABLE
		do
			if not is_complete then
				from
					l_values := values
					l_cursor := variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_var := l_cursor.item
					if not l_values.has (l_var) then
						l_values.force_last (nonsensical_value_for_variable (l_var), l_var)
					end
					l_cursor.forth
				end
			end
		ensure
			current_is_complete: is_complete
		end

feature{NONE} -- Implementation

	nonsensical_value_for_variable (a_variable: DKN_VARIABLE): DKN_VARIABLE_VALUE
			-- A nonsensical value for `a_variable'
		do
			create Result.make (a_variable, daikon_nonsensical_value, modified_flag_2)
		end

end
