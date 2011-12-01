note
	description: "Summary description for {EWB_DYNAMIC_PROGRAM_ANALYSIS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_DYNAMIC_PROGRAM_ANALYSIS

inherit
	EWB_CMD

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize `arguments' with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create {LINKED_LIST [STRING]} analysis_arguments.make
			a_arguments.do_all (agent analysis_arguments.extend)
		ensure
			arguments_set: analysis_arguments /= Void and then analysis_arguments.count = a_arguments.count
		end

feature -- Access

	analysis_arguments: LINKED_LIST [STRING];
			-- Arguments

feature -- Properties

	name: STRING
		do
			Result := "xml transformation"
		end

	help_message: STRING_GENERAL
		do
			Result := "xml transformation"
		end

	abbreviation: CHARACTER
		do
			Result := 'x'
		end

	execute
			-- Action performed when invoked from the
			-- command line.
		do
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
