note
	description: "Persistence constants used in Ebbro."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

deferred class

	ES_EBBRO_PERSISTENCE_CONSTANTS

feature -- serialization / deserialization

	dadl_file_ending: STRING = ".adls"

	binary_file_ending: STRING = ".*"

	dadl_format_id: INTEGER = 1

	binary_format_id: INTEGER = 2

feature -- dialog filters

	dadl_filter: TUPLE [filter: STRING_GENERAL; text: STRING_GENERAL]
			-- filter for dadl files
		once
			create result
			result.put ("*" + dadl_file_ending, 1)
			result.put ("dadl Files ("+result.item (1).out+")", 2)
		end

	binary_filter: TUPLE [filter: STRING_GENERAL; text: STRING_GENERAL]
			-- filter for binary files
		once
			create result
			result.put ("*" + binary_file_ending, 1)
			result.put ("Binary Files ("+result.item (1).out+")", 2)
		end

	all_filter: TUPLE [filter: STRING_GENERAL; text: STRING_GENERAL]
			-- filter for binary files
		once
			create result
			result.put ("*.*", 1)
			result.put ("All Files", 2)
		end


note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
