note
	description: "[
					Roundtrip visitor to create a non-separate postcondition wrapper in a client class, based on an original feature.
					A non-separate postcondition wrapper exists for an original feature with separate arguments. It checks the non-separate postcondition and the unseparated postcondition of the original feature. It also decreases the postcondition counters for the involved separate arguments.
					Each clause of the non-separate postcondition contains at least one call on a non-separate target and does not contain the old or the result keyword. The non-separate postcondition must be checked by the current processor, but it does not have to be checked right after the execution of the enclosing routine.
					Generated call chains operate on client objects.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_NSP_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_body_as
		end

create
	make

feature -- Access

	add_non_separate_postcondition_wrapper (l_as: BODY_AS)
			-- Add a non-separate postcondition wrapper for 'l_as'.
		do
			-- print feature name
			context.add_string (
				"%N%N%T" +
				feature_object.feature_name +
				{SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive +
				class_c.name.as_lower +
				{SCOOP_SYSTEM_CONSTANTS}.non_separate_postcondition_wrapper_name_additive
			)
			context.add_string (" ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Implementation

	process_body_as (l_as: BODY_AS)
		local
			i,j: INTEGER
			current_non_separate_postcondition_clause: SCOOP_CLIENT_ASSERTION_OBJECT
			separate_argument_occurrences_count: TUPLE[name: STRING; occurrences_count: INTEGER]
		do
			safe_process (l_as.internal_arguments)

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for non-separate postconditions of enclosing routine `" + feature_object.feature_name  + "'.")

			-- add 'do' and 'ensure' keyword
			context.add_string ("%N%T%Tdo%N%T%Tensure")

			-- add comment
			context.add_string (" -- Operations are expressed as postconditions to allow for switching them on and off.)")

			-- postcondition clause 'not unseparated_postconditions_left'
			context.add_string ("%N%T%T%Tnot unseparated_postconditions_left (" + feature_object.feature_name + "_scoop_separate_")
			context.add_string (class_c.name.as_lower + "_unseparated_postconditions)")

			from
				i := 1
			until
				i > feature_object.postconditions.non_separate_postconditions.count
			loop
				context.add_string ("%N%T%T%T")

				-- get assertion object
				current_non_separate_postcondition_clause := feature_object.postconditions.non_separate_postconditions.i_th (i)

				-- process postcondition
				last_index := current_non_separate_postcondition_clause.tagged_as.first_token (match_list).index - 1
				avoid_proxy_calls_in_call_chains := true
				safe_process (current_non_separate_postcondition_clause.tagged_as)
				avoid_proxy_calls_in_call_chains := false
				reset_current_levels_layer
				reset_current_object_tests_layer

				-- iterate over all separate arguments
				from
					j := 1
				until
					j > current_non_separate_postcondition_clause.separate_arguments_count
				loop
					-- get separate argument tuple
					separate_argument_occurrences_count := current_non_separate_postcondition_clause.i_th_separate_argument_occurrences_count (j)

					-- print decrease call
					context.add_string ("%N%T%T%T" + separate_argument_occurrences_count.name + ".decreased_postcondition_counter (" + separate_argument_occurrences_count.occurrences_count.out + ")")

					j := j + 1
				end

				i :=  i + 1
			end

			-- add 'end' keyword'
			context.add_string ("%N%T%Tend")
		end

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

end -- class SCOOP_CLIENT_FEATURE_NSP_VISITOR
