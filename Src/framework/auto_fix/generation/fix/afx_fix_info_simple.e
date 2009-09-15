note
	description: "Summary description for {AFX_FIX_INFO_SIMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_INFO_SIMPLE

inherit
	AFX_FIX_INFO_I

create
    make

feature -- Initialization

	make (a_position: AFX_FIX_POSITION; an_operation: AFX_FIX_OPERATION_I)
			-- initialize a new object
		do
		    fix_position := a_position
		    fix_operation := an_operation
		end

feature -- Access

	fix_position: AFX_FIX_POSITION
			-- position where the fix should be applied

	fix_operation: AFX_FIX_OPERATION_I
			-- fix operation

	fix_id: INTEGER
			-- global unique id of the fix

	last_fix_report: STRING
			-- <Precursor>

feature -- Operation

	apply (a_modifier: AFX_FIX_WRITER)
			-- <Precursor>
		require else
		    same_class_name: fix_position.exception_position.class_name ~ a_modifier.context_class.name
		    is_valid_id: is_valid_id
		local
		    l_absolute_position: TUPLE[start_position: INTEGER; end_position: INTEGER]
		    l_code_before: STRING
		    l_code_after: STRING
		do
				-- absolute fix position
			fix_position.update_absolution_fix_position (a_modifier)
			l_absolute_position := fix_position.absolute_position

			l_code_before := fix_operation.prologue (fix_id)
			l_code_after := fix_operation.epilogue (fix_id)

				-- apply fixing code to the class
			if not l_code_before.is_empty then
				a_modifier.insert_code (l_absolute_position.start_position, l_code_before)
			end

			if not l_code_after.is_empty then
			    a_modifier.insert_code (l_absolute_position.end_position, l_code_after)
			end

		end

	build_fix_report
			-- <Precursor>
		local
		    l_report: STRING
		do
		    create l_report.make_empty
		    l_report.append ("Fix info.(" + fix_id.out + "):%N")
		    fix_operation.build_operation_report
		    l_report.append ("%T" + fix_operation.last_operation_report + "%N")
		    fix_position.build_position_report
		    l_report.append ("%T@ " + fix_position.last_position_report + "%N")

		    last_fix_report := l_report
		end

feature -- Setting

	set_fix_id (an_id: INTEGER)
			-- <Precursor>
		do
		    fix_id := an_id
		end


;note
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
