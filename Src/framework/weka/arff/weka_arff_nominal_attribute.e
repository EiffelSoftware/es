note
	description: "ARFF string attribute"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_NOMINAL_ATTRIBUTE

inherit
	WEKA_ARFF_ATTRIBUTE
		redefine
			is_nominal
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_name: like name; a_values: like values)
			-- Initialize current nominal attribute with `a_name' and
			-- values `a_values'.
		require
			no_void: not a_values.has (Void)
			no_space: a_values.for_all (agent (a_value: STRING): BOOLEAN do Result := a_value.has_substring (" ") end)
		do
			name := a_name.twin
			create values.make (a_values.count)
			values.set_equality_tester (string_equality_tester)
			a_values.do_all (agent values.force_last)
		end

feature -- Access

	values: DS_HASH_SET [STRING]
			-- Nominal values for current attribute

	type_string: STRING
			-- String representing the type of current attribute
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			i: INTEGER
			c: INTEGER
		do
			create Result.make (128)
			Result.append_character ('{')
			from
				i := 1
				c := values.count
				l_cursor := values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.item)
				if i < c then
					Result.append_character (',')
					Result.append_character (' ')
				end
				i := i + 1
				l_cursor.forth
			end
			Result.append_character ('}')
		end


	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		do
			if a_value /= Void and then values.has (a_value) then
				Result := a_value
			else
				Result := missing_value
			end
		end

	as_nominal (a_values: DS_HASH_SET [STRING]): WEKA_ARFF_NOMINAL_ATTRIBUTE
			-- Norminal attribute from Current under the set of values `a_values'
		do
			create Result.make (name, a_values)
		end

feature -- Status report

	is_nominal: BOOLEAN = True
			-- Is current attribute of norminal type?

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if a_value /= Void then
				Result := values.has (a_value) or a_value ~ "?"
			else
				Result := True
			end

		end

end
