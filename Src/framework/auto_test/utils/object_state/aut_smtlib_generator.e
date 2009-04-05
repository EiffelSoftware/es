note
	description: "Summary description for {AUT_SMTLIB_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SMTLIB_GENERATOR

inherit
	AST_ITERATOR
		redefine
			process_binary_as,
			process_unary_as,
			process_bool_as,
			process_integer_as,
			process_void_as,
			process_current_as,
			process_access_feat_as
		end

	AUT_OBJECT_STATE_REQUEST_UTILITY

	AUT_CONTRACT_EXTRACTOR

	SHARED_SERVER

feature -- Access

	valid_object_state_proof_obligation (a_assertions: LIST [AUT_ASSERTION]; a_class: CLASS_C; a_state: HASH_TABLE [AUT_ABSTRACT_VALUE, STRING]): STRING is
			-- Proof obligation to show if `a_state' is a valid state for `a_class'.
			-- `a_state' is in the form [query_value, argument_less_query_name].
			-- The result is a string in SMT-LIB format which can be put into a theorem prover.
		require
			a_class_attached: a_class /= Void
			a_state_attached: a_state /= Void
		local
			l_invariant_formula: STRING
			l_extra_functions: STRING
			l_state_formula: STRING
		do
			create Result.make (2048)
			create output_buffer.make (2048)
			create functions.make (20)

			context_class := a_class
			register_functions (a_state)

			l_state_formula := state_formula (a_state)
			l_invariant_formula := invariant_formula (a_assertions)
			l_extra_functions := extra_functions

			Result.append ("(benchmark " + a_class.name + "_invariant%N")
			Result.append (":status sat%N")
			Result.append (":logic QF_LIA%N%N")
			Result.append (l_extra_functions)
			Result.append ("%N")
			Result.append (l_state_formula)
			Result.append ("%N")
			Result.append (":formula (%N")
			Result.append (l_invariant_formula)
			Result.append ("))%N")
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	state_formula (a_state: HASH_TABLE [AUT_ABSTRACT_VALUE, STRING]): STRING is
			-- Formula for `a_state'.
		do
			create Result.make (1024)
			from
				a_state.start
			until
				a_state.after
			loop
				Result.append (":assumption((= (")
				Result.append (a_state.key_for_iteration)
				Result.append (") (")
				Result.append (a_state.item_for_iteration.out)
				Result.append (")))%N")
				a_state.forth
			end
		end

	extra_functions: STRING is
			-- Extra functions from `functions'
		do
			create Result.make (1024)
			Result.append ("#Extra functions%N")
			from
				functions.start
			until
				functions.after
			loop
				Result.append (extra_function (functions.key_for_iteration, functions.item_for_iteration))
				functions.forth
			end
			Result.append ("%N")
		ensure
			result_attached: Result /= Void
		end

	extra_function (a_name: STRING; a_types: LIST [STRING]): STRING is
			-- ":extrafuns" part for function named `a_name' with types
			-- for its arguments and return type in `a_types'
		require
			a_name_attached: a_name /= Void
			a_types_valid: a_types /= Void and then not a_types.is_empty
		do
			create Result.make (128)
			Result.append (":extrafuns ((")
			Result.append (a_name)
			from
				a_types.start
			until
				a_types.after
			loop
				Result.append_character (' ')
				Result.append (a_types.item)
				a_types.forth
			end
			Result.append ("))%N")
		ensure
			result_attached: Result /= Void
		end


	invariant_formula (a_invariants: LIST [AUT_ASSERTION]): STRING is
			-- Formula for `a_invariants'.
			-- Every clause in `a_invariants' is anded together.
		do
			output_buffer.wipe_out
			output_buffer.append ("(and%N")
			from
				a_invariants.start
			until
				a_invariants.after
			loop
				current_written_class := a_invariants.item.written_class
				current_match_list := match_list_server.item (current_written_class.class_id)

					-- Append invariant assertion tag as comment.
--				output_buffer.append ("#%T")
--				output_buffer.append (a_invariants.item.tag_name)
--				output_buffer.append_character ('%N')

					-- Append invariant assertion.
				output_buffer.append ("%T(")
				a_invariants.item.tag.process (Current)
				output_buffer.append (")%N%N")

				a_invariants.forth
			end
			output_buffer.append (")%N")
			Result := output_buffer.twin
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Reporting

	report_feature (a_feature: FEATURE_I) is
			-- Report that `a_feature' is found in `a_assertion'.
		require
			a_id_attached: a_feature /= Void
		local
			l_types: LINKED_LIST [STRING]
			l_feat_name: STRING
		do
			l_feat_name := normalized_string (a_feature.feature_name)
			if not functions.has (l_feat_name) then
				create l_types.make
				if a_feature.argument_count > 0 then
					from
						a_feature.arguments.start
					until
						a_feature.arguments.after
					loop
						l_types.extend (embedded_type_name (a_feature.arguments.item))
						a_feature.arguments.forth
					end
				end
				l_types.extend (embedded_type_name (a_feature.type))
				report_function (l_feat_name, l_types)
			end
		end

	report_current is
			-- Report that "current" is found in some assertion.
		local
			l_types: LINKED_LIST [STRING]
		do
			if not functions.has (current_name) then
				create l_types.make
				l_types.extend (int_type_name)
				report_function (current_name, l_types)
			end
		end

	report_void is
			-- Report that "void" is found in some assertion.
		local
			l_types: LINKED_LIST [STRING]
		do
			if not functions.has (void_name) then
				create l_types.make
				l_types.extend (int_type_name)
				report_function (void_name, l_types)
			end
		end

	report_function (a_name: STRING; a_types: LIST [STRING]) is
			-- Report function with `a_name' and `a_types'.
			-- `a_types' is a list of types for arguments and return type
			-- of that feature.
		require
			a_name_attached: a_name /= Void
			a_types_attached: a_types /= Void
		do
			functions.force (a_types, a_name)
		end

	embedded_type_name (a_type: TYPE_A): STRING is
			-- Name of the embedded type for `a_type'.
		require
			a_type_attached: a_type /= Void
		do
			if a_type.is_boolean then
				Result := bool_type_name
			else
				Result := int_type_name
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	output_buffer: STRING;
			-- Buffer used to store generated formula

	current_written_class: CLASS_C
			-- Written class for current visited AST node

	current_match_list: LEAF_AS_LIST
			-- Match list of for current visited AST node

	context_class: CLASS_C
			-- Context class where assertions are viewed

	functions: HASH_TABLE [LIST [STRING], STRING]
			-- List of functions mentioned in assertions
			-- The key is the name of the function
			-- The value is a list of type names for arguments and
			-- return type of that function

