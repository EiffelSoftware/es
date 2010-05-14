note
	description: "[
					Roundtrip visitor to create an enclosing routine in a client class, based on an original feature.
					
					- An enclosing routine exists for an original feature with separate arguments. It contains the code of the original feature and it checks the separate precondition and the immediate postcondition. It also increments a postcondition counter for each separate argument. This counter is used to keep track of when all postcondition clauses that involve the particular argument have been evaluated. Each time a postcondition clause gets evaluated that involves the argument, the postcondition counter of the argument gets decreased by the number of times the argument appears in the postcondition clause. When the postcondition counter reaches 0, it means that the lock on the corresponding processor can be released. After increasing the postcondition counter, the enclosing routine decreases the postcondition counter for the number of times the argument appears in the immediate postcondition.
					- A separate precondition contains calls on separate targets. It can either be controlled or uncontrolled. An uncontrolled separate precondition has a wait semantics. A uncontrolled separate precondition has a correctness semantics. Whether a separate precondition is uncontrolled or controlled depends on the context in which the feature was called. To make sure that a separate precondition can be used as wait condition and as a correctness condition, the separate precondition must be replicated in two places of the client class. The separate precondition must appear in the body of the wait condition wrapper and as a precondition of the enclosing routine. If the separate precondition is controlled then it must be treated as a correctness condition. This happens when the precondition of the enclosing routine gets checked. If the separate precondition is uncontrolled then it must be treated as a wait condition. This happens when the scheduler periodically checks the wait condition wrapper. After the wait condition wrapper returns true, the enclosing routine wrapper gets executed. As part of this execution the separate precondition gets checked one more time, because it appears as a precondition in the enclosing routine wrapper. This is unnecessary, but not harmful, because the locking semantics guarantees that the separate precondition must still hold at this point. 
					- The immediate postcondition contains old and result keywords. It must be checked right after the execution of the body, because this is when the old values and the result are still available.
					- Generated call chains in the contracts operate on client objects. Call chains in the body operate both on client- and proxy objects.
					- Enclosing routines are always effective, so that they can be inherited by effective classes without the need to redefine them.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ER_VISITOR

inherit
	SCOOP_CLIENT_FEATURE_VISITOR
		redefine
			process_body_as,
			process_deferred_as,
			process_precursor_as,
			process_ensure_then_as,
			process_ensure_as,
			process_routine_as
		end

create
	make

