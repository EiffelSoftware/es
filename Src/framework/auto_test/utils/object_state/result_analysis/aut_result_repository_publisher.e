note
	description: "Summary description for {AUT_RESULT_REPOSITORY_PUBLISHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RESULT_REPOSITORY_PUBLISHER

inherit
	AUT_RESULT_REPOSITORY_BUILDER
		rename
			make as old_make
		redefine
			update_result_repository
		end

	AUT_RESULT_ANALYSIS_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_session: like session)
			-- <Precursor>
		do
			old_make (a_system)
			session := a_session
		end

feature -- Access

	session: AUT_SESSION
			-- Current AutoTest session

	witness_observers: LIST [AUT_WITNESS_OBSERVER] is
			-- List of observers for witness.
		do
			if witness_observers_internal = Void then
				create {LINKED_LIST [AUT_WITNESS_OBSERVER]} witness_observers_internal.make
			end
			Result := witness_observers_internal
		end

	witness_veto_function: detachable FUNCTION [ANY, TUPLE [AUT_ABS_WITNESS], BOOLEAN]
			-- Function to veto dispatch of a witness
			-- If this function returns true, the witness will be dispatched
			-- to all registered observers
			-- If this function is Void, all witness will be dispatched.

feature -- Setting

	set_witness_veto_function (a_function: like witness_veto_function) is
			-- Set `witness_veto_function' with `a_function'.
		do
			witness_veto_function := a_function
		ensure
			witness_veto_function_set: witness_veto_function = a_function
		end

	register_witness_observer (a_observer: AUT_WITNESS_OBSERVER) is
			-- Register `a_observer' into `witness_observers'.
		do
			witness_observers.extend (a_observer)
			comment_processors.extend (agent a_observer.process_comment_line)
		end

feature -- Basic operation

	build (a_input_stream: KI_TEXT_INPUT_STREAM)
			-- Build result repository from `a_input_stream' and
			-- store result in `result_repository'.
		local
			l_log_parser: AUT_LOG_PARSER
		do
			create l_log_parser.make (system, session.error_handler)
			l_log_parser.add_observer (Current)
			l_log_parser.set_variable_table (variable_table)
			l_log_parser.parse_stream (a_input_stream)
			notify_observers
		end

feature{NONE} -- Implementation

	witness_observers_internal: detachable like witness_observers
			-- Implementation of `witness_observers'

	unprocessed_witnesses: DS_LINKED_QUEUE [AUT_ABS_WITNESS] is
			-- Queu of unprocessed witness
		do
			if unprocessed_witnesses_internal = Void then
				create unprocessed_witnesses_internal.make
			end
			Result := unprocessed_witnesses_internal
		end

	unprocessed_witnesses_internal: detachable like unprocessed_witnesses
			-- Implementation of `unprocessed_witnesses'

	update_result_repository
			-- Update result repository based on last request in result-history.			
		local
			witness: AUT_ABS_WITNESS
		do
			notify_observers

--			create witness.make (request_history, last_start_index, request_history.count)
			create witness.make_with_request (request_history.last)
			result_repository.add_witness (witness)
--			last_test_case_request := witness.item (witness.count)
--			last_test_case_request.set_test_case_index (last_test_case_index)

				-- Add the new witness to the end of `unprocessed_witnesses'.
			if witness_veto_function = Void or else witness_veto_function.item ([witness]) then
				unprocessed_witnesses.force (witness)
			end
		end

	notify_observers is
			-- Notify all witnessed in `unprocessed_witnesses' to `witness_observers',
			-- and wipe out `unprocessed_witnesses'.
		local
			l_witness: AUT_ABS_WITNESS
			l_observers: like witness_observers
			l_unprocessed: like unprocessed_witnesses
		do
			from
				l_unprocessed := unprocessed_witnesses
			until
				l_unprocessed.is_empty
			loop
				l_witness := unprocessed_witnesses.item
				from
					l_observers := witness_observers
					l_observers.start
				until
					l_observers.after
				loop

					l_observers.item.process_witness (l_witness)
					l_observers.forth
				end
				unprocessed_witnesses.remove
			end
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
