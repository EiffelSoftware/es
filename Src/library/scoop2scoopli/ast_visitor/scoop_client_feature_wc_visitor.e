note
	description: "[
					Roundtrip visitor to create a wait condition wrapper in a client class, based on an original feature.
					A wait condition wrapper exists for an original feature with separate arguments. It checks the separate precondition of the original feature.
					A separate precondition contains calls on separate targets. It can either be controlled or uncontrolled. A uncontrolled separate precondition has a wait semantics. A uncontrolled separate precondition has a correctness semantics. Whether a separate precondition is uncontrolled or controlled depends on the context in which the feature was called. To make sure that a separate precondition can be used as wait condition and as a correctness condition, the separate precondition must be replicated in two places of the client class. The separate precondition must appear in the body of the wait condition wrapper and as a precondition of the enclosing routine. If the separate precondition is controlled then it must be treated as a correctness condition. This happens when the precondition of the enclosing routine gets checked. If the separate precondition is uncontrolled then it must be treated as a wait condition. This happens when the scheduler periodically checks the wait condition wrapper. After the wait condition wrapper returns true, the enclosing routine wrapper gets executed. As part of this execution the separate precondition gets checked one more time, because it appears as a precondition in the enclosing routine wrapper. This is unnecessary, but not harmful, because the locking semantics guarantees that the separate precondition must still hold at this point. 
					Generated call chains operate on client objects.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_WC_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			make,
			process_body_as,
			process_tagged_as
		end

create
	make

feature -- Initialisation

	make(a_ctxt: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		do
			Precursor (a_ctxt)
		end

feature -- Access

	add_wait_condition_wrapper (l_as: BODY_AS)
			-- Add a wait condition wrapper for 'l_as'.
		do
			-- print feature name
			context.add_string (
				"%N%N%T" +
				feature_object.feature_name +
				{SCOOP_SYSTEM_CONSTANTS}.general_wrapper_name_additive +
				class_c.name.as_lower + {SCOOP_SYSTEM_CONSTANTS}.wait_condition_wrapper_name_additive +
				" "
			)

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Implementation

	process_body_as (l_as: BODY_AS)
		local
			i: INTEGER
			r_as: ROUTINE_AS
		do
			safe_process (l_as.internal_arguments)

			-- Retun type is 'BOOLEAN'
			if l_as.type /= Void then
				safe_process (l_as.colon_symbol (match_list))
				context.add_string (" BOOLEAN ")
				last_index := l_as.type.last_token (match_list).index
			else
				context.add_string (": BOOLEAN ")
			end

			-- proceed
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			r_as ?= l_as.content
			if r_as /= Void then
				safe_process (l_as.indexing_clause)

				-- add comment
				context.add_string ("%N%T%T%T-- Wrapper for wait-condition of enclosing routine `" + feature_object.feature_name + "'.")

				-- add do keyword
				context.add_string ("%N%T%Tdo")

				-- add 'Result'
				context.add_string ("%N%T%T%TResult := True")

				-- add precondition expressions with 'and then'
				from
					i := 1
				until
					i > feature_object.preconditions.wait_conditions.count
				loop
					context.add_string ("%N%T%T%T%Tand then (")
					avoid_proxy_calls_in_call_chains := true
					safe_process (feature_object.preconditions.wait_conditions.i_th (i).tagged_as)
					avoid_proxy_calls_in_call_chains := false
					reset_current_levels_layer
					reset_current_object_tests_layer
					context.add_string (")")
					i := i + 1
				end

				-- add end keyword
				context.add_string ("%N%T%Tend")
			end
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			-- print only expression of the wait condition
			last_index := l_as.expr.first_token (match_list).index - 1
			safe_process (l_as.expr)
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

end -- class SCOOP_CLIENT_FEATURE_WC_VISITOR