feature -- Access

	add_enclosing_routine (l_as: BODY_AS)
			-- Add an enclosing routine for 'l_as'.
		do
			-- print feature name
			context.add_string ("%N%N%T" + feature_object.feature_name + {SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive)
			context.add_string (class_c.name.as_lower + {SCOOP_SYSTEM_CONSTANTS}.enclosing_routine_name_additive)
			context.add_string ("")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Implementation

	process_body_as (l_as: BODY_AS)
		local
			c_as: CONSTANT_AS
		do
			is_internal_arguments := True
			safe_process (l_as.internal_arguments)
			is_internal_arguments := False


			safe_process (l_as.colon_symbol (match_list))
			safe_process (l_as.type)
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			c_as ?= l_as.content
			if c_as /= Void then
				l_as.content.process (Current)
				safe_process (l_as.indexing_clause)
			else
				safe_process (l_as.indexing_clause)

					-- add comment
				context.add_string ("%N%T%T%T-- Wrapper for enclosing routine `" + feature_object.feature_name.as_lower + "'.")

					-- process body (routine_as)
				safe_process (l_as.content)
			end
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
				-- process 'l_as'
			safe_process (l_as.obsolete_keyword (match_list))
			safe_process (l_as.obsolete_message)

			avoid_proxy_calls_in_call_chains := True
			is_processing_assertions := True
			safe_process (l_as.precondition)
			is_processing_assertions := False
			avoid_proxy_calls_in_call_chains := False

			safe_process (l_as.internal_locals)
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				feature_object.set_locals_index (ctxt.cursor_to_current_position)
			end

			safe_process (l_as.routine_body)

			is_processing_assertions := True
			safe_process (l_as.postcondition)
			is_processing_assertions := False

			safe_process (l_as.rescue_keyword (match_list))
			safe_process (l_as.rescue_clause)

				-- process end keyword
			context.add_string ("%N%T%T")
			last_index := l_as.end_keyword.first_token (match_list).index - 1
			safe_process (l_as.end_keyword)

			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				if feature_object.need_local_section then
					ctxt.insert_after_cursor ("%N%T%Tlocal", feature_object.locals_index)
					feature_object.set_need_local_section ( False )
				end
			end

		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			-- Enclosing routines must never be deferred. Otherwise they render effective classes invalid, when they get inherited.
			context.add_string ("%N%T%Tdo")
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		local
			l_parent: STRING
		do
			last_index := l_as.first_token (match_list).index - 1

				-- print normal call to inherited feature
			context.add_string ("%N%T%T%T" + feature_object.feature_name + "_scoop_separate_")

			if l_as.parent_base_class /= Void then
				create l_parent.make_from_string (l_as.parent_base_class.class_name.name.as_lower)
				context.add_string (l_parent + "_enclosing_routine ")
			else
					-- get name of parent base class		
				l_parent := precursor_parent (feature_object.feature_name)
				if l_parent /= Void then
					context.add_string (l_parent.as_lower + "_enclosing_routine ")
				else
					error_handler.insert_error (create {INTERNAL_ERROR}.make (
							"In {SCOOP_CLIENT_FEATURE_ER_VISITOR}.process_precursor_as could%N%
							%not find a valid parent for the Precursor statement."))
				end
			end
			if l_as.internal_parameters /= void then
				last_index := l_as.internal_parameters.first_token (match_list).index - 1
			end

			update_current_level_with_call (l_as)
			process_internal_parameters(l_as.internal_parameters)
			last_index := l_as.last_token (match_list).index
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			process_ensure_as(l_as)
		end

	process_ensure_as (l_as: ENSURE_AS)
		local
			i, j: INTEGER
			current_immediate_post_condition: SCOOP_CLIENT_ASSERTION_OBJECT
			separate_argument_occurrences_count: TUPLE[name: STRING; occurrences_count: INTEGER]
			l_argument_name: STRING
		do
			if attached {ENSURE_THEN_AS} l_as then
				context.add_string ("%N%T%Tensure then")
			else
				context.add_string ("%N%T%Tensure")
			end
				-- separate argument increased postcondition counter call
			if not feature_object.arguments.separate_arguments.is_empty then
				from
					i := 1
				until
					i > feature_object.arguments.separate_arguments.count
				loop
					from
						j := 1
					until
						j > feature_object.arguments.separate_arguments.i_th (i).id_list.count
					loop
						l_argument_name := feature_object.arguments.separate_arguments.i_th (i).item_name (j)
						if feature_object.arguments.argument_count (l_argument_name) > 0 then
							context.add_string ("%N%T%T%T")
							context.add_string (l_argument_name)
							context.add_string (".increased_postcondition_counter (")
							context.add_string (feature_object.arguments.argument_count (l_argument_name).out)
							context.add_string (")")
						end
						j := j + 1
					end

					i := i + 1
				end
			end

				-- print immediate postcondition clauses.
			from
				i := 1
			until
				i > feature_object.postconditions.immediate_postconditions.count
			loop
				current_immediate_post_condition := feature_object.postconditions.immediate_postconditions.i_th (i)
				last_index := current_immediate_post_condition.tagged_as.first_token (match_list).index - 1
				context.add_string ("%N%T%T%T")
				avoid_proxy_calls_in_call_chains := true
				safe_process (current_immediate_post_condition.tagged_as)
				avoid_proxy_calls_in_call_chains := false
				reset_current_levels_layer
				reset_current_object_tests_layer

				from
					j := 1
				until
					j > current_immediate_post_condition.separate_arguments_count
				loop
					-- get separate argument tuple
					separate_argument_occurrences_count := current_immediate_post_condition.i_th_separate_argument_occurrences_count (j)

					-- print decrease call
					context.add_string ("%N%T%T%T" + separate_argument_occurrences_count.name + ".decreased_postcondition_counter (" + separate_argument_occurrences_count.occurrences_count.out + ")")

					j := j + 1
				end

				i := i + 1
			end

			if l_as /= Void then
				last_index := l_as.last_token (match_list).index
			end
		end

	precursor_parent (a_feature_name: STRING): STRING
			-- returns the parent of a precursor feature.
			-- traverses the redefining list of the parents.
		local
			i, j: INTEGER
		do
			from
				i := 1
			until
				i > parsed_class.parents.count
			loop
				if parsed_class.parents.i_th (i).redefining /= Void then
					from
						j := 1
					until
						j > parsed_class.parents.i_th (i).redefining.count
					loop
						if parsed_class.parents.i_th (i).redefining.i_th (i).internal_name.name.is_equal (a_feature_name) then
							Result := parsed_class.parents.i_th (i).type.class_name.name
						end
						j := j + 1
					end

				end
				i := i + 1
			end
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

end -- class SCOOP_CLIENT_FEATURE_ER_VISITOR
