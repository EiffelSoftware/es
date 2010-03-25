note
	description: "[
					Roundtrip visitor to create a separate postcondition wrapper in a client class, based on an original feature.
					A separate postcondition wrapper exists for an original feature with separate arguments. It asynchronously checks the individual separate postconditions that do not involve the current processor. The remaining individual separate postconditions are added to the unseparated postcondition.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_SP_VISITOR

inherit
	SCOOP_CLIENT_FEATURE_VISITOR
		redefine
			process_body_as
		end

create
	make

feature -- Access

	add_separate_postcondition_wrapper (l_as: BODY_AS)
			-- Add a separate postcondition wrapper for 'l_as'.
		do
			-- print feature name
			context.add_string (
				"%N%N%T" +
				feature_object.feature_name +
				{SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive +
				class_c.name.as_lower +
				{SCOOP_SYSTEM_CONSTANTS}.separate_postcondition_wrapper_name_additive
			)
			context.add_string (" ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Implementation

	process_body_as (l_as: BODY_AS)
		local
			i: INTEGER
			current_separate_postcondition_clause: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			safe_process (l_as.internal_arguments)

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for separate postconditions of enclosing routine `" + feature_object.feature_name + "'.")

			-- add 'do' keyword
			context.add_string ("%N%T%Tdo")

			-- add call
			context.add_string ("%N%T%T%Tcreate " + feature_object.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions.make")

			-- add 'ensure' keyword
			context.add_string ("%N%T%Tensure")
			is_processing_assertions := True
			-- add comment
			context.add_string (" -- Operations are expressed as postconditions to allow for switching them on and off.")

			from
				i := 1
			until
				i > feature_object.postconditions.separate_postconditions.count
			loop
				-- get assertion object
				current_separate_postcondition_clause := feature_object.postconditions.separate_postconditions.i_th (i)

				context.add_string ("%N%T%T%Tevaluated_as_separate_postcondition (")
				-- first argument: list of separate arguments
				context.add_string (current_separate_postcondition_clause.separate_argument_list_as_string (False))
				-- second argument: agent
				context.add_string (", agent " + feature_object.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, current_separate_postcondition_clause.i_th_separate_argument_occurrences_count (1).name)
				context.add_string (")")

				-- postcondition added_to_unseparated_postconditions
				context.add_string ("%N%T%T%T%Tor else added_to_unseparated_postconditions (" + feature_object.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions,")
				context.add_string ("%N%T%T%T%Tagent " + feature_object.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, "Current")

				context.add_string (")")
				i := i + 1
			end
			is_processing_assertions := False
			-- add 'end' keyword'
			context.add_string ("%N%T%Tend")
		end

	process_formal_argument_list_as_actual_argument_list_with_prefix (l_as: BODY_AS; a_prefix: STRING)
			-- prints internal arguments as an actual argument list,
			-- sets 'a_prefix' as a first argument.
		local
			i, j: INTEGER
			l_formal_arguments: EIFFEL_LIST[TYPE_DEC_AS]
			l_formal_arguments_group: TYPE_DEC_AS
		do
			context.add_string ("(")

			-- set prefix
			context.add_string (a_prefix)

			if l_as.internal_arguments /= void then
				last_index := l_as.internal_arguments.first_token (match_list).index
				from
					l_formal_arguments := l_as.internal_arguments.arguments
					i := 1
				until
					i > l_formal_arguments.count
				loop
					l_formal_arguments_group := l_formal_arguments.i_th (i)
					from
						j := 1
					until
						j > l_formal_arguments_group.id_list.count
					loop
						context.add_string (", ")
						context.add_string (l_formal_arguments_group.item_name (j))
						j := j + 1
					end
					i := i + 1
				end
				last_index := l_as.internal_arguments.last_token (match_list).index
			end

			context.add_string (")")
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

end -- class SCOOP_CLIENT_FEATURE_SP_VISITOR
