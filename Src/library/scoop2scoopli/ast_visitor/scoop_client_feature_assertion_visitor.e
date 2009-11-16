indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_ASSERTION_VISITOR}."
	author: ""
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
	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

create
	make_with_context

feature -- Initialisation

	make_with_context(a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context
		end

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			feature_as_not_void: feature_as /= Void
			l_fo_arguments_not_void: l_fo.arguments /= Void
			l_fo_feature_name_not_void: l_fo.feature_name /= Void
		do
			fo := l_fo

			last_index := l_as.start_position
			safe_process (l_as)
		end

	get_preconditions: SCOOP_CLIENT_PRECONDITIONS is
			-- returns the preconditions object
		do
			Result := l_preconditions
		end

	get_postconditions: SCOOP_CLIENT_POSTCONDITIONS is
			-- retunrs the postconditions object
		do
			Result := l_postconditions
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			r_as: ROUTINE_AS
		do
			r_as ?= l_as.content
			if r_as /= Void then
				safe_process (r_as)
			end
		end

	process_routine_as (l_as: ROUTINE_AS) is
		local
			l_precondition_visitor: SCOOP_CLIENT_PRECONDITION_VISITOR
			l_postcondition_visitor: SCOOP_CLIENT_POSTCONDITION_VISITOR
		do
				-- visit precondition
			create l_precondition_visitor.make (fo.arguments)
			l_precondition_visitor.setup (parsed_class, match_list, true, true)
			l_precondition_visitor.process_precondition (l_as.precondition)
			l_preconditions ?= l_precondition_visitor.get_assertion_object

			debug ("SCOOP_CLIENT_ASSERTIONS")
				if l_preconditions /= Void then
					print_assertions_for_debugging (l_preconditions)
				end
			end

				-- visit postcondition
			create l_postcondition_visitor.make (fo.arguments)
			l_postcondition_visitor.setup (parsed_class, match_list, true, true)
			l_postcondition_visitor.process_postcondition (l_as.postcondition)
			l_postconditions ?= l_postcondition_visitor.get_assertion_object

			debug ("SCOOP_CLIENT_ASSERTIONS")
				if l_postconditions /= Void then
					print_assertions_for_debugging (l_postconditions)
				end
			end
		end

feature -- Debug

	print_assertions_for_debugging (assertions: SCOOP_CLIENT_ASSERTIONS) is
			-- prints content for debugging
		local
			i: INTEGER
			test_context: ROUNDTRIP_CONTEXT
			preconditions: SCOOP_CLIENT_PRECONDITIONS
			postconditions: SCOOP_CLIENT_POSTCONDITIONS
		do
			debug ("SCOOP_CLIENT_ASSERTIONS")

				preconditions ?= assertions
				if preconditions /= Void then
					io.error.put_string ("%NSCOOP: SCOOP SEPARATE CLIENT, FEATURE [" + fo.feature_name + "] - ASSERTIONS: PRECONDITIONS")

					io.error.put_string ("%N%TWAIT_CONDITIONS:")
					from
						i := 1
					until
						i >  preconditions.wait_conditions.count
					loop
						test_context := safe_process_debug (preconditions.wait_conditions.i_th (i).get_tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (preconditions.wait_conditions.i_th (i), false)
						end

						i := i + 1
					end
					if preconditions.wait_conditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TNON_SEPARATE_PRECONDITIONS:")
					from
						i := 1
					until
						i >  preconditions.non_separate_preconditions.count
					loop
						test_context := safe_process_debug (preconditions.non_separate_preconditions.i_th (i).get_tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (preconditions.non_separate_preconditions.i_th (i), false)
						end

						i := i + 1
					end
					if preconditions.non_separate_preconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end
				end

				postconditions ?= assertions
				if postconditions /= Void then
					io.error.put_string ("%NSCOOP: SCOOP SEPARATE CLIENT, FEATURE [" + fo.feature_name + "] - ASSERTIONS: POSTCONDITIONS")

					io.error.put_string ("%N%TIMMEDIATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  postconditions.immediate_postconditions.count
					loop
						test_context := safe_process_debug (postconditions.immediate_postconditions.i_th (i).get_tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (postconditions.immediate_postconditions.i_th (i), true)
							print_separate_argument_list (postconditions.immediate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if postconditions.immediate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TNON_SEPARATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  postconditions.non_separate_postconditions.count
					loop
						test_context := safe_process_debug (postconditions.non_separate_postconditions.i_th (i).get_tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (postconditions.non_separate_postconditions.i_th (i), true)
							print_separate_argument_list (postconditions.non_separate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if postconditions.non_separate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end

					io.error.put_string ("%N%TSEPARATE_POSTCONDITIONS:")
					from
						i := 1
					until
						i >  postconditions.separate_postconditions.count
					loop
						test_context := safe_process_debug (postconditions.separate_postconditions.i_th (i).get_tagged_as)
						io.error.put_string ("%N%T%T" + i.out + ": " + test_context.string_representation)

						debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
							print_detailed_assertion_object (postconditions.separate_postconditions.i_th (i), true)
							print_separate_argument_list (postconditions.separate_postconditions.i_th (i))
						end

						i := i + 1
					end
					if postconditions.separate_postconditions.count = 0 then
						io.error.put_string ("%N%T%Tnone")
					end
				end
			end
		end

	print_detailed_assertion_object (assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT; is_postcondition: BOOLEAN) is
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
			io.error.put_string (assertion_object.get_separate_calls)

				-- print list of non separate calls
			io.error.put_string (", non separate: ")
			io.error.put_string (assertion_object.get_non_separate_calls)

			io.error.put_string ("]")
		end

	print_separate_argument_list (assertion_object: SCOOP_CLIENT_ASSERTION_OBJECT) is
			-- prints list to io.error
		do
			io.error.put_string ("%N%T%T - Sep. Arguments (" + assertion_object.get_separate_argument_count.out + "): ")
			if assertion_object.has_separate_arguments then
				io.error.put_string (assertion_object.get_separate_argument_list_as_string(true))
			else
				io.error.put_string ("none.")
			end
		end

feature {NONE} -- Implementation

	l_preconditions: SCOOP_CLIENT_PRECONDITIONS
		-- result object of preconditions visitor

	l_postconditions: SCOOP_CLIENT_POSTCONDITIONS
		-- result object of postcondition visitor

	fo: SCOOP_CLIENT_FEATURE_OBJECT
		-- feature object of current processed feature.

end
