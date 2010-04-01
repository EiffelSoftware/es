note
	description: "Refinement of feature call-application profile, for integration in EiffelStudio."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_FEATURE_CALL_APPLICATION_PROFILE

inherit
	SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE
		redefine
			build_tooltip,
			build_external_tooltip
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

	build_tooltip
			-- Build tooltip.
		local
			l_requested_processors: STRING
		do
			-- Create tooltip
			create tooltip.make_empty
			if is_incomplete then
				tooltip.append (interface_names.f_scoop_incomplete + "%N")
			end
			tooltip.append (interface_names.f_scoop_feature_call_application (feature_definition.class_definition.name, feature_definition.name,
								duration_to_milliseconds (sync_duration.plus (execution_duration)).out + millisecond_suffix,
								duration_to_milliseconds (queue_duration).out + millisecond_suffix,
								duration_to_milliseconds (sync_duration).out + millisecond_suffix,
								duration_to_milliseconds (execution_duration).out + millisecond_suffix,
								call_time.out, sync_time.out, return_time.out))
			if not requested_processors.is_empty then
				tooltip.append ("%N")
				from
					requested_processors.start
					create l_requested_processors.make_empty
				until
					requested_processors.after
				loop
					l_requested_processors.append (requested_processors.item.id.out + " ")
					requested_processors.forth
				end
				tooltip.append (interface_names.f_scoop_requested_processors (l_requested_processors))
			end
			if not wait_conditions.is_empty then
				tooltip.append ("%N" + interface_names.f_scoop_wait_conditions (wait_conditions.count.out))
			end
		end

	build_external_tooltip
			-- Build external tooltip.
		do
			create external_tooltip.make_empty
			if is_incomplete then
				external_tooltip.append (interface_names.f_scoop_incomplete + "%N")
			end
			external_tooltip.append (interface_names.f_scoop_called_processor (processor.id.out) + "%N")
			external_tooltip.append (interface_names.f_scoop_feature_call_application (feature_definition.class_definition.name, feature_definition.name,
								duration_to_milliseconds (sync_duration.plus (execution_duration)).out + millisecond_suffix,
								duration_to_milliseconds (queue_duration).out + millisecond_suffix,
								duration_to_milliseconds (sync_duration).out + millisecond_suffix,
								duration_to_milliseconds (execution_duration).out + millisecond_suffix,
								call_time.out, sync_time.out, return_time.out))
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
