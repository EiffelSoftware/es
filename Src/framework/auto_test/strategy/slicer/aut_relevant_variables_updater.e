note

	description:

		"[
		  Updates set of relevant variables for a request, so that the 
		  set includes all variables that the request reads from and
		  does not include those variables that the request writes to.
		 ]"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_RELEVANT_VARIABLES_UPDATER

inherit

	AUT_REQUEST_PROCESSOR

create

	make

feature {NONE} -- Initialization

	make (a_variables: like variables)
			-- Create new strategy.
		require
			a_variables_not_void: a_variables /= Void
			no_variable_void: not a_variables.has (Void)
		do
			variables := a_variables
		ensure
			variables_set: variables = a_variables
		end

feature -- Access

	variables: DS_HASH_SET [ITP_VARIABLE]
			-- Set of relevant variables

feature {AUT_REQUEST} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
		do
			variables.wipe_out
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
		do
			-- Do nothing.
		end

	process_create_agent_request (a_request: AUT_CREATE_AGENT_REQUEST)
		do
			fixme("Not implemented")
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		do
			variables.remove (a_request.target)
			if a_request.argument_list /= Void then
				process_argument_list (a_request.argument_list)
			end
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		do
			if a_request.is_feature_query then
				variables.remove (a_request.receiver)
			end
			variables.force (a_request.target)
			if a_request.argument_list /= Void then
				process_argument_list (a_request.argument_list)
			end
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
		local
			variable: ITP_VARIABLE
		do
			variables.remove (a_request.receiver)
			variable ?= a_request.expression
			if variable /= Void then
				variables.force (variable)
			end
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
		do
			-- Do nothing.
		end

	process_argument_list (an_argument_list: DS_LINEAR [ITP_EXPRESSION])
			-- Add variables in `an_argument_list' to `variables'.
		require
			an_argument_list_not_void: an_argument_list /= Void
			no_argument_void: not an_argument_list.has (Void)
		local
			cs: DS_LINEAR_CURSOR [ITP_EXPRESSION]
			variable: ITP_VARIABLE
		do
			from
				cs := an_argument_list.new_cursor
				cs.start
			until
				cs.off
			loop
				variable ?= cs.item
				if variable /= Void then
					variables.force (variable)
				end
				cs.forth
			end
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
			-- Do nothing.
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			-- Do nothing.
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			-- Do nothing.
		end

invariant

	variables_not_void: variables /= Void
	no_variable_void: not variables.has (Void)

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
