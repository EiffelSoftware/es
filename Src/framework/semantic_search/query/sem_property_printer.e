note
	description: "Summary description for {SEM_PROPERTY_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_PROPERTY_PRINTER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_access_feat_as,
			process_bin_tilde_as,
			process_bin_not_tilde_as,
			process_bool_as,
			process_binary_as,
			process_nested_as,
			process_void_as
		end

	EPA_UTILITY

	SEM_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create internal_output.make
			make_with_output (internal_output)
		end

feature -- Access

	last_output: STRING
			-- Last output from `process_property'

	queryable_partitions: TUPLE [variables: HASH_TABLE [INTEGER, INTEGER]; properties: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]]
			-- Queryable partitions

	context_class: CLASS_C
			-- Context class

	feature_: FEATURE_I
			-- Feature

feature -- Basic operations

	process_property (a_property: EXPR_AS; a_replacements: HASH_TABLE [STRING, STRING]; a_type_of_replacements: HASH_TABLE [TYPE_A, STRING]; a_queryable_partitions: like queryable_partitions; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Process `a_property', make result available in `last_output'.
			-- `a_replacements' is a hash-table. Keys are expressions that appear in `a_property',
			-- values are the string that those expressions should be replaced with in `last_output'.
		local
			l_sorter: DS_QUICK_SORTER [STRING]
		do
			context_class := a_class
			feature_ := a_feature
			replacements := a_replacements
			type_of_replacements := a_type_of_replacements
			queryable_partitions := a_queryable_partitions
			create sorted_expressions.make (replacements.count)
			across replacements as l_replacements loop
				sorted_expressions.force_last (l_replacements.key)
			end
			create l_sorter.make (
				create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (
					agent (a, b: STRING): BOOLEAN
						do
							Result := a.count > b.count
						end))
			l_sorter.sort (sorted_expressions)

			internal_output.reset
			a_property.process (Current)
			last_output := internal_output.string_representation
		end

feature{NONE} -- Implementation

	replacements: HASH_TABLE [STRING, STRING]
			-- Replacements

	type_of_replacements: HASH_TABLE [TYPE_A, STRING]
			-- Types of `replacements'

	sorted_expressions: DS_ARRAYED_LIST [STRING]
			-- Expression strings reversed sorted according to their length

	internal_output: ETR_AST_STRING_OUTPUT
			-- Internal output

	is_in_object_equal_comparison: BOOLEAN
			-- Is Current processing object equal comparison?

