note
	description: "Compares two root-object tree rows and its children."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TREE_COMPARER

inherit
	ES_EBBRO_DISPLAY_CONST


feature -- Access



feature -- Basic operations

	compare_two_root_objects (root_object_row1, root_object_row2: EV_GRID_ROW)
			-- compare two root object rows and subrows
		local
			l_default_color: EV_COLOR
		do
			if root_object_row1.subrow_count > 0 and root_object_row2.subrow_count > 0 then
				l_default_color := root_object_row1.background_color
				compare_subrows(root_object_row1,root_object_row2)
				if root_object_row1.background_color = l_default_color then
					highlight_identical_rows (root_object_row1, root_object_row2)
				end
			else
				highlight_identical_rows (root_object_row1, root_object_row2)
			end
		end



feature {NONE} -- Implementation


	compare_subrows (a_parent_row1, a_parent_row2: EV_GRID_ROW)
			-- compare subrows recursively
		require
			not_void: a_parent_row1 /= void and a_parent_row2 /= void
			valid: a_parent_row1.subrow_count > 0 and a_parent_row2.subrow_count > 0
		local
			l_sub_row,l_partner_row:EV_GRID_ROW
			i,count:INTEGER
			l_internal:INTERNAL
		do
			create l_internal
			count := a_parent_row1.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_parent_row1.subrow (i)
				l_partner_row := find_row_in_subrows(l_sub_row,a_parent_row2)
				if l_partner_row /= void then
					-- object2 also has an attribute with the same name
					l_internal.mark (l_partner_row)
					if l_sub_row.subrow_count > 0 then
						if l_partner_row.subrow_count > 0 then
							-- two complex attributes, the same name -> also check type
							-- otherwise they are different anyway
							if are_attribute_types_equal(l_sub_row,l_partner_row) then
								compare_subrows(l_sub_row,l_partner_row)
							else
								-- types do not match
								highlight_difference (l_sub_row, l_partner_row)
							end

						else
							-- object2 attribute is not complex
							-- must be different
							highlight_difference (l_sub_row, l_partner_row)
						end
					elseif l_partner_row.subrow_count > 0 then
						-- object2 attribute is complex
						-- but object1 attribute was not comples
						-- must be different
						highlight_difference (l_sub_row, l_partner_row)
					else
						-- both attributes are not complex
						if not are_attribute_values_equal(l_sub_row,l_partner_row) then
							highlight_difference (l_sub_row, l_partner_row)
						end
					end

				else
					-- object2 does not have an attribtue with this name
					highlight_additional_attribute(l_sub_row,true)
					highlight_all_parent_rows (l_sub_row)
					highlight_all_parent_rows (a_parent_row2.subrow (1))
				end

				i := i + 1
			end

			-- go through object2 rows
			count := a_parent_row2.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_parent_row2.subrow (i)
				if not l_internal.is_marked (l_sub_row) then
					-- attribute not handled before
					-- must be additional in object2
					highlight_additional_attribute(l_sub_row,false)
					highlight_all_parent_rows (l_sub_row)
					highlight_all_parent_rows (a_parent_row1.subrow (1))
				else
					-- attribute was already handled
					l_internal.unmark (l_sub_row)
				end

				i := i + 1
			end


		end




	find_row_in_subrows (a_row: EV_GRID_ROW; a_parent_of_subrows: EV_GRID_ROW): EV_GRID_ROW
			-- tries to find a_row inside the subrows of a_parent_of_subrows
			-- if present -> result will be the found subrow
			-- else -> result := void
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
			abort:BOOLEAN
		do
			count := a_parent_of_subrows.subrow_count
			from
				i := 1
			until
				i > count or abort
			loop
				l_sub_row := a_parent_of_subrows.subrow (i)
				if are_attribute_names_equal (a_row, l_sub_row) then
					abort := true
					Result := l_sub_row
				end
				i := i + 1
			end
		end



	are_two_rows_identical (a_row1, a_row2: EV_GRID_ROW): BOOLEAN
			-- check whether two rows are identical or not
		local
			l_item1,l_item2:EV_GRID_LABEL_ITEM
		do
			Result := false
			l_item1 ?= a_row1.item (1)
			l_item2 ?= a_row2.item (1)
			if l_item1 /= void and l_item2 /= void then
				Result := l_item1.text.is_equal (l_item2.text)
				if result then
					l_item1 ?= a_row1.item (2)
					l_item2 ?= a_row2.item (2)
					if l_item1 /= void and l_item2 /= void then
						Result := l_item1.text.is_equal (l_item2.text)
					end
				end
			end
		end

	are_attribute_types_equal (a_row1, a_row2: EV_GRID_ROW): BOOLEAN
			-- two rows: type equality check
		local
			l_item1,l_item2:EV_GRID_LABEL_ITEM
			l_str1,l_str2:STRING
		do
			Result := false
			l_item1 ?= a_row1.item (3)
			l_item2 ?= a_row2.item (3)
			if l_item1 /= void and l_item2 /= void then
				create l_str1.make_from_string (l_item1.text)
				create l_str2.make_from_string (l_item2.text)
				l_str1.prune_all (' ')
				l_str2.prune_all (' ')
				Result := l_str1.is_equal (l_str2)
			end
		end


	are_attribute_names_equal (a_row1, a_row2: EV_GRID_ROW): BOOLEAN
			-- two rows: name equality check
		local
			l_item1,l_item2: EV_GRID_LABEL_ITEM
		do
			Result := false
			l_item1 ?= a_row1.item (1)
			l_item2 ?= a_row2.item (1)
			if l_item1 /= void and l_item2 /= void then
				Result := l_item1.text.is_equal (l_item2.text)
			end
		end

	are_attribute_values_equal (a_row1, a_row2: EV_GRID_ROW): BOOLEAN
			-- two rows: value equality check
		local
			l_item1,l_item2: EV_GRID_LABEL_ITEM
		do
			Result := false
			l_item1 ?= a_row1.item (2)
			l_item2 ?= a_row2.item (2)
			if l_item1 /= void and l_item2 /= void then
				Result := l_item1.text.is_equal (l_item2.text)
			end
		end


	highlight_difference (a_row1, a_row2: EV_GRID_ROW)
			-- highlights the differences of two rows
		do
			a_row1.set_background_color (compare_diff_color)
			a_row2.set_background_color (compare_diff_color)
			highlight_all_parent_rows(a_row1)
			highlight_all_parent_rows(a_row2)
		end

	highlight_all_parent_rows (a_row1: EV_GRID_ROW)
			-- highlight all parent rows
		do
			if a_row1.parent_row /= void and then a_row1.parent_row.background_color /= compare_diff_parents_color then
				a_row1.parent_row.set_background_color (compare_diff_parents_color)
				highlight_all_parent_rows(a_row1.parent_row)
			end
		end


	highlight_additional_attribute (a_row1: EV_GRID_ROW; is_on_left: BOOLEAN)
			-- additional attribute highlighting
		do
			if is_on_left then
				a_row1.set_background_color (compare_missing_on_left_color)
			else
				a_row1.set_background_color (compare_missing_on_right_color)
			end
		end

	highlight_identical_rows (a_row1, a_row2: EV_GRID_ROW)
			-- two rows are identical -> used for root-object rows
		do
			a_row1.set_background_color (compare_identical_color)
			a_row2.set_background_color (compare_identical_color)
		end




invariant
	invariant_clause: True -- Your invariant here

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
