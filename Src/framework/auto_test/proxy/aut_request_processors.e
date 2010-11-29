note
	description: "AutoTest request processor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_REQUEST_PROCESSORS

inherit
	AUT_REQUEST_PROCESSOR
		undefine
			is_equal,
			copy
		end

	LINKED_LIST [AUT_REQUEST_PROCESSOR]

create
	make

feature {AUT_REQUEST} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_stop_request (a_request: AUT_STOP_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_create_agent_request (a_request: AUT_CREATE_AGENT_REQUEST)
			-- Process `a_request'.
		do
			fixme("Not implemented")
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_assign_expression_request (a_request: AUT_ASSIGN_EXPRESSION_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_type_request (a_request: AUT_TYPE_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_precodition_evaluation_request (a_request: AUT_PRECONDITION_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

	process_predicate_evaluation_request (a_request: AUT_PREDICATE_EVALUATION_REQUEST)
			-- Process `a_request'.
		do
			do_all (agent a_request.process (?))
		end

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