feature{NONE} -- Process

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			check_as (l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			check_as (l_as)
--			process_child (l_as.target, l_as, 1)
--			output.append_string (ti_dot)
--			process_child (l_as.message, l_as, 2)
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			is_in_object_equal_comparison := True
			process_binary_as (l_as)
			is_in_object_equal_comparison := False
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			is_in_object_equal_comparison := True
			process_binary_as (l_as)
			is_in_object_equal_comparison := False
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if l_as.value then
				output.append_string (once "1")
			else
				output.append_string (once "0")
			end
		end

	process_binary_as (l_as: BINARY_AS)
		local
			l_operator: STRING
			l_left_ast, l_right_ast: EXPR_AS
			l_left: EPA_AST_EXPRESSION
			l_right: EPA_AST_EXPRESSION
			l_left_type, l_right_type: TYPE_A
			l_left_text, l_right_text: STRING
		do
			output.append_string ("(")
			l_operator := l_as.op_name.name

			if l_operator ~ "=" or l_operator ~ "/=" or l_operator ~ "~" or l_operator ~ "/~" then
				l_left_ast := ast_without_surrounding_paranthesis (l_as.left)
				l_right_ast := ast_without_surrounding_paranthesis (l_as.right)
				if is_in_sorted_expressions (l_left_ast) and then is_in_sorted_expressions (l_right_ast) then
					l_left_text := text_from_ast (l_left_ast)
					l_right_text := text_from_ast (l_right_ast)
					l_left_type := type_of_replacements.item (l_left_text)
					l_right_type := type_of_replacements.item (l_right_text)
					if
						l_left_type /= Void and then
						l_right_type /= Void and then
						not (l_left_type.is_integer or l_left_type.is_boolean) and then
						not (l_right_type.is_integer or l_right_type.is_boolean)
					then
						output.append_string (replacements.item (l_left_text))
						output.append_string (once ".qry_id = ")
						output.append_string (replacements.item (l_right_text))
						output.append_string (once ".qry_id AND ")

						output.append_string (replacements.item (l_left_text))
						output.append_string (once ".value_type_kind = 0 AND ")
						output.append_string (replacements.item (l_right_text))
						output.append_string (once ".value_type_kind = 0 AND ")
					end
				end
			end

			process_child (l_as.left, l_as, 1)
			output.append_string (ti_Space)

			if l_operator ~ once "and" or l_operator ~ once "and then" then
				l_operator := once "AND"
			elseif l_operator ~ once "or" or l_operator ~ once "or else" then
				l_operator := once "OR"
			elseif l_operator ~ once "/=" then
				l_operator := once "!="
			elseif l_operator ~ once "~" then
				l_operator := once "="
			elseif l_operator ~ once "/~" then
				l_operator := once "!="
			elseif l_operator ~ once "//" then
				l_operator := once "/"
			elseif l_operator ~ once "\\" then
				l_operator := once "%%"
			end
			output.append_string (l_operator)
			output.append_string (ti_Space)
			process_child (l_as.right, l_as, 3)
			output.append_string (")")
		end

	is_binary_condition_needed (l_as: BINARY_AS): BOOLEAN
			-- Is `l_as' needed?
		local
			l_left, l_right: EPA_AST_EXPRESSION
			l_left_part, l_right_part: INTEGER
			l_operator: STRING
		do
			Result := True
			l_operator := l_as.op_name.name
			if l_operator ~ once "=" or l_operator ~ once "/=" or l_operator ~ once "~" or l_operator ~ once "/~" then
				create l_left.make_with_feature (context_class, feature_, ast_without_surrounding_paranthesis (l_as.left), context_class)
				create l_right.make_with_feature (context_class, feature_, ast_without_surrounding_paranthesis (l_as.right), context_class)
				l_left_part := queryable_partition_for_expression (l_left)
				if l_left_part >= 0 then
					l_right_part := queryable_partition_for_expression (l_right)
					if l_right_part >= 0 then
						if l_left_part /= l_right_part then
							Result := False
						end
					end
				end
			end
		end

	queryable_partition_for_expression (a_expression: EPA_EXPRESSION): INTEGER
			-- Queryable partition ID for `a_expression'
			-- Return -1 if not found.
		local
			l_operands: like operands_of_feature
		do
			l_operands := operands_of_feature (feature_)
			Result := - 1
			queryable_partitions.variables.search (l_operands.item (a_expression.text))
			if queryable_partitions.variables.found then
				Result := queryable_partitions.variables.found_item
			end

			if Result = -1 then
				queryable_partitions.properties.search (a_expression)
				if queryable_partitions.properties.found then
					Result := queryable_partitions.properties.found_item
				end
			end
		end

	check_as (l_as: AST_EIFFEL)
		local
			l_text: STRING
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_done: BOOLEAN
		do
			l_text := text_from_ast (l_as)

			from
				l_cursor := sorted_expressions.new_cursor
				l_cursor.start
			until
				l_cursor.after or else l_done
			loop
				if l_cursor.item ~ l_text then
					l_done := True
				else
					l_cursor.forth
				end
			end
			if l_done then
				output.append_string (replacements.item (l_cursor.item))
				if is_in_object_equal_comparison then
					output.append_string (once ".equal_value")
				else
					output.append_string (once ".value")
				end
			else
				output.append_string (l_text)
			end
		end

	is_in_sorted_expressions (l_as: AST_EIFFEL): BOOLEAN
			-- Is `l_as' in `sorted_expressions'?
		local
			l_text: STRING
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			l_text := text_from_ast (l_as)
			from
				l_cursor := sorted_expressions.new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result
			loop
				if l_cursor.item ~ l_text then
					Result := True
				else
					l_cursor.forth
				end
			end
		end

	process_void_as (l_as: VOID_AS)
		do
			output.append_string (integer_value_for_void)
		end

end
