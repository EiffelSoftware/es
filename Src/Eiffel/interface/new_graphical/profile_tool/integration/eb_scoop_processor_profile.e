note
	description: "Refinement of processor profile, for integration in EiffelStudio."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_PROCESSOR_PROFILE

inherit
	SCOOP_PROFILER_EV_PROCESSOR_PROFILE
		redefine
			label_name,
			build_tooltip
		end

create
	make_with_interface_names

feature {NONE} -- Creation

	make_with_interface_names (a_names: like interface_names)
			--
		require
			names_not_void: a_names /= Void
		do
			make
			interface_names := a_names
		ensure
			interface_names_set: interface_names = a_names
		end

feature {NONE} -- Display elements

	label_name: STRING
			-- Label name
		do
			Result := interface_names.l_scoop_processor_element
		end

	build_tooltip
			-- Build tooltip.
		do
			create tooltip.make_from_string (interface_names.f_scoop_processor (id.out, execution_time.out + millisecond_suffix, wait_time.out + millisecond_suffix, profile_time.out + millisecond_suffix))
		end

feature {NONE} -- Implementation

	interface_names: INTERFACE_NAMES
			-- Reference to the interface names

invariant
	interface_names_not_void: interface_names /= Void

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