feature{NONE} -- Constants

	current_name: STRING is "current"

	void_name: STRING is "void"

	int_type_name: STRING is "Int"

	bool_type_name: STRING is "bool"

feature{NONE} -- Process

	process_binary_as (l_as: BINARY_AS)
		local
			l_operator: STRING
			l_is_ne: BOOLEAN
		do
			output_buffer.append_character ('(')

				-- Get operator for current binary expression.
			l_operator := normalized_string (l_as.operator (current_match_list).text (current_match_list))
			if l_operator.is_equal ("and then") then
				l_operator := "and"
			elseif l_operator.is_equal ("or else") then
				l_operator := "or"
			end

			if l_operator.is_equal ("/=") then
				l_is_ne := True
				l_operator := "="
				output_buffer.append ("not (")
			end

			output_buffer.append (l_operator)
			output_buffer.append (" (")
			l_as.left.process (Current)
			output_buffer.append (") (")
			l_as.right.process (Current)
			output_buffer.append_character (')')
			output_buffer.append_character (')')
			if l_is_ne then
				output_buffer.append_character (')')
			end
		end

	process_unary_as (l_as: UNARY_AS)
		local
			l_operator: STRING
		do
			output_buffer.append_character ('(')
			output_buffer.append (normalized_string (l_as.operator (current_match_list).text (current_match_list)))
			output_buffer.append (" (")
			l_as.expr.process (Current)
			output_buffer.append ("))")
		end

	process_bool_as (l_as: BOOL_AS)
		do
			output_buffer.append (normalized_string (l_as.text (current_match_list)))
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			output_buffer.append (l_as.integer_32_value.out)
		end

	process_void_as (l_as: VOID_AS)
		do
			output_buffer.append (void_name)
			report_void
		end

	process_current_as (l_as: CURRENT_AS)
		do
			output_buffer.append (current_name)
			report_current
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: FEATURE_I
		do
			l_feature := final_feature (l_as.feature_name.name, current_written_class, context_class)
			check l_feature /= Void end
			report_feature (l_feature)
			output_buffer.append (normalized_string (l_feature.feature_name))
			if l_as.internal_parameters /= Void then
				output_buffer.append (" (")
				safe_process (l_as.internal_parameters)
				output_buffer.append_character (')')
			end
		end

	normalized_string (a_string: STRING): STRING is
			-- Normalized version of `a_string'.
			-- Normalization means remoing all leading and trailing
			-- spaces, and turning all letters in non-capital ones.
		require
			a_string_attached: a_string /= Void
		do
			Result := a_string.as_lower
			Result.left_adjust
			Result.right_adjust
		ensure
			result_attached: Result /= Void
		end

	register_functions (a_state: HASH_TABLE [AUT_ABSTRACT_VALUE, STRING]) is
			-- Register functions in `a_state' into `functions'.
			-- Fix me: This features is only suitable for argumentless boolean
			-- query for the moment. 30.03.2009 Jasonw
		require
			a_state_attached: a_state /= Void
		local
			l_types: LINKED_LIST [STRING]
		do
			from
				a_state.start
			until
				a_state.after
			loop
				create l_types.make
				l_types.extend (bool_type_name)
				functions.force (l_types, a_state.key_for_iteration)
				a_state.forth
			end
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
