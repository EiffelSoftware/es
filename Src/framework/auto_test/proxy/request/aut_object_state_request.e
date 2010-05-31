note
	description: "AutoTest request to check states of an object"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_OBJECT_STATE_REQUEST

inherit
	AUT_REQUEST
		rename
			make as make_old
		end

	EPA_COMPILATION_UTILITY

	AUT_SHARED_INTERPRETER_INFO

	EPA_STRING_UTILITY
		undefine
			system
		end

	AUT_SHARED_OBJECT_STATE_RETRIEVAL_CONTEXT

feature -- Access

	variables: HASH_TABLE [TYPE_A, INTEGER]
			-- Variables whose states are to be retrieved
			-- Key is object index (used in object pool), value is type of that variables.

	byte_codes: TUPLE [pre_state_byte_code: STRING; post_state_byte_code: detachable STRING]
			-- Strings representing the byte-code needed to retrieve object states
			-- `pre_state_byte_code' is to be executed before the test case execution.
			-- `post_state_byte_code' is to be executed after the test case execution.
		deferred
		end

	config: detachable AUT_OBJECT_STATE_CONFIG
			-- Configuration for object state retrieval

feature -- Status report

	is_for_feature: BOOLEAN
			-- Is the state to be retrieved for operands of a feature?
		do
		end

	is_for_objects: BOOLEAN
			-- Is the state to be retrieved for an arbitrary set of objects?
		do
			Result := not is_for_feature
		ensure
			good_result: Result = not is_for_feature
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_object_state_request (Current)
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
