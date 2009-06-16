note
	description: "Summary description for {AUT_CITADEL_RESULT_REPOSITORY_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class AUT_CITADEL_RESULT_REPOSITORY_BUILDER

inherit
	AUT_LOG_PARSER
		redefine
			process_start_request,
			parse_stream
		end

create
	make

feature -- Building

	build (a_input_stream: KI_TEXT_INPUT_STREAM)
			-- Build result repository from `a_input_stream' and
			-- store result in `last_result_repository'.
		require
			a_input_stream_attached: a_input_stream /= Void
			a_input_stream_is_open_read: a_input_stream.is_open_read
		do
			create last_result_repository.make
			parse_stream (a_input_stream)
		ensure
			last_result_repository_built: last_result_repository /= Void
		end

feature -- Access

	last_result_repository: AUT_TEST_CASE_RESULT_REPOSITORY
			-- Last result repository built by `build'

feature{NONE} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
		do
			check
				a_request_in_history: request_history.has (a_request)
			end
			Precursor (a_request)
			if last_start_index > 0 then -- This is not the first interpreter start in the proxy log file
				update_result_repository
			end
			last_start_index := request_history.count + 1
		end

	parse_stream (an_input_stream: KI_TEXT_INPUT_STREAM)
		do
			Precursor (an_input_stream)
			update_result_repository
		end


feature {NONE} -- Implementation

	last_start_index: INTEGER
			-- Index of the last "start" request in `request_history'

	update_result_repository
			-- Update result repository based on last request in result-history.			
		require
			last_start_index_large_enough: last_start_index > 0 -- To be removed when added back to invariant
			last_start_index_small_enough: last_start_index <= request_history.count -- To be removed when added back to invariant
			request_history_not_empty: request_history.count > 0
			last_request_has_response: request_history.item (request_history.count).response /= Void
		local
			witness: AUT_WITNESS
		do
			create witness.make (request_history, last_start_index, request_history.count - 3) -- Minus 3 to skip start request, stop request and last request which killed the interpreter
			last_result_repository.add_witness (witness)
		end


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

