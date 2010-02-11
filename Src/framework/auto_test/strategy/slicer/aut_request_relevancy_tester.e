note

	description:

		"[
		  Tests whether a request influences any of a set of variables.
		 ]"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_REQUEST_RELEVANCY_TESTER

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

	is_relevant: BOOLEAN
			-- Was the last request checked relevant?

feature {AUT_REQUEST} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
		do
			is_relevant := False
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
		do
			is_relevant := False
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		do
			is_relevant := variables.has (a_request.target)
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		do
			is_relevant := variables.has (a_request.target) or
							(a_request.receiver /= Void and then variables.has (a_request.receiver))
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
		do
			is_relevant := variables.has (a_request.receiver)
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
		do
			is_relevant := variables.has (a_request.variable)
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
			is_relevant := False
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			is_relevant := False
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			is_relevant := False
		end

invariant

	variables_not_void: variables /= Void
	no_variable_void: not variables.has (Void)

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
