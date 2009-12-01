note
	description: "Summary description for {AFX_FIX_EVALUATOR_SOURCE_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_EVALUATOR_SOURCE_WRITER

inherit
	TEST_EVALUATOR_SOURCE_WRITER
		rename
		    write_source as write_test_evaluator
		redefine
		    put_class_header,
		    ancestor_names
		end

feature -- Status report

	is_start_redefined: BOOLEAN
			-- is feature `start' redefined?

	test_count: NATURAL
			-- number of tests

feature -- Access

	ancestor_names: attached ARRAY [attached STRING]
			-- <Precursor>
		do
			Result := << "AFX_FIX_EVALUATION_ROOT" >>
		end

feature -- Basic operation

	write_fix_evaluator (a_file: attached KI_TEXT_OUTPUT_STREAM; a_list: detachable DS_LINEAR [AFX_TEST])
			-- <Precursor>
		local
		    l_tests: detachable DS_ARRAYED_LIST [TEST_I]
		do
		    if a_list /= Void then
			    test_count := a_list.count.to_natural_32
			    create l_tests.make_default
			    a_list.do_all (
			    	agent (a_test_list: DS_ARRAYED_LIST [TEST_I]; a_test: AFX_TEST)
			    		do
			    		    a_test_list.force_last (a_test.test)
			    		end (l_tests, ?)
			    	)
		    end

		    write_test_evaluator (a_file, l_tests)
		end


	put_class_header
			-- <Precursor>
		do
		    Precursor

			if test_count /= 0 then
    			stream.indent
    			stream.put_line ("test_count: NATURAL = " + test_count.out)
    			stream.dedent
    			stream.put_line ("")
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
