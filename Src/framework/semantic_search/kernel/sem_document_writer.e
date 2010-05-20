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
			elseif attached {SEM_OBJECTS}a_queryable as l_obj then
				object_writer.write (l_obj, a_folder)
			else
				to_implement("")
			end
		end

feature {NONE} -- Specialized writers

	transition_writer: SEM_TRANSITION_WRITER
		once
			create Result
		end

	object_writer: SEM_OBJECTS_WRITER
		once
			create Result
		end

feature {NONE} -- Implementation

	queryable: SEM_QUERYABLE
			-- Queryable to be output

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

	ancestor_types (a_class_type: TYPE_A; a_processed: HASH_TABLE[BOOLEAN,INTEGER]): LIST[CL_TYPE_A]
			-- Ancestor-types of `a_class_type', use `a_processed' to filter duplicates
		require
			non_void: a_class_type /= void and a_processed /= void
			is_class_type: a_class_type.has_associated_class
		local
			l_ancestors: LIST[CL_TYPE_A]
			l_instantiated_type: CL_TYPE_A
		do
			create {LINKED_LIST[CL_TYPE_A]}Result.make
			l_ancestors := a_class_type.associated_class.parents

			from
				l_ancestors.start
			until
				l_ancestors.after
			loop
				if not a_processed[l_ancestors.item.class_id] then
					a_processed.extend (true, l_ancestors.item.class_id)
					l_instantiated_type := l_ancestors.item.instantiated_in (a_class_type)
					Result.extend (l_instantiated_type)
					Result.append (ancestor_types (l_instantiated_type, a_processed))
				end

				l_ancestors.forth
			end
		end

	abstract_types (a_type: TYPE_A; a_feature_list: LIST[STRING]): LIST[CL_TYPE_A]
			-- Get a list of abstract types of `a_type' that also contain the features in `a_feature_list'
		require
			is_class_type: a_type.is_full_named_type
		local
			l_feature: FEATURE_I
			l_ancestors: LIST[CL_TYPE_A]
			l_class: CLASS_C
			l_has_all: BOOLEAN
			l_feat_set_list: LINKED_LIST[ROUT_ID_SET]
		do
			l_class := a_type.associated_class
			l_ancestors := ancestor_types (a_type, create {HASH_TABLE[BOOLEAN,INTEGER]}.make(10))

			-- Get rout_id_set of all features in the original class
			from
				a_feature_list.start
				create l_feat_set_list.make
			until
				a_feature_list.after
			loop
				l_feature := l_class.feature_named (a_feature_list.item)

				if l_feature /= void then
					l_feat_set_list.extend (l_feature.rout_id_set)
				end

				a_feature_list.forth
			end

			-- Add all ancestors that have versions of all the features
			from
				l_ancestors.start
				create {LINKED_LIST[CL_TYPE_A]}Result.make
			until
				l_ancestors.after
			loop
				l_has_all := true
				from
					l_feat_set_list.start
				until
					l_feat_set_list.after or not l_has_all
				loop
					if l_ancestors.item.associated_class.feature_of_rout_id_set (l_feat_set_list.item) = void then
						l_has_all := false
					end
					l_feat_set_list.forth
				end
				if l_has_all then
					Result.extend(l_ancestors.item)
				end

				l_ancestors.forth
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

	abstracting_rewriter: SEM_ABSTRACTING_EXPRESSION_REWRITER
		once
			create Result.make
		end

	principal_variable: EPA_EXPRESSION
			-- The principal variable of this transition

	principal_variable_index: INTEGER
			-- The index of the principal variable

	abstract_principal_types: LIST[CL_TYPE_A]
			-- Abstract types of `principal_variable'

	abstracted_expression_strings (a_expression: EPA_EXPRESSION; a_principal_variable: EPA_EXPRESSION): LIST[STRING]
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (queryable.variables.count*2)
			l_replacements.compare_objects
			queryable.variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING]; a_context_type: detachable TYPE_A)
					local
						l_type: STRING
					do
						l_type := a_expr.resolved_type (a_context_type).name
						l_type.replace_substring_all (once "?", once "")
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, l_replacements, queryable.context_type))

			Result := abstracting_rewriter.abstracted_expression_texts (a_expression, a_principal_variable, abstract_principal_types, l_replacements)
		end

feature {NONE} -- Output

	buffer: STRING
			-- Buffer to store output content

	append_document_type (a_document_type: STRING)
			-- Append document type
		do
			append_field (document_type_field, default_boost, type_string, a_document_type)
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_pos: BOOLEAN)
			-- Append operands in `queryable' to `buffer'.
		local
			l_values: STRING
			l_pos: INTEGER
			l_abs_types: LIST[TYPE_A]
			l_context_type: detachable TYPE_A
		do
			if attached a_variables and then not a_variables.is_empty then
				l_context_type := queryable.context_type
				create l_values.make (128)
				from
					a_variables.start
				until
					a_variables.after
				loop
					l_pos := queryable.variable_position (a_variables.item_for_iteration)

					if l_pos = principal_variable_index then
						-- "principal" object
						-- add better way to get this ofc
						from
							l_abs_types := abstract_principal_types
							l_abs_types.start
						until
							l_abs_types.after
						loop
							l_values.append (once "{")
							l_values.append (cleaned_type_name (l_abs_types.item.name))
							if a_print_pos then
								l_values.append (once "}@")
								l_values.append (l_pos.out)
							else
								l_values.append (once "}")
							end
							l_values.append (field_value_separator)
							l_abs_types.forth
						end
					end

					l_values.append (once "{")
					l_values.append (cleaned_type_name (a_variables.item_for_iteration.resolved_type (l_context_type).name))
					if a_print_pos then
						l_values.append (once "}@")
						l_values.append (l_pos.out)
					else
						l_values.append (once "}")
					end

					a_variables.forth
					if not a_variables.after then
						l_values.append (field_value_separator)
					end
				end

				append_field (a_field, default_boost, type_string, l_values)
			end
		end

	append_state (a_state: EPA_STATE; a_field_prefix: STRING)
			-- Append `a_state' as contract into `buffer'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_transition: like queryable
			l_equation: EPA_EQUATION
			l_expr: EPA_EXPRESSION
			l_typed_expr: STRING
			l_anony_expr: STRING
			l_type_name: STRING
			l_value: EPA_EXPRESSION_VALUE

			l_abstract_exprs: LIST[STRING]
		do
			l_transition := queryable
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_equation := l_cursor.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				if l_value.is_boolean then
					l_type_name := type_boolean
				else
					l_type_name := type_integer
				end

				l_typed_expr := l_transition.typed_expression_text (l_expr)
				append_field (a_field_prefix + l_typed_expr, default_boost, l_type_name, l_value.out)

				-- print the typed expressions for all abstract types
				l_abstract_exprs := abstracted_expression_strings (l_expr, principal_variable)
				from
					l_abstract_exprs.start
				until
					l_abstract_exprs.after
				loop
					if not l_abstract_exprs.item.is_equal (l_typed_expr) then
						append_field (a_field_prefix + l_abstract_exprs.item, default_boost, l_type_name, l_value.out)
					end

					l_abstract_exprs.forth
				end

				l_anony_expr := l_transition.anonymous_expression_text (l_expr)
				append_field (a_field_prefix + l_anony_expr, default_boost, l_type_name, l_value.out)

				l_cursor.forth
			end
		end

	append_operand_positions (a_operands: EPA_HASH_SET [EPA_EXPRESSION]; a_field_name: STRING)
			-- Append inputs from `a_operands' to `buffer'.		
		local
			l_values: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_operands: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			i, c: INTEGER
		do
			create l_values.make (64)
			l_operands := queryable.variable_positions
			from
				i := 1
				c := a_operands.count
				l_cursor := a_operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_values.append (l_operands.item (l_cursor.item).out)
				if i < c then
					l_values.append (field_value_separator)
				end
				i := i + 1
				l_cursor.forth
			end
			append_field (a_field_name, default_boost, type_string, l_values)
		end

	append_field (a_name: STRING; a_boost: DOUBLE; a_type: STRING; a_value: STRING)
			-- Append field specified by `a_name' `a_boost', `a_type' and `a_value'
			-- into `buffer'.
		require
			is_type_valid: is_type_valid (a_type)
		do
			buffer.append (a_name)
			buffer.append_character ('%N')

			buffer.append (a_boost.out)
			buffer.append_character ('%N')

			buffer.append (a_type)
			buffer.append_character ('%N')

			buffer.append (a_value)
			buffer.append_character ('%N')

			buffer.append_character ('%N')
		end
feature {NONE} -- Constants

	default_boost: DOUBLE = 1.0
			-- Default boost value for a field

	type_boolean: STRING = "BOOLEAN"
			-- Type boolean

	type_integer: STRING = "INTEGER"
			-- Type integer

	is_type_valid (a_type: STRING): BOOLEAN
			-- Is `a_type' valid?
		do
			Result :=
				a_type ~ type_boolean or
				a_type ~ type_integer or
				a_type ~ type_string
		end

	type_string: STRING = "STRING"

	change_value_buffer: STRING
			-- Buffer to store change values

	max_integer: INTEGER = 10
			-- Max integer used in relaxed integer changes

	min_integer: INTEGER = -10
			-- Min integer used in relaxed integer changes
end
