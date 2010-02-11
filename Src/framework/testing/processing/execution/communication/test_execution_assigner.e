note
	description: "[
		Object assigning test indices to clients which then execute the corresponding test.
		Since tests are executed in separate threads, mutexes are used to controll access.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	TEST_EXECUTION_ASSIGNER

create
	make, make_from_list

feature {NONE} -- Initialization

	make (a_test_count: like test_count)
			-- Initialize `Current'.
			--
			-- `a_test_count': Number of tests that will be executed, where each test is identified through
			--                 a unique index between 1 and `a_test_count'.
		local
		    l_test_id: NATURAL
		do
			test_count := a_test_count
			create cursor_mutex.make
			create aborted_tests.make_default
			create tests.make (test_count.to_integer_32)

			from l_test_id := 1
			until l_test_id > test_count
			loop
			    tests.force_last (l_test_id)
			    l_test_id := l_test_id + 1
			end
		ensure
			test_count_set: test_count = a_test_count
		end

	make_from_list (a_list: DS_LINEAR [NATURAL])
			-- Initialization
			--
			-- `a_list': the list of test id's that will be executed
		do
		    test_count := a_list.count.to_natural_32
		    create cursor_mutex.make
		    create aborted_tests.make_default
		    create tests.make (a_list.count)

		    a_list.do_all (agent tests.force_last)
		ensure
			test_count_set: test_count = tests.count
		end

feature -- Access

	test_count: NATURAL
			-- Number of tests being executed
			--
			-- Note: Each test is identified by a unique index between 1 and `test_count'. However it is up
			--       to the client to make the association.

feature {NONE} -- Access

	cursor: like test_count
			-- Index of last test that has been launched

	cursor_mutex: MUTEX
			-- Mutex for controlling access to `cursor' and `aborted_tests'.

	aborted_tests: attached DS_HASH_SET [like test_count]
			-- Indices of tests that have been aborted

	tests: DS_ARRAYED_LIST [NATURAL]
			-- set of test id's

feature {TEST_EVALUATOR_STATUS} -- Query

	has_next: BOOLEAN
			-- Are there any tests left to be executed?
		local
			l_cursor: like cursor
		do
			cursor_mutex.lock
			if cursor <= test_count then
				from
					l_cursor := cursor + 1
				until
					Result or l_cursor > test_count
				loop
					Result := not aborted_tests.has (tests.item (l_cursor.to_integer_32))
					l_cursor := l_cursor + 1
				end
			end
			cursor_mutex.unlock
		end

	next_test: like test_count
			-- Index of next test to be executed, zero if tests have been executed.
			--
			-- Note: calling this routine will move the cursor forth.
		local
		    l_index: INTEGER
		do
			cursor_mutex.lock
			if cursor <= test_count then
				from
				until
					Result > 0 or cursor > test_count
				loop
					cursor := cursor + 1
					l_index := cursor.to_integer_32
					if cursor <= test_count then
						if not aborted_tests.has (tests.item (l_index)) then
							Result := tests.item (l_index)
						end
					end
				end
			end
			cursor_mutex.unlock
		ensure
			a_test_index_valid: is_valid_test_index (Result)
		end

feature -- Status report

	is_aborted (a_test_id: like test_count): BOOLEAN
			-- Has test for given index been aborted?
			--
			-- `a_test_id': ID of test for which we want to know whether it has been aborted.
			-- `Result': True if test for given ID has been aborted, False otherwise.
		require
			a_test_id_valid: is_valid_test_index (a_test_id)
		do
			cursor_mutex.lock
			Result := aborted_tests.has (a_test_id)
			cursor_mutex.unlock
		end

	is_valid_test_index (a_test_id: like test_count): BOOLEAN
			-- is `a_test_id' valid?
		do
		    Result := tests.has (a_test_id)
		end

feature {TEST_EXECUTOR_I} -- Status setting

	set_aborted (a_test_id: like test_count)
			-- Add index of test to list of aborted tests.
			--
			-- `a_test_id': ID of test that has been aborted.
		require
			a_test_id_valid: is_valid_test_index (a_test_id)
		do
			cursor_mutex.lock
			aborted_tests.force_last (a_test_id)
			cursor_mutex.unlock
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
