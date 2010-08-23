note
	description: "Panel displaying information about the system."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_SYSTEM_GRID

inherit

	ES_GRID

	EBB_SHARED_BLACKBOARD
		undefine
			default_create,
			copy
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty system panel.
		local
			l_col: EV_GRID_COLUMN
		do
			default_create

			enable_tree
			set_column_count_to (5)

			l_col := column (item_column)
			l_col.set_width (200)
			l_col.set_title ("Item")

			l_col := column (correctness_column)
			l_col.set_width (40)
			l_col.set_title ("C")

			l_col := column (stale_column)
			l_col.set_width (20)
			l_col.set_title ("S")

			l_col := column (last_check_column)
			l_col.set_width (100)
			l_col.set_title ("Last check")

			l_col := column (last_result_column)
			l_col.set_width (100)
			l_col.set_title ("Last result")
		end

feature -- Initialization

	initialize_from_blackboard
			-- Initialize elements to current blackboard data.
		do
			remove_and_clear_all_rows
			across blackboard.data.classes as l_classes loop
				add_class (l_classes.item, extended_new_row)
			end
			update_display
		end

	update_display
			-- Update elements to current blackboard data.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > row_count
			loop
				update_row (row (i))
				i := i + 1
			end
		end

	update_row (a_row: EV_GRID_ROW)
		local
			i: INTEGER
		do
			if attached {EBB_DATA_ELEMENT} a_row.data as l_data then
					-- Correctness column
				if attached {EV_GRID_TEXT_ITEM} a_row.item (correctness_column) as l_text then
					if l_data.has_correctness_confidence then
						l_text.set_text (l_data.correctness_confidence.out)
					else
						l_text.set_text ("-")
					end

				end
					-- Stale column
				if attached {EV_GRID_TEXT_ITEM} a_row.item (stale_column) as l_stale then
					if l_data.is_stale then
						l_stale.set_text ("X")
					else
						l_stale.remove_text
					end
				end
					-- Last check time column
				if attached {EV_GRID_TEXT_ITEM} a_row.item (last_check_column) as l_last_check then
					if attached l_data.last_check_time as l_time then
						check attached l_data.last_check_tool end
						l_last_check.set_text (fuzzy_time_ago_format (l_data.last_check_time) + " (" + l_data.last_check_tool.name + ")")
					else
						l_last_check.remove_text
					end
				end
				apply_color (a_row, l_data)
			end

			from
				i := 1
			until
				i > a_row.subrow_count
			loop
				update_row (a_row.subrow (i))
				i := i + 1
			end
		end

	fuzzy_time_ago_format (a_time: DATE_TIME): STRING
		local
			l_now: DATE_TIME
			l_duration: TIME_DURATION
		do
			create l_now.make_now
			l_duration := l_now.relative_duration (a_time).time
			Result := l_duration.minute.out + " min ago"
		end

feature {NON} -- Implementation

	initialize_row (a_row: EV_GRID_ROW; a_item_text: STRING; a_pixmap: EV_PIXMAP)
			-- Initialize empty row.
		local
			l_grid_item: EB_GRID_EDITOR_ITEM
		do
				-- column: item name
			create l_grid_item.make_with_text (a_item_text)
			if a_pixmap /= Void then
				l_grid_item.set_pixmap (a_pixmap)
			end

			l_grid_item.set_stone_function (agent stone_for_row (a_row))
			a_row.set_item (item_column, l_grid_item)
				-- column: correctness
			a_row.set_item (correctness_column, create {EV_GRID_TEXT_ITEM})
				-- column: stale
			a_row.set_item (stale_column, create {EV_GRID_TEXT_ITEM})
				-- column: last check
			a_row.set_item (last_check_column, create {EV_GRID_TEXT_ITEM})
				-- column: last result
			a_row.set_item (last_result_column, create {EV_GRID_TEXT_ITEM})
		end

	stone_for_row (a_row: EV_GRID_ROW): detachable STONE
			-- Helper function to retrieve a stone from a row.
		do
			if attached {EBB_FEATURE_DATA} a_row.data as l_feature_data then
				create {FEATURE_STONE} Result.make (l_feature_data.associated_feature.e_feature)
			elseif attached {EBB_CLASS_DATA} a_row.data as l_class_data then
				create {CLASSI_STONE} Result.make (l_class_data.associated_class)
			end
		end

	add_class (a_class: EBB_CLASS_DATA; a_row: EV_GRID_ROW)
			-- Add information for `a_class' to display.
		local
			l_factory: EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		do
			create l_factory
			a_row.set_data (a_class)
			initialize_row (a_row, a_class.class_name, l_factory.pixmap_from_class_i (a_class.associated_class))

--			a_row.set_item (item_column, create {EV_GRID_TEXT_ITEM}.make_with_text (a_class.class_name))
--			a_row.set_item (correctness_column, create {EV_GRID_TEXT_ITEM}.make_with_text (a_class.correctness_confidence.out))
--			apply_color (a_row, a_class)

			if a_class.is_compiled then
				across a_class.children as l_features loop
					a_row.insert_subrow (a_row.subrow_count + 1)
					add_feature (l_features.item, a_row.subrow (a_row.subrow_count))
				end
			end
		end

	add_feature (a_feature: EBB_FEATURE_DATA; a_row: EV_GRID_ROW)
			-- Add information for `a_feature' to display.
		local
			l_factory: EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		do
			create l_factory
			a_row.set_data (a_feature)
			initialize_row (a_row, a_feature.feature_name, l_factory.pixmap_from_e_feature (a_feature.associated_feature.e_feature))

