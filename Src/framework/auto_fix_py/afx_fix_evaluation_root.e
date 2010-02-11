note
	description: "Summary description for {AFX_FIX_EVALUATION_ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_EVALUATION_ROOT

inherit
	EQA_EVALUATOR
		redefine
		    start,
		    run_test
		end

	AFX_FIX_SELECTION_ARBITOR

feature {NONE}

	test_count: NATURAL_32
			-- number of fixes
		deferred
		end

	test_id: NATURAL_32
			-- id of current running test

	get_test_index (n: NATURAL_32): NATURAL_32
			-- interprete test index from `n'
		do
		    if n \\ test_count = 0 then
		        Result := test_count
		    else
		        Result := n \\ test_count
		    end
		end

	get_fix_index (n:NATURAL_32): NATURAL_32
			-- interprete fix index from `n'
		do
		    if n \\ test_count = 0 then
		        Result := n // test_count
		    else
		        Result := n // test_count + 1
		    end
		end

	start
			-- <Precursor>
		local
			l_quit, l_done: BOOLEAN
			n: NATURAL_32
			l_test_index: NATURAL_32
			l_fix_index: NATURAL_32
			l_stream: like stream
		do
			if not l_quit then
				initialize_stream
				l_stream := stream
				check l_stream /= Void end

				-- to avoid the influence from previous run, e.g. because of the presence of 'once' features
				-- processes are not reused for multiple tests.
				from until
					l_done
				loop
					l_done := True
					l_stream.read_natural_32
					if l_stream.bytes_read = {PLATFORM}.natural_32_bytes then
						n := l_stream.last_natural_32

						io.output.put_string ("#" + n.out + " ")
						io.output.flush

						if n > 0 then
						    test_id := n
						    l_test_index := get_test_index (n)
						    l_fix_index := get_fix_index (n)

						    io.output.put_string ("(T:" + l_test_index.out + ", F:" + l_fix_index.out + ")%N")
						    io.output.flush

							clear_active_fix_id
						    register_active_fix_id(l_fix_index)

							if is_valid_index (l_test_index) then
								run_test (l_test_index)
								l_done := False
							end
						end
					end
				end -- loop
				l_stream.put_natural (0)
				close_stream
			end
		rescue
			if is_stream_invalid then
				if arguments.has_port_option then
					io.output.put_string ("Could not write to socket on port ")
					io.output.put_integer (arguments.port_option)
				else
					io.output.put_string ("Count not write to file ")
					io.output.put_string (arguments.file_option)
				end
				io.output.put_new_line
				die (1)
			elseif exception = {EXCEP_CONST}.signal_exception or
			       exception = {EXCEP_CONST}.operating_system_exception then
					--| assuming process was killed on user request
				l_quit := True
				retry
			end
		end

	run_test (a_index: NATURAL)
			-- Run test with `a_index'.
		local
			l_result: detachable EQA_TEST_RESULT
			l_stream: like stream
		do
			evaluator.execute (test_set_instance (a_index), test_procedure (a_index), test_name (a_index))
			l_stream := stream
			check l_stream /= Void end
			if l_stream.extendible then
				l_stream.put_natural (test_id)
				l_result := evaluator.last_result
				check l_result /= Void end
				l_stream.independent_store (l_result)
			else
				is_stream_invalid := True
			end
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
