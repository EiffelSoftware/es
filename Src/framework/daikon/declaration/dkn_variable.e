note
	description: "Daikon variable declaration"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_VARIABLE

inherit
	DKN_ELEMENT
		redefine
			out
		end

	DKN_CONSTANTS
		undefine
			out
		end

	DKN_UTILITY
		undefine
			out
		end

	HASHABLE
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_name: STRING; a_rep_type: like rep_type; a_var_kind: like var_kind; a_dec_type: like dec_type; a_comparability: INTEGER)
			-- Initialize current.
		require
			a_name_not_is_empty: not a_name.is_empty
			a_rep_type_valid: is_rep_type_valid (a_rep_type)
			a_var_kind_valid: is_var_kind_valid (a_var_kind)
		do
			name := a_name.twin
			daikon_name := encoded_daikon_name (name)
			rep_type := a_rep_type.twin
			var_kind := a_var_kind.twin
			dec_type := a_dec_type.twin
			comparability := a_comparability
		end

feature -- Access

	dec_type: STRING
			-- dec-type of current variable

	var_kind: STRING
			-- var-kind of current variable

	rep_type: STRING
			-- rep-type of current variable

	comparability: INTEGER
			-- Comparability of current variable

	debug_output: STRING
			-- String representation
		do
			create Result.make (64)
			Result.append (daikon_name)
			Result.append_character (',')
			Result.append (var_kind)
			Result.append_character (',')
			Result.append (rep_type)
			Result.append_character (',')
			Result.append (comparability.out)
		end

	out: STRING
			-- String representation
		do
			create Result.make (64)
			Result.append (variable_string)
			Result.append_character (' ')
			Result.append (daikon_name)

			Result.append_character ('%T')
			Result.append (var_kind_string)
			Result.append_character (' ')
			Result.append (var_kind)
			Result.append_character ('%N')

			Result.append_character ('%T')
			Result.append (dec_type_string)
			Result.append_character (' ')
			Result.append (dec_type)
			Result.append_character ('%N')

			Result.append_character ('%T')
			Result.append (rep_type_string)
			Result.append_character (' ')
			Result.append (rep_type)
			Result.append_character ('%N')

			Result.append_character ('%T')
			Result.append (comparability_string)
			Result.append_character (' ')
			Result.append (comparability.out)
			Result.append_character ('%N')
		end

	hash_code: INTEGER
			-- Hash code of current variable

feature -- Status report

	is_var_kind_valid (a_kind: like var_kind): BOOLEAN
			-- Is `a_kind' a valid var-kind?
		do
			Result := var_kinds.has (a_kind)
		end

	is_rep_type_valid (a_type: like rep_type): BOOLEAN
			-- Is `a_type' a avlid rep_type?
		do
			Result := rep_types.has (a_type)
		end

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' valid for current variable?
		require
			a_value_attached: a_value /= Void
		do
			if a_value ~ daikon_nonsensical_value then
				Result := True
			elseif rep_type ~ int_rep_type then
				Result := a_value.is_integer
			elseif rep_type ~ boolean_rep_type then
				Result := a_value.is_boolean
			elseif rep_type ~ hashcode_rep_type then
				Result := a_value.starts_with (once "0x")
			elseif rep_type ~ double_rep_type then
				Result := a_value.is_double
			elseif rep_type ~ string_rep_type then
				Result :=
					not a_value.is_empty and then
					a_value.item (1) = '%"' and then
					a_value.item (a_value.count) = '%"'
			end
		end

end
