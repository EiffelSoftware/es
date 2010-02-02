note
	description: "[
					Roundtrip visitor to process separate postconditions of enclosing routine
					in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_SP_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			process_body_as
		end

	SCOOP_WORKBENCH

create
	make

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			l_fo_not_void: l_fo /= Void
			l_fo_preconditions_not_void: l_fo.preconditions /= Void
			l_fo_postconditions_not_void: l_fo.postconditions /= Void
		do
			fo := l_fo

			-- print feature name
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_" +
								class_c.name.as_lower + "_separate_postcondition ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			i: INTEGER
			an_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			safe_process (l_as.internal_arguments)

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for separate postconditions of enclosing routine `" + fo.feature_name + "'.")

			-- add 'do' keyword
			context.add_string ("%N%T%Tdo")

			-- add call
			context.add_string ("%N%T%T%Tcreate " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions.make")

			-- add 'ensure' keyword
			context.add_string ("%N%T%Tensure")

			-- add comment
			context.add_string (" -- Operations are expressed as postconditions to allow for switching them on and off.")

			from
				i := 1
			until
				i > fo.postconditions.separate_postconditions.count
			loop
				-- get assertion object
				an_assertion_object := fo.postconditions.separate_postconditions.i_th (i)

				context.add_string ("%N%T%T%Tevaluated_as_separate_postcondition (")
				-- first argument: list of separate arguments
				context.add_string (an_assertion_object.separate_argument_list_as_string (False))
				-- second argument: agent
				context.add_string (", agent " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, an_assertion_object.i_th_separate_argument_tuple (1).argument_name)
				context.add_string (")")

				-- postcondition added_to_unseparated_postconditions
				context.add_string ("%N%T%T%T%Tor else added_to_unseparated_postconditions (" + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_unseparated_postconditions,")
				context.add_string ("%N%T%T%T%Tagent " + fo.feature_name + "_scoop_separate_" + class_c.name.as_lower + "_spc_" + i.out + " ")
				process_formal_argument_list_as_actual_argument_list_with_prefix (l_as, "Current")

				context.add_string (")")
				i := i + 1
			end

			-- add 'end' keyword'
			context.add_string ("%N%T%Tend")
		end

	process_formal_argument_list_as_actual_argument_list_with_prefix (l_as: BODY_AS; a_prefix: STRING) is
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

feature {NONE} -- Implementation
	fo: SCOOP_CLIENT_FEATURE_OBJECT
			-- feature object of current processed feature.

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
