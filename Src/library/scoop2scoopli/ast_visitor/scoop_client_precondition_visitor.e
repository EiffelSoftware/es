note
	description: "[
					Roundtrip visitor to process precondition clause
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PRECONDITION_VISITOR

inherit
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
		redefine
			make
		end

create
	make

feature -- Initialisation

	make (an_argument_object: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Initialisation with list of the separate internal argument.
		do
			Precursor (an_argument_object)

			assertions := create {SCOOP_CLIENT_PRECONDITIONS}.make
		end

feature -- Access

	process_precondition (l_as: REQUIRE_AS) is
		do
			if l_as /= Void then
				last_index := l_as.require_keyword_index
			end
			safe_process (l_as)
		end

feature {NONE} -- Parent implementation

	evaluate_assertion  is
			-- evaluates the processed tagged_as flags
		do
			if current_assertion.is_containing_separate_calls then
				-- assertion contains separate calls.
				current_preconditions.wait_conditions.extend (current_assertion)
			else
				-- assertion contains no separate call
				current_preconditions.non_separate_preconditions.extend (current_assertion)
			end
		end

	evaluate_expression is
			-- evaluates the processed expr flags
			-- needed when processing binary expression evaluation and lists.
		do
			-- evaluate is_separate_assertion flag
			if is_expr_separate_assertion then
				current_assertion.set_is_containing_separate_calls (is_expr_separate_assertion)
			end
		end

	evaluate_external_assertion_object (an_assertion_object: SCOOP_CLIENT_ASSERTIONS) is
			-- Evaluates the created assertion object after running through the internal parameters.
		local
			i: INTEGER
			l_precondition_object: SCOOP_CLIENT_PRECONDITIONS
			l_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			l_precondition_object ?= an_assertion_object
			if l_precondition_object /= Void then
				-- evaluate the result object of the visited calls of tuples, binary expressions
				-- and internal parameters

				if l_precondition_object.wait_conditions.count > 0 then
					-- analysed expression contains separate arguments
					current_assertion.set_is_containing_separate_calls (True)

				elseif l_precondition_object.non_separate_preconditions.count > 0 then
					-- analysed expression contains no separate arguments
					-- do nothing
				end

				debug ("SCOOP_CLIENT_ASSERTIONS_EXT")

					if l_precondition_object.wait_conditions.count > 0 then

						from
							i := 1
						until
							i > l_precondition_object.wait_conditions.count
						loop
								-- copy all calls
							l_assertion_object := l_precondition_object.wait_conditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

					if l_precondition_object.non_separate_preconditions.count > 0 then

						from
							i := 1
						until
							i > l_precondition_object.non_separate_preconditions.count
						loop
								-- copy all calls
							l_assertion_object := l_precondition_object.non_separate_preconditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

				end
			end
		end

	create_same_visitor: SCOOP_CLIENT_ASSERTION_EXPR_VISITOR is
			-- returns a new created visitor of the same type
		do
			Result := create {SCOOP_CLIENT_PRECONDITION_VISITOR}.make (arguments)
		end

feature {NONE} -- Implementation

	current_preconditions: SCOOP_CLIENT_PRECONDITIONS is
			-- container for new generated precondition lists.
		do
			Result ?= assertions
		end

note
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

end -- class SCOOP_CLIENT_PRECONDITION_VISITOR
