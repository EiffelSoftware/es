note
	description: "[
					Roundtrip visitor to process non-separate postconditions of 
					enclosing routines in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
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
								class_c.name.as_lower + "_non_separate_postcondition ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			i,j: INTEGER
			an_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
			a_tuple: TUPLE[argument_name: STRING; occurrence: INTEGER]
		do
			safe_process (l_as.internal_arguments)

			-- add 'is' keyword
			context.add_string (" is")

			-- add comment
			context.add_string ("%N%T%T%T-- Wrapper for non-separate postconditions of enclosing routine `" + fo.feature_name  + "'.")

			-- add 'do' and 'ensure' keyword
			context.add_string ("%N%T%Tdo%N%T%Tensure")

			-- add comment
			context.add_string (" -- Operations are expressed as postconditions to allow for switching them on and off.)")

			-- postcondition clause 'not unseparated_postconditions_left'
			if not fo.postconditions.separate_postconditions.is_empty then
				context.add_string ("%N%T%T%Tnot unseparated_postconditions_left (" + fo.feature_name + "_scoop_separate_")
				context.add_string (class_c.name.as_lower + "_unseparated_postconditions)")
			end

			from
				i := 1
			until
				i > fo.postconditions.non_separate_postconditions.count
			loop
				context.add_string ("%N%T%T%T")

				-- get assertion object
				an_assertion_object := fo.postconditions.non_separate_postconditions.i_th (i)

				-- process postcondition
				last_index := an_assertion_object.tagged_as.first_token (match_list).index - 1
				safe_process (an_assertion_object.tagged_as)

				-- iterate all separate argumetns
				from
					j := 1
				until
					j > an_assertion_object.separate_argument_count
				loop
					-- get separate argument tuple
					a_tuple := an_assertion_object.i_th_separate_argument_tuple (j)

					-- print decrease call
					context.add_string ("%N%T%T%T" + a_tuple.argument_name + ".decreased_postcondition_counter (" + a_tuple.occurrence.out + ")")

					j := j + 1
				end

				i :=  i + 1
			end

			-- add 'end' keyword'
			context.add_string ("%N%T%Tend")
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

end -- class SCOOP_CLIENT_FEATURE_NSP_VISITOR
