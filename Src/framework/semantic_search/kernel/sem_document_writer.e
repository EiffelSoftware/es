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

	SEM_UTILITY

feature -- Basic operation

	write (a_queryable: SEM_QUERYABLE; a_folder: STRING)
			-- Output `a_queryable' into a file in `a_folder'
		do
			-- delegate
			if attached {SEM_TRANSITION}a_queryable as l_trans then
				transition_writer.write (l_trans, a_folder)
			else
				to_implement("")
			end
		end

feature {NONE} -- Specialized writers

	transition_writer: SEM_TRANSITION_WRITER
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

	abstract_types (a_type: TYPE_A; a_feature_list: LIST[STRING]): LIST[CL_TYPE_A]
			-- Get a list of abstract types of `a_type' that also contain the features in `a_feature_list'
		require
			is_class_type: a_type.is_full_named_type
		local
			l_feature: E_FEATURE
			l_precursors: LIST[CLASS_C]
			l_class: CLASS_C
			l_first: BOOLEAN
			l_type: CL_TYPE_A
			l_has_all: BOOLEAN
			l_features: LINKED_LIST[FEATURE_I]
		do
			l_class := a_type.associated_class

			-- Get all abstract candidates
			from
				a_feature_list.start
				l_first := true
				create l_features.make
				create {LINKED_LIST[CL_TYPE_A]}Result.make
			until
				a_feature_list.after
			loop
				l_feature := l_class.feature_named (a_feature_list.item).e_feature
				l_features.extend (l_feature.associated_feature_i)

				l_precursors := l_feature.precursors

				from
					l_precursors.start
				until
					l_precursors.after
				loop
					if attached {GEN_TYPE_A}a_type as l_gen_type then
						if l_gen_type.generics.count /= l_precursors.item.generics.count then
							to_implement ("Generics reduced on inheritance")
						else
							create {GEN_TYPE_A}l_type.make (l_precursors.item.class_id, l_gen_type.generics)
						end
					else
						l_type := l_precursors.item.actual_type
					end
					Result.extend(l_type)

					l_precursors.forth
				end
				a_feature_list.forth
			end

			-- Remove candidates that don't have all the features
			from
				Result.start
			until
				Result.after
			loop
				from
					l_class := Result.item.associated_class
					l_has_all := true
					l_features.start
				until
					l_features.after or not l_has_all
				loop
					if l_class.feature_of_rout_id_set (l_features.item.rout_id_set) = void then
						l_has_all := false
					end

					l_features.forth
				end

				if not l_has_all then
					Result.remove
				else
					Result.forth
				end
			end
		end

	variable_form_from_anonymous (a_string: STRING): STRING
			-- Converts any {n} to vn
		local
			l_pos: INTEGER
			l_change: BOOLEAN
		do
			from
				create Result.make (a_string.count)
				l_pos := 1
			until
				l_pos > a_string.count
			loop
				if a_string.item (l_pos) = '{' then
					l_change := true
				elseif a_string.item (l_pos) /= '}' then
					if l_change then
						Result.extend ('v')
						l_change := false
					end

					Result.extend (a_string.item (l_pos))
				end
				l_pos := l_pos + 1
			end
		end

	calls_on_principal_variable (a_content: STRING; a_princ_var_index: INTEGER): LIST[STRING]
			-- Parse `a_content' and return calls to `a_princ_var_index'
		local
			l_pos: INTEGER
			l_in_index, l_in_call: BOOLEAN
			l_cur_index_str: STRING
			l_cur_index: INTEGER
			l_cur_fun: STRING
		do
			from
				create {LINKED_LIST[STRING]}Result.make
				l_pos := 1
			until
				l_pos > a_content.count
			loop
				if a_content.item (l_pos) = '{' then
					l_in_index := true
					create l_cur_index_str.make (3)
				elseif l_in_index and a_content.item (l_pos) = '}' then
					l_in_index := false
					l_cur_index := l_cur_index.to_integer

					if l_cur_index = a_princ_var_index and a_content.count>l_pos and a_content.item (l_pos+1) = '.' then
						l_in_call := true
						-- Skip over '.'
						l_pos := l_pos+1
						create l_cur_fun.make_empty
					end
				elseif l_in_index then
					l_cur_index_str.extend (a_content.item (l_pos))
				elseif l_in_call then
					if a_content.item (l_pos).is_alpha_numeric then
						l_cur_fun.extend (a_content.item (l_pos))
					else
						l_in_call := false
						Result.extend (l_cur_fun)
					end
				end
				l_pos := l_pos + 1
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
