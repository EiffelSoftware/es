note
	description: "Shared constants."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SHARED_CONSTANTS

feature {NONE} -- Constants

	syntax_version: NATURAL_8
			-- Syntax version used
		once
			Result := {CONF_OPTION}.syntax_index_transitional
		end

feature {NONE} -- Class-relative paths

	c_first_feature: STRING = "1.9.1.2.1"
			-- First feature of a class

feature {NONE} -- Feature-relative paths

	f_assigner: STRING = "1.2.3"
			-- Assigner

	f_first_instruction: STRING = "1.2.4.4.1.1"
			-- First instruction of a feature
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
