note
	description: "[
					Roundtrip visitor to create an individual separate postcondition wrapper in a client class, based on an original feature.
					An individual separate postcondition wrapper exists for an original feature with separate arguments. It checks the individual separate postcondition. It also decreases the postcondition counters for the involved separate arguments.
					An individual separate postcondition is a single clause that contains only calls on separate targets.
					Generated call chains operate on client objects.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ISP_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_formal_argu_dec_list_as,
			process_tagged_as
		end

create
	make

feature -- Access
	add_individual_separate_postcondition_wrapper (a_number: INTEGER; a_assertion: SCOOP_CLIENT_ASSERTION_OBJECT)
			-- Add an invididual separate postcondition wrapper with number 'a_number' and the assertion 'a_assertion'.
		do
			index := a_number
			assertion := a_assertion

			-- print feature name
			context.add_string ("%N%N%T")
			context.add_string (
				feature_object.feature_name +
				{SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive +
				class_c.name.as_lower +
				{SCOOP_SYSTEM_CONSTANTS}.individual_separate_postcondition_wrapper_name_additive +
				index.out + " "
			)

			-- process body
			process_body
		end

feature {NONE} -- Implementation
	process_body
		local
			i: INTEGER
		do
			-- process internal arguments
			add_formal_argument_list_as_actual_argument_list_with_prefix (feature_as.body, "caller_: SCOOP_SEPARATE_TYPE")

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for separate postcondition clause " + index.out + " of routine `" + feature_object.feature_name + "'.")

			-- add locals
			context.add_string ("%N%T%Tlocal%N%T%T%Taux: BOOLEAN")

			-- add locals for exception handling
			context.add_string ("%N%T%T%Tl_exception: POSTCONDITION_VIOLATION")
			context.add_string ("%N%T%T%Tl_exception_factory: EXCEPTION_MANAGER_FACTORY")

			-- add do keyword
			context.add_string ("%N%T%Tdo")

			-- add expression
			context.add_string ("%N%T%T%Tif ")

			-- process separate postcondition with prefix 'caller_'
			avoid_proxy_calls_in_call_chains := true
			safe_process (assertion.tagged_as)
			avoid_proxy_calls_in_call_chains := false
			reset_current_levels_layer
			reset_current_object_tests_layer

			-- then
			context.add_string ("%N%T%T%Tthen -- Postcondition clause holds.")

			-- iterate over all separate arguments
			from
				i := 1
			until
				i > assertion.separate_arguments_count
			loop
				context.add_string ("%N%T%T%T%Taux := " + assertion.i_th_separate_argument_occurrences_count (i).name)
				context.add_string (".decreased_postcondition_counter (" + assertion.i_th_separate_argument_occurrences_count (i).occurrences_count.out + ")")

				i := i + 1
			end

			-- else part
			context.add_string ("%N%T%T%Telse")

			-- raise a postcondition exception
			context.add_string ("%N%T%T%T%Tcreate l_exception")
			context.add_string ("%N%T%T%T%Tl_exception.set_message (%"Postcondition violation: ")
			safe_process (assertion.tagged_as.tag)
			context.add_string ("%")")
			context.add_string ("%N%T%T%T%Tcreate l_exception_factory")
			context.add_string ("%N%T%T%T%Tl_exception_factory.exception_manager.raise (l_exception)")

			-- end if part
			context.add_string ("%N%T%T%Tend")

			-- end body
			context.add_string ("%N%T%Tend")
		end

	add_formal_argument_list_as_actual_argument_list_with_prefix (l_as: BODY_AS; a_prefix: STRING)
			-- prints internal arguments as an actual argument list,
			-- sets 'a_prefix' as a fist as a first argument.
		do
			context.add_string ("(")

			-- set flags for processing internal arguments
			is_print_with_prefix := True

			-- set prefix
			context.add_string (a_prefix)

			if l_as.internal_arguments /= void then
				context.add_string ("; ")
				-- process internal arguments
				last_index := l_as.internal_arguments.first_token (match_list).index - 1
				safe_process (l_as.internal_arguments)
			end

			-- reset flags
			is_print_with_prefix := False

			context.add_string (")")
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			last_index := l_as.expr.first_token (match_list).index - 1
			safe_process (l_as.expr)
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			if not is_print_with_prefix then
				safe_process (l_as.lparan_symbol (match_list))
			else
				last_index := l_as.arguments.first_token (match_list).index - 1
			end
			safe_process (l_as.arguments)
			if not is_print_with_prefix then
				safe_process (l_as.rparan_symbol (match_list))
			end
		end

	is_print_with_prefix: BOOLEAN
			-- prints the 'formal_argu_dec_list_as' with a prefix as first argument.
			-- the argument list is processed without the l- and rparan_sympbol.

	assertion: SCOOP_CLIENT_ASSERTION_OBJECT
			-- current processed assertion

	index: INTEGER
			-- index of current separate postcondition

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_CLIENT_CONTEXT_AST_PRINTER
