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
			set_column_count_to (3)

			l_col := column (1)
			l_col.set_width (200)
			l_col.set_title ("Item")

			l_col := column (2)
			l_col.set_width (20)
			l_col.set_title ("C")

			l_col := column (3)
			l_col.set_width (100)
			l_col.set_title ("Last check")
		end

feature -- Initialization

	update_from_blackboard
			-- Update elements to current blackboard data.
		do
			remove_and_clear_all_rows
			across blackboard.data.classes as l_classes loop
				add_class (l_classes.item, extended_new_row)
			end
		end

feature {NON} -- Implementation

	add_class (a_class: EBB_CLASS_DATA; a_row: EV_GRID_ROW)
			-- Add information for `a_class' to display.
		do
			a_row.set_item (1, create {EV_GRID_TEXT_ITEM}.make_with_text (a_class.class_name))
			a_row.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text (a_class.verification_state.correctness_confidence.out))

			across a_class.features as l_features loop
				a_row.insert_subrow (a_row.subrow_count + 1)
				add_feature (l_features.item, a_row.subrow (a_row.subrow_count))
			end
		end

	add_feature (a_feature: EBB_FEATURE_DATA; a_row: EV_GRID_ROW)
			-- Add information for `a_feature' to display.
		do
			a_row.set_item (1, create {EV_GRID_TEXT_ITEM}.make_with_text (a_feature.qualified_feature_name))
			a_row.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text (a_feature.verification_state.correctness_confidence.out))
		end

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