--			if a_feature.has_correctness_confidence then
--				a_row.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text (a_feature.correctness_confidence.out))
--			else
--				a_row.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text ("-"))
--			end
--			apply_color (a_row, a_feature)

			across a_feature.applicable_verification_properties as l_properties loop
				a_row.insert_subrow (a_row.subrow_count + 1)
				add_correctness_property (l_properties.item, a_row.subrow (a_row.subrow_count))
			end
		end

	add_correctness_property (a_property: EBB_VERIFICATION_PROPERTY; a_row: EV_GRID_ROW)
			-- TODO
		do
			a_row.set_item (item_column, create {EV_GRID_TEXT_ITEM}.make_with_text (a_property.name))
			a_row.set_item (correctness_column, create {EV_GRID_TEXT_ITEM}.make_with_text ("-"))
		end



	apply_color (a_row: EV_GRID_ROW; a_item: EBB_DATA_ELEMENT)
			-- Set color of `a_row' according to information of `a_item'.
		do
			if a_item.is_stale then
				a_row.set_background_color (color_for_stale_correctness (a_item.correctness_confidence))
			elseif a_item.has_correctness_confidence then
				a_row.set_background_color (color_for_correctness (a_item.correctness_confidence))
			else
				a_row.set_background_color (create {EV_COLOR}.make_with_rgb (1.0, 1.0, 1.0))
			end
		end

	color_for_correctness (a_value: REAL): EV_COLOR
		local
			l_hue, l_saturation, l_value, m, n, f: REAL
			i: INTEGER
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.4, 1.0)
		end

	color_for_stale_correctness (a_value: REAL): EV_COLOR
		local
			l_hue, l_saturation, l_value, m, n, f: REAL
			i: INTEGER
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.4, 0.5)
		end

	gradient_color_hsv (a_gradient, a_start, a_end, a_saturation, a_value: REAL): EV_COLOR
			-- Gradient color.
			-- all values are between 0 and 1.
		local
			l_hue, l_saturation, l_value, m, n, f: REAL
			i: INTEGER
		do
			l_hue := (a_start + (a_gradient * (a_end - a_start))) * 6
			l_saturation := a_saturation
			l_value := a_value

			i := l_hue.floor
			f := l_hue - i
			if i \\ 2 = 0 then
				f := 1 - f
			end
			m := l_value * (1 - l_saturation)
			n := l_value * (1 - (l_saturation * f))
			inspect i
			when 0 then
				create Result.make_with_rgb (l_value, n, m)
			when 1 then
				create Result.make_with_rgb (n, l_value, m)
			when 2 then
				create Result.make_with_rgb (m, l_value, n)
			when 3 then
				create Result.make_with_rgb (m, n, l_value)
			when 4 then
				create Result.make_with_rgb (n, m, l_value)
			when 5 then
				create Result.make_with_rgb (l_value, m, n)
			when 6 then
				create Result.make_with_rgb (l_value, n, m)
			end
		end


	on_update_visiblity
			-- Called when visibility settings change
		local
			l_row: EV_GRID_ROW
			l_count, i: INTEGER
		do
			filter.to_lower
			from
				i := 1
				l_count := row_count
			until
				i > l_count
			loop
				l_row := row (i)
				set_visibility_for_row (l_row)
				i := i + 1
			end
		end

	filter: STRING

	is_item_visible (a_row: EV_GRID_ROW): BOOLEAN
				-- Is `a_row' visible?
		local
			i: INTEGER
			l_subrow_visible: BOOLEAN
		do
			Result := True

			if attached {EBB_DATA_ELEMENT} a_row.data as l_data then
				if attached {EV_GRID_TEXT_ITEM} a_row as l_text then
					if not l_text.text.as_lower.has_substring (filter) then
						from
							i := 1
							l_subrow_visible := False
						until
							i > a_row.subrow_count or l_subrow_visible
						loop
							if a_row.subrow (i).data /= Void then
								l_subrow_visible := is_item_visible (a_row.subrow (i))
							end
							i := i + 1
						end
						Result := l_subrow_visible
					end
				end
			end
		end

	set_visibility_for_row (a_row: EV_GRID_ROW)
		local
			i: INTEGER
			l_subrow_visible: BOOLEAN
		do
			if matches_filter (a_row) then
				a_row.show
				show_all_subrows (a_row)
			else
				from
					l_subrow_visible := False
					i := 1
				until
					i > a_row.subrow_count
				loop
					set_visibility_for_row (a_row.subrow (i))
					if a_row.subrow (i).is_show_requested then
						l_subrow_visible := True
					end
					i := i + 1
				end
				if l_subrow_visible then
					a_row.show
				else
					a_row.hide
				end
			end
		end

	show_all_subrows (a_row: EV_GRID_ROW)
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_row.subrow_count
			loop
				a_row.subrow (i).show
				show_all_subrows (a_row.subrow (i))
				i := i + 1
			end
		end

	matches_filter (a_row: EV_GRID_ROW): BOOLEAN
		do
			if attached {EBB_DATA_ELEMENT} a_row.data as l_data then
				if attached {EV_GRID_TEXT_ITEM} a_row.item (item_column) as l_text then
					Result := l_text.text.as_lower.has_substring (filter)
				end
			end
		end

	item_column: INTEGER = 1
	correctness_column: INTEGER = 2
	stale_column: INTEGER = 3
	last_check_column: INTEGER = 4
	last_result_column: INTEGER = 5

invariant

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
