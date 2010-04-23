note
	description: "ARFF string attribute"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_NOMINAL_ATTRIBUTE

inherit
	WEKA_ARFF_ATTRIBUTE

create
	make

feature{NONE} -- Initialization

	make (a_name: like name; a_values: LINKED_SET [STRING])
			-- Initialize current nominal attribute with `a_name' and
			-- values `a_values'.
		require
			no_void: not a_values.has (Void)
			no_space: a_values.for_all (agent (a_value: STRING): BOOLEAN do Result := a_value.has_substring (" ") end)
		do
			create values.make
			values.compare_objects
			a_values.do_all (agent (a_value: STRING; a_set: like values) do a_set.extend (a_value.twin) end (?, values))
		end

feature -- Access

	values: LINKED_SET [STRING]
			-- Nominal values for current attribute

	type_string: STRING
			-- String representing the type of current attribute
		local
			l_cursor: CURSOR
		do
			create Result.make (128)
			Result.append_character ('{')
			l_cursor := values.cursor
			from
				values.start
			until
				values.after
			loop
				Result.append (values.item_for_iteration)
				if values.index < values.count then
					Result.append (once ", ")
				end
				values.forth
			end
			values.go_to (l_cursor)
			Result.append_character ('}')
		end


	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		do
			if a_value /= Void then
				Result := a_value
			else
				Result := missing_value
			end
		end

feature -- Status report

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if a_value /= Void then
				Result := values.has (a_value)
			else
				Result := True
			end

		end

end
