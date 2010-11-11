note
	description: "Summary description for {EBB_AUTOTEST_VERIFICATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_AUTOTEST_VERIFICATION_RESULT

inherit

	EBB_VERIFICATION_RESULT
		redefine
			single_line_message
		end

	EXCEP_CONST
		export {NONE} all end

create
	make

feature -- Access

	message: STRING
			-- <Precursor>
		do
			if is_fault then
				if code = postcondition then
					Result := "Postcondition violated"
				elseif code = precondition then
					Result := "Precondition violated"
				elseif code = class_invariant then
					Result := "Class invariant violated"
				elseif code = check_instruction then
					Result := "Check instruction violated"
				else
					Result := "Error code " + code.out
				end
			elseif is_passing then
				Result := "Tests passed"
			else
				check False end
			end
		end

	number_of_passing: INTEGER
			-- Number of passing test cases.

	exception_trace: STRING
			-- Exception trace in case this is a fault.

	code: INTEGER
			-- Exception code.

	tag: STRING
			-- Assertion tag (if any).

feature -- Status report

	is_fault: BOOLEAN
			-- Is this result a fault?
		do
			Result := exception_trace /= void
		end

	is_passing: BOOLEAN
			-- Is this a passing result?
		do
			Result := number_of_passing > 0
		end

feature -- Element change

	set_number_of_passing (a_number: like number_of_passing)
			-- Set `number_of_passing' to `a_number'.
		do
			number_of_passing := a_number
		ensure
			number_of_passing_set: number_of_passing = a_number
		end

	set_exception_trace (a_trace: like exception_trace)
			-- Set `exception_trace' to `a_trace'.
		do
			exception_trace := a_trace
		ensure
			exception_trace_set: exception_trace = a_trace
		end

	set_tag (a_tag: like tag)
			-- Set `tag' to `a_tag'.
		do
			tag := a_tag
		ensure
			tag_set: tag = a_tag
		end

	set_code (a_code: like code)
			-- Set `code' to `a_code'.
		do
			code := a_code
		ensure
			code_set: code = a_code
		end

feature -- Basic operations

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_formatter.add (message)
			if is_passing then
				a_formatter.add (" (" + number_of_passing.out + " tests)")
			elseif tag /= Void then
				a_formatter.add (" (tag: " + tag + ")")
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
