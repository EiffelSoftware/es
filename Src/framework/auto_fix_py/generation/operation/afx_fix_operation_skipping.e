note
	description: "Summary description for {AFX_FIX_OPERATION_SKIPPING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_OPERATION_SKIPPING

inherit
	AFX_FIX_OPERATION_CONDITIONING
		rename
		    make as make_conditioning
		redefine
		    prologue,
		    build_operation_report
		end

create
    make

feature -- Initialization

	make
			-- initialize a new operation
		do
		    make_conditioning ("False")
		end

feature -- Access

	prologue (an_id: INTEGER): STRING
			-- <Precursor>
		do
		    Result := "if not (create {AFX_FIX_SELECTION_ARBITOR}).is_fix_active(" + an_id.out + ") then%N"
		end

feature -- Operation

	build_operation_report
			-- the operation report for users
		local
		    l_report: STRING
		do
		    create l_report.make_empty
		    l_report.append ("Deletion.")

			last_operation_report := l_report
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
