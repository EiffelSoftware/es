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

	write (a_queryable: SEM_QUERYABLE; a_folder: detachable STRING)
			-- Output `a_queryable' into a file in `a_folder'
		do
			-- delegate
			if attached {SEM_TRANSITION}a_queryable as l_trans then
				transition_writer.write (l_trans, a_folder)
				last_file_path := transition_writer.last_file_path
			elseif attached {SEM_OBJECTS}a_queryable as l_obj then
				object_writer.write (l_obj, a_folder)
				last_file_path := object_writer.last_file_path
			else
				to_implement("")
			end
		end

	set_boost_function (a_boost_function: like boost_function)
			-- Set `boost_function' to `a_boost_function'.
		do
			boost_function := a_boost_function
			transition_writer.set_boost_function (boost_function)
			object_writer.set_boost_function (boost_function)
		ensure
			boost_function_set: boost_function = a_boost_function
		end

feature -- Access

	last_document: STRING
			-- Content of last written document

	last_file_path: STRING
			-- Full path of last created document

	boost_function: detachable FUNCTION[ANY, TUPLE[SEM_QUERYABLE, STRING, EPA_EQUATION], REAL] assign set_boost_function

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
		local
			l_feature: FEATURE_I
			l_ancestors: LIST[CL_TYPE_A]
			l_class: CLASS_C
			l_has_all: BOOLEAN
			l_feat_set_list: LINKED_LIST[ROUT_ID_SET]
		do
			l_class := a_type.associated_class
			create {LINKED_LIST[CL_TYPE_A]}Result.make

			if l_class /= void then
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
					l_cur_index := l_cur_index_str.to_integer

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
			l_abstract_types: like abstract_principal_types
			l_calls: like calls_on_principal_variable
			l_princ_var: like a_principal_variable
			l_princ_var_index: like principal_variable_index
		do
			create l_replacements.make (queryable.variables.count*2)
			l_replacements.compare_objects
			queryable.variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING]; a_context_type: detachable TYPE_A)
					local
						l_type: STRING
					do
						l_type := cleaned_type_name (a_expr.resolved_type (a_context_type).name)
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, l_replacements, queryable.context_type))

			if a_principal_variable = void then
				if attached {EXPR_CALL_AS} a_expression.ast as l_expr_call and then attached {NESTED_AS} l_expr_call.call as l_nested then
					-- Principal variable = target of call
					l_princ_var := queryable.variable_by_name (l_nested.target.access_name)
					l_princ_var_index := queryable.variable_position (l_princ_var)
					l_calls := calls_on_principal_variable (queryable.anonymous_expression_text (a_expression), l_princ_var_index)
					l_abstract_types := abstract_types (l_princ_var.resolved_type (queryable.context_type), l_calls)
					Result := abstracting_rewriter.abstracted_expression_texts (a_expression, l_princ_var, l_abstract_types, l_replacements)
				else
					Result := equality_based_abstraction (a_expression.ast)
				end
			else
				if attached {EXPR_CALL_AS} a_expression.ast or attached {NESTED_AS} a_expression.ast then
					Result := abstracting_rewriter.abstracted_expression_texts (a_expression, a_principal_variable, abstract_principal_types, l_replacements)
				else
					Result := equality_based_abstraction (a_expression.ast)
				end
			end
		end

	equality_based_abstraction (a_expr: EXPR_AS): LINKED_LIST [STRING]
			-- Abstracted expressions for `a_expr' if and only if
			-- `a_expr' is "a = b", "a /= b", "a ~ b" or "a /~ b".
			-- Otherwise, return an empty list.
		local
			l_expr: STRING
		do
			create Result.make
			if
				attached {BIN_EQ_AS} a_expr or else
				attached {BIN_NE_AS} a_expr or else
				attached {BIN_TILDE_AS} a_expr or else
				attached {BIN_NOT_TILDE_AS} a_expr
			then
				if attached {BINARY_AS} a_expr as l_bin_as then
					create l_expr.make (24)
					l_expr.append (once "{ANY} ")
					l_expr.append (l_bin_as.op_name.name)
					l_expr.append (once " {ANY}")
					Result.extend (l_expr)
				end
			end
		end

	is_simple_property (a_expr: EPA_EXPRESSION): BOOLEAN
			-- Is `a_expr' a simple property of the form a = b or a feature call
		do
			Result :=
				is_simple_expression (a_expr.ast)
		end

	is_simple_expression (a_expr: EXPR_AS): BOOLEAN
			-- Is `a_expr' simple?
		do
			Result :=
				attached {EXPR_CALL_AS}a_expr or else
				is_binary_expression_simple (a_expr) or else
				is_negation_expression_simple (a_expr)
		end

	is_negation_expression_simple (a_expr: EXPR_AS): BOOLEAN
			-- Is `a_expr' a simple expression starting with a "not"?
		do
			if attached {UN_NOT_AS} a_expr as l_negation then
				Result := is_simple_expression (l_negation.expr)
			end
		end

	is_binary_expression_simple (a_binary_expr: EXPR_AS): BOOLEAN
			-- Is `a_binary_expr' simple?
		do
			if
				attached {BIN_EQ_AS} a_binary_expr or else
				attached {BIN_NE_AS} a_binary_expr or else
				attached {BIN_TILDE_AS} a_binary_expr or else
				attached {BIN_NOT_TILDE_AS} a_binary_expr
			then
				if attached {BINARY_AS} a_binary_expr as l_bin_as then
					Result :=
						is_expr_simple (l_bin_as.left) and then
						is_expr_simple (l_bin_as.right)
				end
			end
		end

	is_expr_simple (a_expr_as: EXPR_AS): BOOLEAN
			-- Is `a_expr_as' simple?
		do
			Result :=
				attached {ACCESS_AS} a_expr_as or else
				attached {EXPR_CALL_AS} a_expr_as
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
			l_cursor: DS_HASH_SET_CURSOR[EPA_EXPRESSION]
		do
			if attached a_variables and then not a_variables.is_empty then
				l_context_type := queryable.context_type
				create l_values.make (128)
				from
					l_cursor := a_variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_pos := queryable.variable_position (l_cursor.item)

					if l_pos = principal_variable_index then
						-- "principal" object
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
					l_values.append (cleaned_type_name (l_cursor.item.resolved_type (l_context_type).name))
					if a_print_pos then
						l_values.append (once "}@")
						l_values.append (l_pos.out)
					else
						l_values.append (once "}")
					end

					l_cursor.forth
					if not l_cursor.after then
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
			l_current_boost: DOUBLE
		do
			l_transition := queryable
			from
				l_cursor := a_state.new_cursor
				l_current_boost := default_boost
				l_cursor.start
			until
				l_cursor.after
			loop
				l_equation := l_cursor.item
				l_expr := l_equation.expression

				if attached boost_function then
					boost_function.call ([queryable, a_field_prefix, l_equation])
					l_current_boost := boost_function.last_result
				end

				-- Only continue if the expression represents a simple property
				if is_simple_property(l_expr) then
					l_value := l_equation.value
					if l_value.is_boolean then
						l_type_name := type_boolean
					elseif l_value.is_integer then
						l_type_name := type_integer
					elseif l_value.is_reference then
						l_type_name := type_reference
					elseif l_value.is_void then
						l_type_name := type_void
					elseif l_value.is_nonsensical then
						l_type_name := type_nonsensical
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
							append_field (a_field_prefix + l_abstract_exprs.item, l_current_boost, l_type_name, l_value.out)
						end

						l_abstract_exprs.forth
					end

					l_anony_expr := l_transition.anonymous_expression_text (l_expr)
					append_field (a_field_prefix + l_anony_expr, l_current_boost, l_type_name, l_value.out)
				end

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
		local
			l_field: STRING
		do
			create l_field.make (128)

			l_field.append (a_name)
			l_field.append_character ('%N')

			l_field.append (a_boost.out)
			l_field.append_character ('%N')

			l_field.append (a_type)
			l_field.append_character ('%N')

			l_field.append (a_value)
			l_field.append_character ('%N')

			l_field.append_character ('%N')

			if not added_fields.has (l_field) then
				added_fields.force_last (l_field)
				buffer.append (l_field)
			end
		end

	added_fields: DS_HASH_SET [STRING]
			-- Set of fields that are already added,
			-- used for duplication detection.

feature {NONE} -- Constants

	default_boost: DOUBLE = 1.0
			-- Default boost value for a field

	type_boolean: STRING = "BOOLEAN"
			-- Type boolean

	type_integer: STRING = "INTEGER"
			-- Type integer

	type_reference: STRING = "REFERENCE"

	type_void: STRING = "VOID"

	type_nonsensical: STRING = "NONSENSICAL"

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
