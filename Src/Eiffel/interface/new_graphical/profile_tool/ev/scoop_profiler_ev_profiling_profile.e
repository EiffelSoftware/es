note
	description: "Refinement of profiling profile, for display with EiffelVision."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_EV_PROFILING_PROFILE

inherit
	SCOOP_PROFILER_PROFILING_PROFILE
		rename
			processor as processor_old
		end

	SCOOP_PROFILER_EV_ACTION_PROFILE
		redefine
			widget
		select
			processor
		end

	SCOOP_PROFILER_EV_HELPER
		export
			{NONE} all
		end

create {SCOOP_PROFILER_EV_APPLICATION_PROFILE}
	make

feature -- Display

	widget: EV_VERTICAL_BOX
			-- Widget to display
		do
			if tooltip = Void then
				build_tooltip
			end

			create Result

			-- Basic widgets
			create label.make_with_text (label_name)
			label.set_background_color (Profiling_color)
			label.align_text_left

			Result.extend (label)
			Result.disable_item_expand (Result.last)
			Result.extend (create {EV_CELL})

			-- Tooltip
			label.set_tooltip (tooltip)
			label.set_minimum_size (width, feature_height)
		end

feature {NONE} -- Display elements

	build_tooltip
			-- Build tooltip.
		do
			create tooltip.make_empty
			tooltip.append ("Profiling action%N")
			tooltip.append ("Duration: " + duration_to_milliseconds (duration).out + millisecond_suffix + "%N")
			tooltip.append ("Start: " + start_time.out + "%NEnd: " + stop_time.out + "%N")
		ensure
			tooltip_set: tooltip /= Void and then not tooltip.is_empty
		end

	label_name: STRING
			-- Label name
		do
			Result := "prof"
		ensure
			result_set: Result /= Void
		end

feature {NONE} -- Implementation

	width: INTEGER
			-- What's the width of this element?
		do
			Result := (duration_to_milliseconds (duration) * processor.application.zoom).truncated_to_integer
		ensure
			result_non_negative: Result >= 0
		end

	tooltip: STRING
			-- Tooltip

	label: EV_LABEL
			-- Label

;note
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
