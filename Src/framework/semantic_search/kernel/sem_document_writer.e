note
	description: "Writer to write a semantic document"
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT_WRITER
inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR

	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

	ETR_SHARED_TOOLS

	SEM_FIELD_NAMES

feature -- Basic operation

	write (a_queryable: SEM_QUERYABLE; a_folder: STRING)
			-- Output `a_queryable' into a file in `a_folder'
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}a_queryable as l_ft_call_trans then
				-- delegate
				feature_call_writer.write (l_ft_call_trans, a_folder)
			else
				to_implement("")
			end
		end

feature {NONE} -- Specialized writers

	feature_call_writer: SEM_FEATURE_CALL_TRANSITION_WRITER
		once
			create Result
		end

feature {NONE} -- Implementation

	values_from_change (a_change: EPA_EXPRESSION_CHANGE): STRING
			-- Values from `a_change'.
		do
			create change_value_buffer.make (64)
			a_change.values.process (Current)
			Result := change_value_buffer.twin
		end

	process_expression_change_value_set (a_values: EPA_EXPRESSION_CHANGE_VALUE_SET)
			-- Process `a_values'
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			i, c: INTEGER
			l_buffer: like change_value_buffer
		do
			from
				l_buffer := change_value_buffer
				i := 1
				c := a_values.count
				l_cursor := a_values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_buffer.append (l_cursor.item.text)
				if i < c then
					l_buffer.append (field_value_separator)
				end
				i := i + 1
				l_cursor.forth
			end
		end

	process_integer_range (a_values: EPA_INTEGER_RANGE)
			-- Process `a_values'.
		local
			l_lower: INTEGER
			l_upper: INTEGER
			i: INTEGER
			l_buffer: like change_value_buffer
		do
			l_buffer := change_value_buffer
			if a_values.lower = a_values.negative_infinity then
				l_lower := min_integer
			else
				if a_values.is_lower_included then
					l_lower := a_values.lower
				else
					l_lower := a_values.lower + 1
				end
			end

			if a_values.upper = a_values.positive_infinity then
				l_upper := max_integer
			else
				if a_values.is_upper_included then
					l_upper := a_values.upper
				else
					l_upper := a_values.upper - 1
				end
			end
			from
				i := l_lower
			until
				i > l_upper
			loop
				l_buffer.append (i.out)
				if i < l_upper then
					l_buffer.append (field_value_separator)
				end
				i := i + 1
			end
		end

	abstract_types (a_type: TYPE_A; a_feature: FEATURE_I): LIST[CL_TYPE_A]
			-- Get a list of abstract types of `a_type' that also contain the feature `a_feature'
		require
			is_class_type: a_type.is_full_named_type
		local
			l_precursors: LIST[CLASS_C]
		do
			from
				create {LINKED_LIST[CL_TYPE_A]}Result.make
				l_precursors := a_feature.e_feature.precursors
				l_precursors.start
			until
				l_precursors.after
			loop
				if attached {GEN_TYPE_A}a_type as l_gen_type then
					if l_gen_type.generics.count /= l_precursors.item.generics.count then
						to_implement ("Generics reduced on inheritance")
					else
						Result.extend (create {GEN_TYPE_A}.make (l_precursors.item.class_id, l_gen_type.generics))
					end
				else
					Result.extend(l_precursors.item.actual_type)
				end
				l_precursors.forth
			end
		end

	is_type_valid (a_type: STRING): BOOLEAN
			-- Is `a_type' valid?
		do
			Result :=
				a_type ~ type_boolean or
				a_type ~ type_integer or
				a_type ~ type_string
		end

	default_boost: DOUBLE = 1.0
			-- Default boost value for a field

	type_boolean: STRING = "BOOLEAN"
			-- Type boolean

	type_integer: STRING = "INTEGER"
			-- Type integer

	type_string: STRING = "STRING"

	change_value_buffer: STRING
			-- Buffer to store change values

	max_integer: INTEGER = 10
			-- Max integer used in relaxed integer changes

	min_integer: INTEGER = -10
			-- Min integer used in relaxed integer changes
end
