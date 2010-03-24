note
	description: "[
					Roundtrip visitor to process feature assertions in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR

inherit
	SCOOP_CONTEXT_AST_PRINTER
		redefine
			process_body_as,
			process_routine_as
		end

--	SHARED_ERROR_HANDLER
--		export
--			{NONE} all
--		end

create
	make_with_context

feature -- Initialisation

	make_with_context (a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context
		end

feature -- Access

	process_feature_body (l_as: BODY_AS)
			-- Process `l_as'
		require
			feature_as_not_void: feature_as /= Void
			feature_object /= Void and then (feature_object.feature_name /= Void and feature_object.arguments /= Void)
		do
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

--	get_preconditions: SCOOP_CLIENT_PRECONDITIONS is
--			-- returns the preconditions object
--		do
--			Result := l_preconditions
--		end

--	get_postconditions: SCOOP_CLIENT_POSTCONDITIONS is
--			-- retunrs the postconditions object
--		do
--			Result := l_postconditions
--		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS)
		local
			r_as: ROUTINE_AS
		do
			r_as ?= l_as.content
			if r_as /= Void then
				safe_process (r_as)
			end
		end

	process_routine_as (l_as: ROUTINE_AS)
		local
			l_precondition_visitor: SCOOP_CLIENT_PRECONDITION_VISITOR
			l_postcondition_visitor: SCOOP_CLIENT_POSTCONDITION_VISITOR
		do
				-- visit precondition
			create l_precondition_visitor.make_with_default_context
			l_precondition_visitor.setup (parsed_class, match_list, True, True)
			l_precondition_visitor.analyze_precondition (l_as.precondition, feature_object.arguments)
			preconditions := l_precondition_visitor.preconditions

			debug ("SCOOP_CLIENT_ASSERTIONS")
				if preconditions /= Void then
					print_assertions_for_debugging (preconditions)
				end
			end

				-- visit postcondition
			create l_postcondition_visitor.make_with_default_context
			l_postcondition_visitor.setup (parsed_class, match_list, True, True)
			l_postcondition_visitor.analyze_postcondition (l_as.postcondition, feature_object.arguments)
			postconditions := l_postcondition_visitor.postconditions

			debug ("SCOOP_CLIENT_ASSERTIONS")
				if postconditions /= Void then
					print_assertions_for_debugging (postconditions)
				end
			end
		end

feature -- Debug

	print_assertions_for_debugging (a_assertions: SCOOP_CLIENT_ASSERTIONS)
			-- prints content for debugging
		local
			i: INTEGER
			test_context: ROUNDTRIP_CONTEXT
			l_preconditions: SCOOP_CLIENT_PRECONDITIONS
			l_postconditions: SCOOP_CLIENT_POSTCONDITIONS
		do
			debug ("SCOOP_CLIENT_ASSERTIONS")

				l_preconditions ?= a_assertions
				if l_preconditions /= Void then
					io.error.put_string ("%NSCOOP: SCOOP SEPARATE CLIENT, FEATURE [" + feature_object.feature_name + "] - ASSERTIONS: PRECONDITIONS")

					io.error.put_string ("%N%TWAIT_CONDITIONS:")
					from
						i := 1
					until
						i >  l_preconditions.wait_conditions.count
					loop
						test_context := safe_process_debug (l_preconditions.wait_conditions.i_th (i).tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (l_preconditions.wait_conditions.i_th (i), False)
						end

						i := i + 1
					end
					if l_preconditions.wait_conditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TNON_SEPARATE_PRECONDITIONS:")
					from
						i := 1
					until
						i >  l_preconditions.non_separate_preconditions.count
					loop
						test_context := safe_process_debug (l_preconditions.non_separate_preconditions.i_th (i).tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (l_preconditions.non_separate_preconditions.i_th (i), False)
						end

						i := i + 1
					end
					if l_preconditions.non_separate_preconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end
				end

				l_postconditions ?= a_assertions
				if l_postconditions /= Void then
					io.error.put_string ("%NSCOOP: SCOOP SEPARATE CLIENT, FEATURE [" + feature_object.feature_name + "] - ASSERTIONS: POSTCONDITIONS")

					io.error.put_string ("%N%TIMMEDIATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  l_postconditions.immediate_postconditions.count
					loop
						test_context := safe_process_debug (l_postconditions.immediate_postconditions.i_th (i).tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (l_postconditions.immediate_postconditions.i_th (i), True)
							print_separate_argument_list (l_postconditions.immediate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if l_postconditions.immediate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TNON_SEPARATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  l_postconditions.non_separate_postconditions.count
					loop
						test_context := safe_process_debug (l_postconditions.non_separate_postconditions.i_th (i).tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (l_postconditions.non_separate_postconditions.i_th (i), True)
							print_separate_argument_list (l_postconditions.non_separate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if l_postconditions.non_separate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TSEPARATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  l_postconditions.separate_postconditions.count
					loop
						test_context := safe_process_debug (l_postconditions.separate_postconditions.i_th (i).tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (l_postconditions.separate_postconditions.i_th (i), True)
							print_separate_argument_list (l_postconditions.separate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if l_postconditions.separate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end
				end
			end
		end

	print_detailed_assertion_object (assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT; is_postcondition: BOOLEAN)
			-- prints list to io.error
		do

			io.error.put_string ("%N%T%T - Elements: [")

				-- print out 'is_result_or_old' if it is a postcondition
			if is_postcondition then
				io.error.put_string ("is_result_or_old: ")
				io.error.put_string (assertion_object.is_containing_old_or_result.out)
				io.error.put_string ("; ")
			end

				-- print list of separate calls
			io.error.put_string ("separate: ")
			io.error.put_string (assertion_object.separate_calls)

				-- print list of non separate calls
			io.error.put_string (", non separate: ")
			io.error.put_string (assertion_object.non_separate_calls)

			io.error.put_string ("]")
		end

	print_separate_argument_list (assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT)
			-- prints list to io.error
		do
			io.error.put_string ("%N%T%T - Sep. Arguments (" + assertion_object.separate_arguments_count.out + "): ")
			if assertion_object.has_separate_arguments then
				io.error.put_string (assertion_object.separate_argument_list_as_string(True))
			else
				io.error.put_string ("none.")
			end
		end

feature -- Implementation

	preconditions: SCOOP_CLIENT_PRECONDITIONS
			-- result object of preconditions visitor

	postconditions: SCOOP_CLIENT_POSTCONDITIONS
			-- result object of postcondition visitor

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

end -- class SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR
