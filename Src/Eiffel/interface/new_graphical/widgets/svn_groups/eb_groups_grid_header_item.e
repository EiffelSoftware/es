note
	description: "Header item that is used to group clusters, assemblies, libraries, overrides."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GROUPS_GRID_HEADER_ITEM

inherit
	EB_GROUPS_GRID_ITEM
		redefine
			print_name,
			stone
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING_GENERAL; an_icon: EV_PIXMAP)
			-- Create a header with `a_name' and `an_icon'.
		do
			default_create
			set_text (a_name)
			name := a_name.as_string_8
			set_tooltip (a_name)
			set_pixmap (an_icon)
		end

feature -- Access

	stone: STONE
			-- No stones for header
		do
		end

feature -- Status report

	is_clusters_group: BOOLEAN
			-- Is `Current' the Clusters group?
		do
			Result := text.same_string ("Clusters")
		end

feature {NONE} -- Implementation

	print_name
			-- <Precursor>
		do
			if associated_textable /= Void then
				associated_textable.set_text ("")
				associated_textable.set_data (Void)
			end
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
