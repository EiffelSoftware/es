note
	description: "Object which is handles filter funcionality on an ebbro grid"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TREE_FILTER

inherit
	ES_EBBRO_DISPLAY_CONST
	ES_EBBRO_TREE_FACILITY

create
	make
feature -- init

	make
			-- creation
		do
			filter_in := false
		end

feature -- basic operations

	set_grid(a_grid_view:EV_GRID)
			-- sets the grid on which the tree should be build on
		require
			not_void: a_grid_view /= void
		do
			main_grid := a_grid_view
		end

	set_filter_in(a_value:BOOLEAN)
			-- sets the filter in flag and updates accordingly
		do
			filter_in := a_value
			update_filtered_objects
		end


feature -- settings

	filter_in:BOOLEAN
			-- is filter in active


feature -- filter activations

	activate_void_filter(a_row:EV_GRID_ROW)
			-- activates the void filter on a row
		do
			reset_object_filter (a_row)
			filter_void_objects (a_row)
		end

	activate_cycle_filter(a_row:EV_GRID_ROW)
			-- activates a cycle filter on a row
		do
			reset_object_filter (a_row)
			filter_cycle_objects(a_row)
		end

	reset_object_filter(a_row:EV_GRID_ROW)
			-- resets all filters and shows all objects on a row
		do
			show_all_objects(a_row)
		end

feature{NONE} --implementation access

	main_grid:EV_GRID
			--main display grid

feature{NONE} --implementation


	update_filtered_objects
			-- updates the filters on all root objects
			-- used when filter options change (filter IN / OUT)
		local
			l_row:EV_GRID_ROW
			curr,l_count:INTEGER
			l_tuple:TUPLE[ANY,ARRAY[INTEGER]]
			l_filter:ARRAY[INTEGER]
		do
			if main_grid.row_count > 0 then
				from
					l_count := main_grid.row_count
					curr := 1
				until
					curr > l_count
				loop
					l_row := main_grid.row(curr)
					l_tuple ?= l_row.data
					l_filter ?= l_tuple.reference_item(2)

					-- only one filter active in this implementation
					inspect l_filter.item (1)
					when none_filter_id then
						--do nothing
					when void_filter_id then
						filter_void_objects(l_row)
					when cycle_filter_id then
						filter_cycle_objects (l_row)
					else

					end

					curr := l_row.subrow_count_recursive + curr + 1
				end
			end
		end


	show_all_objects(a_row:EV_GRID_ROW)
			-- show all objects - none filter
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_row.subrow (i)
				l_sub_row.show
				if l_sub_row.subrow_count > 0 then
					show_all_objects(l_sub_row)
				end
				i := i + 1
			end
		end


	has_void_subrow(a_row:EV_GRID_ROW):BOOLEAN
			-- help routine which checks whether row has a void object in a subrow or not (recursive)
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count or result
			loop
				l_sub_row := a_row.subrow (i)
				if l_sub_row.subrow_count > 0 then
					result := has_void_subrow(l_sub_row)
				elseif {l_item:EV_GRID_LABEL_ITEM} l_sub_row.item (3) and then l_item.text.is_equal (void_type)  then
					result := true
				end
				i := i + 1
			end
		end

	has_cycle_subrow(a_row:EV_GRID_ROW):BOOLEAN
			-- help routine which checks whether row has cycle object in a subrow or not (recursive)
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
			data:TUPLE[ANY,ARRAY[INTEGER]]
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count or result
			loop
				l_sub_row := a_row.subrow (i)
				data ?= l_sub_row.data
				if data /= void and then check_parent (object_addr_from_tagged_out (data.reference_item (1).tagged_out), l_sub_row.parent_row) then
					result := true
				elseif l_sub_row.subrow_count > 0 then
					result := has_cycle_subrow(l_sub_row)
				end
				i := i + 1
			end
		end



	filter_void_objects(a_row:EV_GRID_ROW)
			-- filters out / in void objects ( recursive)
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_row.subrow (i)
				if filter_in then
					if l_sub_row.subrow_count > 0 and then has_void_subrow (l_sub_row) then
						filter_void_objects(l_sub_row)
					else
						if {l_item:EV_GRID_LABEL_ITEM} l_sub_row.item (3) and then not l_item.text.is_equal (void_type) then
							l_sub_row.hide
						else
							l_sub_row.show
						end
					end
				else
					--filter out
					if l_sub_row.subrow_count > 0 then
						filter_void_objects(l_sub_row)
					else
						if {l_item2:EV_GRID_LABEL_ITEM} l_sub_row.item (3) and then l_item2.text.is_equal (void_type) then
							l_sub_row.hide
						else
							l_sub_row.show
						end
					end
				end

				i := i + 1
			end
		end

	filter_cycle_objects(a_row:EV_GRID_ROW)
			-- filters out / in cycle objects (recursive)
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
			data:TUPLE[ANY,ARRAY[INTEGER]]
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_row.subrow (i)
				if filter_in then
					if l_sub_row.subrow_count > 0 and then has_cycle_subrow (l_sub_row) then
						filter_cycle_objects(l_sub_row)
					else
						data ?= l_sub_row.data
						if data /= void and then not check_parent (object_addr_from_tagged_out (data.reference_item(1).tagged_out), l_sub_row) then
							l_sub_row.hide
						elseif data = void then
							l_sub_row.hide
						else
							l_sub_row.show
						end
					end
				else
					--filter out
					data ?= l_sub_row.data
					if data /= void and then check_parent (object_addr_from_tagged_out (data.reference_item(1).tagged_out), l_sub_row) then
						l_sub_row.hide
					elseif l_sub_row.subrow_count > 0 then
						filter_cycle_objects(l_sub_row)
					else
						l_sub_row.show
					end
				end

				i := i + 1
			end
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
