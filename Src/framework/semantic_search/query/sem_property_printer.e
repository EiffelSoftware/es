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

feature -- Basic operations

	process_property (a_property: EXPR_AS; a_replacements: HASH_TABLE [STRING, STRING])
			-- Process `a_property', make result available in `last_output'.
			-- `a_replacements' is a hash-table. Keys are expressions that appear in `a_property',
			-- values are the string that those expressions should be replaced with in `last_output'.
		local
			l_sorter: DS_QUICK_SORTER [STRING]
		do
			replacements := a_replacements
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
		do
			process_child (l_as.left, l_as, 1)
			output.append_string (ti_Space)
			l_operator := l_as.op_name.name
			if l_operator ~ "and" or l_operator ~ "and then" then
				l_operator := "AND"
			elseif l_operator ~ "or" or l_operator ~ "or else" then
				l_operator := "OR"
			elseif l_operator ~ "/=" then
				l_operator := "!="
			elseif l_operator ~ "~" then
				l_operator := "="
			elseif l_operator ~ "/~" then
				l_operator := "!="
			end
			output.append_string (l_operator)
			output.append_string (ti_Space)
			process_child (l_as.right, l_as, 3)
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

	process_void_as (l_as: VOID_AS)
		do
			output.append_string (integer_value_for_void)
		end

end
