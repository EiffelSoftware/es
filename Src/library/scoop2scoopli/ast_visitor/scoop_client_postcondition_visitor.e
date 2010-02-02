note
	description: "[
					Roundtrip visitor to process postcondition clause (`ENSURE_AS' node) 
					in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_POSTCONDITION_VISITOR

inherit
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
		redefine
			make,
			process_keyword_as,
			process_un_old_as,
			process_result_as,
			count_postcondition_arguments
		end

create
	make

feature -- Initialisation

	make (an_argument_object: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Initialisation with list of the separate internal argument.
		do
			Precursor (an_argument_object)

			assertions := create {SCOOP_CLIENT_POSTCONDITIONS}.make
		end

feature -- Access

	process_postcondition (l_as: ENSURE_AS) is
		do
			if l_as /= Void then
				last_index := l_as.ensure_keyword_index
			end
			safe_process (l_as)
		end

feature {NONE} -- Visitor implementation

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as'.
		do
				-- test for immediate postcondition
			if l_as.is_old_keyword or l_as.is_result_keyword then
				current_assertion.set_is_containing_old_or_result (True)
			end

				-- process keyword
			Precursor(l_as)
		end

	process_un_old_as (l_as: UN_OLD_AS) is
		do
				-- immediate postcondition!
			current_assertion.set_is_containing_old_or_result (True)

				-- process un_old_as
			Precursor(l_as)
		end

	process_result_as (l_as: RESULT_AS) is
		do
				-- immediate postcondition!
			current_assertion.set_is_containing_old_or_result (True)

				-- process result_as
			Precursor(l_as)
		end

feature {NONE} -- Parent implementations

	evaluate_assertion is
			-- evaluates the processed tagged_as flags
		do
			if current_assertion.is_containing_old_or_result then
				-- assertion contains a 'old' or 'result' reference
				current_postconditions.immediate_postconditions.extend (current_assertion)
			elseif current_assertion.is_containing_non_separate_calls then
				-- assertion contains a non separate call (on first leve)
				current_postconditions.non_separate_postconditions.extend (current_assertion)
			elseif current_assertion.is_containing_separate_calls then
				-- assertion contains a separate call (on some level)
				current_postconditions.separate_postconditions.extend (current_assertion)
			else
				-- other expressions like integer etc. -> non separate
				current_postconditions.non_separate_postconditions.extend (current_assertion)
			end
		end

	evaluate_expression is
			-- evaluates the processed expr flags
			-- needed when processing lists.
			-- tages just a logical 'or' of saved and new value.
			-- keep 'is_containing_void' and 'is_immediate'
		do
			-- evaluate is_containing_non_separate_call flag
			if is_expr_containing_non_separate_call then
				current_assertion.set_is_containing_non_separate_calls (is_expr_containing_non_separate_call)
			end

			-- evaluate is_separate_assertion flag
			if is_expr_separate_assertion then
				current_assertion.set_is_containing_separate_calls (is_expr_separate_assertion)
			end
		end

	evaluate_external_assertion_object (external_assertions: SCOOP_CLIENT_ASSERTIONS) is
			-- Evaluates the created assertion object after running through the internal parameters.
		local
			i: INTEGER
			l_postconditions: SCOOP_CLIENT_POSTCONDITIONS
			l_assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT
		do
			l_postconditions ?= external_assertions
			if l_postconditions /= Void then
				-- evaluate the result object of the visited calls of tuples and internal parameters
				-- there is only one assertion obejct in the list, so take the first.

				if l_postconditions.immediate_postconditions.count > 0 then
						-- analysed calls contain old or Result keyword
					current_assertion.set_is_containing_old_or_result (True)

					if l_postconditions.immediate_postconditions.first.has_separate_arguments then
						current_assertion.append_separate_argument_list (l_postconditions.immediate_postconditions.first.separate_argument_list)
					end

				elseif l_postconditions.non_separate_postconditions.count > 0 then
						-- analysed calls contain at least one non separate call (on first level)

						-- just ignore void expressions
					if not l_postconditions.non_separate_postconditions.first.is_containing_void then
						current_assertion.set_is_containing_non_separate_calls (True)

						if l_postconditions.non_separate_postconditions.first.has_separate_arguments then
							current_assertion.append_separate_argument_list (l_postconditions.non_separate_postconditions.first.separate_argument_list)
						end
					end

				elseif l_postconditions.separate_postconditions.count > 0 then
						-- analysed calls contain separate calls (on some leve)
					current_assertion.set_is_containing_separate_calls (True)

					if l_postconditions.separate_postconditions.first.has_separate_arguments then
						current_assertion.append_separate_argument_list (l_postconditions.separate_postconditions.first.separate_argument_list)
					end
				else
					-- other expression like integers.
					current_assertion.set_is_containing_non_separate_calls (True)
				end

				debug ("SCOOP_CLIENT_ASSERTIONS_EXT")

						-- copy all immediate postcondition calls
					if l_postconditions.immediate_postconditions.count > 0 then
						from
							i := 1
						until
							i > l_postconditions.immediate_postconditions.count
						loop
								-- copy all calls
							l_assertion_object := l_postconditions.immediate_postconditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

						-- copy all non separate postcondition calls
					if l_postconditions.non_separate_postconditions.count > 0 then
						from
							i := 1
						until
							i > l_postconditions.non_separate_postconditions.count
						loop
								-- copy all calls
							l_assertion_object := l_postconditions.non_separate_postconditions.i_th (i)
							current_assertion.calls.append (l_assertion_object.calls)
							i := i + 1
						end
					end

						-- copy all separate postcondition calls
					if l_postconditions.separate_postconditions.count > 0 then
						from
							i := 1
						until
							i > l_postconditions.separate_postconditions.count
						loop
								-- copy all calls
							l_assertion_object := l_postconditions.separate_postconditions.i_th (i)
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
			Result := create {SCOOP_CLIENT_POSTCONDITION_VISITOR}.make (arguments)
		end

	count_postcondition_arguments(an_argument_name: STRING) is
			-- counts the separate argument
		do
			-- increase counter in argument list
			arguments.count_separate_argument (an_argument_name)

			-- increase counter in assertion object
			current_assertion.count_separate_argument_occurrence (an_argument_name, 1)
		end


feature {NONE} -- Implementation

	current_postconditions: SCOOP_CLIENT_POSTCONDITIONS is
			-- container for new generated postcondition lists.
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

end -- class SCOOP_CLIENT_POSTCONDITION_VISITOR
