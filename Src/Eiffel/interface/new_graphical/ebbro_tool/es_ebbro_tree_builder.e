note
	description: "Object which is responsible for populating an ebbro grid."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TREE_BUILDER

inherit
	ES_EBBRO_DISPLAY_CONST
	ES_EBBRO_TREE_FACILITY


create
	make

feature -- creation

	make
			-- init
		do
			create internal
			base_types.compare_objects
			base_string_types.compare_objects
			base_numeric_types.compare_objects
			root_object_count := 0
		end

feature -- establishment

	set_grid(a_grid_view:EV_GRID)
			-- sets the grid on which the tree should be build on
		require
			not_void: a_grid_view /= void
		do
			main_grid := a_grid_view
		end


feature -- basic operations


	display_object(an_obj:ES_EBBRO_DISPLAYABLE;a_file_name,an_object_name:STRING)
			-- action triggered when object decoded -> build browse tree
		require
			not_void: an_obj /= void
		local
			l_parent_row:EV_GRID_ROW
		do
			root_object_count := root_object_count + 1
			last_root_object := an_obj
			if an_object_name = void or else an_object_name.is_empty then
				-- update global count, not moving object
				global_root_object_count.set_item (global_root_object_count.item + 1)
			end

			if insert_at_top then
				main_grid.insert_new_row (1)
				l_parent_row := main_grid.row (1)
				last_root_object_index := 1
			else
				main_grid.insert_new_row (main_grid.row_count + 1)
				l_parent_row := main_grid.row (main_grid.row_count)
				last_root_object_index := main_grid.row_count
			end


			generate_root_object_row (l_parent_row, an_obj, a_file_name,an_object_name)
			l_parent_row.set_data ([an_obj,<<0>>])
			if an_obj.attr_cout > 0 then
				display_displayable_object (an_obj,l_parent_row)
				l_parent_row.expand
			elseif an_obj.is_wrapper then
				display_any_object (l_parent_row, an_obj.wrapped_object)
			end
		end

	update_obj_addresses
			-- event to update the object addresses
		local
			l_tuple:TUPLE[ANY,ARRAY[INTEGER]]
			l_obj:ANY
			l_item:EV_GRID_LABEL_ITEM
		do
			if main_grid.row_count > 0 then
				l_tuple ?= main_grid.row (1).data
				if l_tuple /= void then
					l_obj := l_tuple.reference_item (1)
					l_item ?= main_grid.row (1).item (4)
					l_item.set_text (object_addr_from_tagged_out (l_obj.tagged_out))
				end
				update_all_addresses (main_grid.row (1))
			end
		end

	set_allow_cyclic_browsing(a_val:BOOLEAN)
			-- enable cyclic browsing
		do
			cyclic_enabled := a_val
		end

	key_pressed(a_key:EV_KEY)
			-- a key was pressed
		do
			inspect a_key.code
			when {EV_KEY_CONSTANTS}.key_delete  then
				try_delete_root_object
			else

			end
		end

	remove_selected_root_object
			-- trys to remove selected root object
		do
			try_delete_root_object
		end

	set_insert_at_top(a_value:BOOLEAN)
			-- set insert at top / or bottom
		do
			insert_at_top := a_value
		end


feature --access

	last_root_object_index:INTEGER
			-- index of last inserted root object row

	last_root_object: ES_EBBRO_DISPLAYABLE


	insert_at_top:BOOLEAN
			-- are new objects inserted at the top or at the bottom?

feature {NONE} -- implementation

	main_grid:EV_GRID
			--main display grid

	internal:INTERNAL
			-- internal object

	cyclic_enabled:BOOLEAN
			-- is cyclic browsing enabled or not

	root_object_count:INTEGER
			-- the number of root objects (deserialized files)

	clean_up
			-- cleans up the main grid i.e removes rows and items
		do
			if main_grid.row_count > 0 then
				main_grid.clear
				main_grid.remove_rows (1,main_grid.row_count)
				main_grid.redraw
				main_grid.refresh_now
			end
			root_object_count := 0
		end

	display_displayable_object(an_obj:ES_EBBRO_DISPLAYABLE;a_parent:EV_GRID_ROW)
			-- generates rows for a object of type displayable
		require
			not_void: an_obj /= void and a_parent /= void
		local
			l_sub_row:EV_GRID_ROW
			l_attr:ARRAYED_LIST [TUPLE [object: ANY; name: STRING_8]]
			l_disp_values:TUPLE[name:STRING;value:STRING;type:STRING;addr:STRING]
			l_obj:ANY
			i:INTEGER
			l_disp_obj:ES_EBBRO_DISPLAYABLE
			l_grid_item1:EV_GRID_LABEL_ITEM
			l_is_cyclic:BOOLEAN
		do
			l_is_cyclic := an_obj.is_cyclic

			l_attr := an_obj.attributes
			from
				l_attr.start
				i := 1
			until
				l_attr.after
			loop
				a_parent.insert_subrow (i)
				l_sub_row := a_parent.subrow (i)
				l_obj := l_attr.item.object
				l_disp_obj ?= l_obj

				if l_obj = void then
					l_disp_values := get_display_values(l_attr.item)
					fill_grid_row (l_sub_row, l_disp_values,l_is_cyclic)
					l_grid_item1 ?= l_sub_row.item (1)
					set_pixmap_item (l_grid_item1, style_void)
				elseif base_types.has(l_obj.generating_type) then --
					l_disp_values := get_display_values(l_attr.item)
					fill_grid_row (l_sub_row, l_disp_values,l_is_cyclic)
					l_grid_item1 ?= l_sub_row.item (1)
					set_pixmap_item_base_type (l_grid_item1, l_obj)
					l_sub_row.set_data ([l_obj,<<0>>])
				elseif l_disp_obj /= void  then
					fill_grid_row(l_sub_row,[l_attr.item.name,"",l_disp_obj.class_name,object_addr_from_tagged_out(l_disp_obj.tagged_out)],l_is_cyclic)
					l_grid_item1 ?= l_sub_row.item (1)
					-- set pixmap
					if l_disp_obj.is_container then -- is void
						set_pixmap_item (l_grid_item1, style_container)
					elseif l_disp_obj.is_tuple then
						set_pixmap_item (l_grid_item1, style_tuple)
					else
						set_pixmap_item (l_grid_item1, style_reference)
					end
					l_sub_row.set_data ([l_disp_obj,<<0>>])
					if l_disp_obj.attr_cout > 0 then
						if check_parent(object_addr_from_tagged_out(l_disp_obj.tagged_out),l_sub_row) then
							l_sub_row.ensure_expandable
							l_sub_row.expand_actions.extend (agent on_expanding_disp_object(l_sub_row))
						else
							display_displayable_object (l_disp_obj, l_sub_row)
						end
						--l_sub_row.collapse_actions.extend(agent on_collapsing_disp_object(l_disp_obj,l_sub_row))
					end
				else
					--already set attribute name
					create l_grid_item1.make_with_text (l_attr.item.name)
					l_sub_row.set_item (1, l_grid_item1)
					-- display it
					display_any_object(l_sub_row,l_obj)
				end
				l_attr.forth
				i := i + 1
			end

		end

	display_any_object(a_row:EV_GRID_ROW;an_obj:ANY)
			-- generates rows for any given object
		require
			not_void: a_row /= void
		local
			l_array:ARRAY[ANY]
			l_spec:SPECIAL[ANY]
			l_lin:LINEAR[ANY]
			l_hash_table:HASH_TABLE[ANY,HASHABLE]
			l_trav_set:TRAVERSABLE_SUBSET[ANY]
			l_disp:ES_EBBRO_DISPLAYABLE
			l_active:ACTIVE[ANY]
			l_grid_item1:EV_GRID_LABEL_ITEM
			l_item:EV_GRID_LABEL_ITEM
			l_container:CONTAINER[ANY]
			l_item_factory: ES_EBBRO_ITEM_FACTORY
		do
			l_array ?= an_obj
			l_disp ?= an_obj
			l_lin ?= an_obj
			l_hash_table ?= an_obj
			l_trav_set ?= an_obj
			l_spec ?= an_obj
			l_active ?= an_obj
			l_container ?= an_obj

			create l_item_factory.make

			if an_obj = void then
				l_item ?= a_row.item (1)
				set_pixmap_item (l_item,style_void)
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (void_value))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (void_type))
			elseif base_types.has(an_obj.generating_type) then --
				l_item ?= a_row.item (1)
				set_pixmap_item_base_type (l_item, an_obj)
				a_row.set_item (2, l_item_factory.create_item (an_obj.out, an_obj.generating_type,false))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (an_obj.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(an_obj.tagged_out)))
				--a_row.set_data ([an_obj,<<0>>])
			elseif internal.is_tuple (an_obj) then
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (an_obj.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(an_obj.tagged_out)))
				--a_row.set_data ([an_obj,<<0>>])
				display_tuple_type(a_row,an_obj)
			elseif l_array /= void then
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_array.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_array.tagged_out)))
				--a_row.set_data ([l_array,<<0>>])
				display_array_type (a_row,l_array)
			elseif l_disp /= void then
				l_item ?= a_row.item (1)
				-- set pixmap
				if l_disp.is_container then -- is void
					set_pixmap_item (l_item, style_container)
				elseif l_disp.is_tuple then
					set_pixmap_item (l_item, style_tuple)
				else
					set_pixmap_item (l_item, style_reference)
				end
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				create l_grid_item1.make_with_text (l_disp.class_name)
				a_row.set_item (3,l_grid_item1)
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_disp.tagged_out)))
				a_row.set_data ([l_disp,<<0>>])
				if l_disp.attr_cout > 0 then
					if check_parent(object_addr_from_tagged_out(l_disp.tagged_out),a_row) then
						a_row.ensure_expandable
						a_row.expand_actions.extend (agent on_expanding_disp_object(a_row))
					else
						display_displayable_object (l_disp, a_row)
					end
					--l_sub_row.collapse_actions.extend(agent on_collapsing_disp_object(l_disp_obj,l_sub_row))
				end
			elseif l_trav_set/= void then
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_trav_set.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_trav_set.tagged_out)))
				--a_row.set_data ([l_trav_set,<<0>>])
				display_traversable_set_type (a_row, l_trav_set)
			elseif l_hash_table /= void then
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_hash_table.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_hash_table.tagged_out)))
				--a_row.set_data ([l_hash_table,<<0>>])
				display_hash_table_type(a_row, l_hash_table)
			elseif l_spec /= void then
					-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_spec.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_spec.tagged_out)))
				--a_row.set_data ([l_spec,<<0>>])
				display_special_type (a_row,l_spec)
			elseif l_active /= void then
					-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_active.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_active.tagged_out)))
				--a_row.set_data ([l_active,<<0>>])
				display_active_type (a_row,l_active)
			elseif l_lin /= void or l_container /= void then
				-- display any container, get linear representation
				if l_lin = void then
					l_lin := l_container.linear_representation
				end
				-- empty value field
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (l_lin.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(l_lin.tagged_out)))
				--a_row.set_data ([l_lin,<<0>>])
				display_linear_type (a_row, l_lin)
			else
				-- just use out on object...
				l_item ?= a_row.item (1)
				set_pixmap_item_base_type (l_item, an_obj)
				a_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (an_obj.out))
				a_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (an_obj.generating_type))
				a_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (object_addr_from_tagged_out(an_obj.tagged_out)))

				--set tooltip
				a_row.item (1).set_tooltip (an_obj.out)
				--a_row.set_data ([an_obj,<<0>>])
			end

		end

	display_tuple_type(a_row:EV_GRID_ROW;an_obj:ANY)
			-- generates display rows for tuple objects
		require
			not_void: a_row /= void and an_obj /= void
		local
			a_tuple:TUPLE
			i:INTEGER
			l_sub_row:EV_GRID_ROW
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_tuple)
			a_tuple ?= an_obj
			if a_tuple /= void then
				from
					i := 1
				until
					i > a_tuple.count
				loop
					a_row.insert_subrow (i)
					l_sub_row := a_row.subrow (i)
					l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
					display_any_object (l_sub_row, a_tuple.item (i))
					i := i + 1
				end
			else
				check
					ERROR:false
				end
			end
		end

	display_linear_type(a_row:EV_GRID_ROW;an_obj:LINEAR[ANY])
			-- generates display rows for sequence type objects
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_sub_row:EV_GRID_ROW
			i:INTEGER
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_container)
			from
				an_obj.start
				i := 1
			until
				an_obj.after
			loop
				a_row.insert_subrow (i)
				l_sub_row := a_row.subrow (i)
				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
				display_any_object (l_sub_row, an_obj.item)
				i := i+1
				an_obj.forth
			end
		end

	display_traversable_set_type(a_row:EV_GRID_ROW;an_obj:TRAVERSABLE_SUBSET[ANY])
			-- generates display rows for traversable subset type objects
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_sub_row:EV_GRID_ROW
			i:INTEGER
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_container)
			from
				an_obj.start
				i := 1
			until
				an_obj.after
			loop
				a_row.insert_subrow (i)
				l_sub_row := a_row.subrow (i)
				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
				display_any_object (l_sub_row, an_obj.item)
				i := i+1
				an_obj.forth
			end
		end

	display_hash_table_type(a_row:EV_GRID_ROW;an_obj:HASH_TABLE[ANY,HASHABLE])
			-- generates display rows for hash table objects
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_sub_row,l_item_row,l_key_row:EV_GRID_ROW
			i:INTEGER
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_container)
			from
				an_obj.start
				i := 1
			until
				an_obj.after
			loop
				a_row.insert_subrow (i)
				l_sub_row := a_row.subrow (i)
				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
				l_sub_row.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text ("pair (key,item)"))
				l_sub_row.set_item (3, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				l_sub_row.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (""))
				-- no data set on this subrow ...

				-- insert key row
				l_sub_row.insert_subrow (1)
				l_key_row := l_sub_row.subrow (1)
				l_key_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text ("key"))
				display_any_object (l_key_row, an_obj.key_for_iteration)

				-- insert item row
				l_sub_row.insert_subrow (2)
				l_item_row := l_sub_row.subrow (2)
				l_item_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text ("item"))
				display_any_object (l_item_row, an_obj.item_for_iteration)
				i := i+1
				an_obj.forth
			end
		end


	display_array_type(a_row:EV_GRID_ROW;an_obj:ARRAY[ANY])
			-- generates display rows for an array type object
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_sub_row:EV_GRID_ROW
			i:INTEGER
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_container)
			from
				i := 1
			until
				i > an_obj.count
			loop
				a_row.insert_subrow (i)
				l_sub_row := a_row.subrow (i)
				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
				display_any_object (l_sub_row, an_obj.item (i))
				i := i + 1
			end
		end

	display_active_type(a_row:EV_GRID_ROW;an_obj:ACTIVE[ANY])
			-- generates display rows for an active type object
		require
			not_void: a_row /= void and an_obj /= void
		local
--			l_sub_row:EV_GRID_ROW
--			i:INTEGER
--			l_item:EV_GRID_LABEL_ITEM
		do
			--use linear representation ..seems to be nicer
			display_linear_type (a_row, an_obj.linear_representation)
--			l_item ?= a_row.item (1)
--			set_pixmap_item (l_item, style_container)
--			from
--				i := 1
--				an_obj.
--			until
--				an_obj.is_empty
--			loop
--				a_row.insert_subrow (i)
--				l_sub_row := a_row.subrow (i)
--				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (i.out))
--				display_any_object (l_sub_row, an_obj.item)
--				an_obj.remove
--				i := i + 1
--			end
		end

	display_special_type(a_row:EV_GRID_ROW;an_obj:SPECIAL[ANY])
			-- generates display rows for a special type object
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_sub_row:EV_GRID_ROW
			i,count:INTEGER
			l_item:EV_GRID_LABEL_ITEM
		do
			l_item ?= a_row.item (1)
			set_pixmap_item (l_item, style_container)
			from
				i := 0
				count := an_obj.count
			until
				i = count
			loop
				a_row.insert_subrow (i+1)
				l_sub_row := a_row.subrow (i+1)
				l_sub_row.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text ((i).out))
				display_any_object (l_sub_row, an_obj.item (i))
				i := i + 1
			end
		end


	get_display_values(a_tuple:TUPLE [object: ANY; name: STRING_8]):TUPLE[name:STRING;value:STRING;type:STRING;addr:STRING]
			-- gets display values of basic type
		do
			create result
			result.name := a_tuple.name
			if a_tuple.object /= void then
				result.type := a_tuple.object.generating_type
				result.value := a_tuple.object.out
				result.addr := object_addr_from_tagged_out (a_tuple.object.tagged_out)
			else
				result.type := void_type
				result.value := void_value
				result.addr := void_addr
			end
		end

	fill_grid_row(a_row:EV_GRID_ROW;a_tuple:TUPLE[name:STRING;value:STRING;type:STRING;addr:STRING];is_parent_cyclic:BOOLEAN)
			-- fills a grid row with provided values
		require
			not_void: a_tuple /= void and a_row /= void
		local
			l_grid_item1,l_grid_item3,l_grid_item4:EV_GRID_LABEL_ITEM
			l_grid_item2: EV_GRID_ITEM
			item_factory: ES_EBBRO_ITEM_FACTORY
		do
			create item_factory.make
			create l_grid_item1.make_with_text (a_tuple.name)
			--create l_grid_item2.make_with_text (a_tuple.value)
			l_grid_item2 := item_factory.create_item (a_tuple.value, a_tuple.type,is_parent_cyclic)
			create l_grid_item3.make_with_text (a_tuple.type)
			create l_grid_item4.make_with_text (a_tuple.addr)
			a_row.set_item (1, l_grid_item1)
			a_row.set_item (2, l_grid_item2)
			a_row.set_item (3, l_grid_item3)
			a_row.set_item (4, l_grid_item4)
		end

	generate_root_object_row(a_row:EV_GRID_ROW;an_obj:ES_EBBRO_DISPLAYABLE;a_file_name,an_object_name:STRING)
			-- generates initial row for object which was decoded
		require
			not_void: a_row /= void and an_obj /= void
		local
			l_grid_item,l_grid_item2,l_grid_item3,l_grid_item4:EV_GRID_LABEL_ITEM
		do
			if an_object_name = void or else an_object_name.is_empty then
				create l_grid_item.make_with_text (root_object_name+global_root_object_count.out)
			else
				create l_grid_item.make_with_text (an_object_name)
			end

			create l_grid_item2.make_with_text ("")
			create l_grid_item3.make_with_text (an_obj.class_name)
			create l_grid_item4.make_with_text (object_addr_from_tagged_out(an_obj.tagged_out))

			-- set pixmap
			set_pixmap_item (l_grid_item, style_reference)

			-- set foreground color
			l_grid_item.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (root_red_color, root_green_color, root_blue_color))

			-- set tooltip
			l_grid_item.set_tooltip (a_file_name)


			a_row.set_item (1, l_grid_item)
			a_row.set_item (2, l_grid_item2)
			a_row.set_item (3, l_grid_item3)
			a_row.set_item (4, l_grid_item4)
		end

	set_pixmap_item(an_item:EV_GRID_LABEL_ITEM;id:INTEGER)
			-- sets a pixmap to an item given ´an_item´and a style ´id´
		do
			inspect id
			when style_container then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_container))
			when style_tuple then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_tuple))
			when style_reference then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_reference))
			when style_expanded then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_base))
			when style_void then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_void))
			when style_cycle then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_cycle_reference))
			when style_pointer then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_pointer))
			else
				check
					unkown_style:false
				end
			end
		end

	set_pixmap_item_base_type(an_item:EV_GRID_LABEL_ITEM;an_obj:ANY)
			-- sets the correct item for a base type object
		require
			not_void: an_item /= void and an_obj /= void
		local
			l_gen_type:STRING
			l_pointer:POINTER_REF
		do
			l_gen_type := an_obj.generating_type
			l_pointer ?= an_obj
			if l_pointer /= void then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_pointer))
			elseif base_string_types.has (l_gen_type) then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_string))
			elseif base_numeric_types.has(l_gen_type) then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_numeric))
			elseif base_boolean_type.is_equal(l_gen_type) then
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_boolean))
			else
				an_item.set_pixmap (pixmap_hashtable.item (pixmap_base))
			end
		end


	mark_same_addr(a_row,a_parents_row:EV_GRID_ROW)
			-- marks the same addresses (cyclic reference)
		require
			not_void: a_row /= void and a_parents_row /= void
		local
			l_color:EV_COLOR
			l_rand:RANDOM
			l_item,l_item2:EV_GRID_LABEL_ITEM
			l_col1,l_col2,l_col3:INTEGER
			l_addr:STRING
		do
			l_item ?= a_parents_row.item (4)
			l_item2 ?= a_row.item (4)
			l_addr := l_item.text
			l_color ?= l_item.data
			if l_color = void then
				create l_rand.make
				l_rand.set_seed (a_row.index * 1000 + a_parents_row.index * 1000 + l_addr.hash_code )
				l_rand.forth
				l_col1 := l_rand.item \\ 255
				l_rand.forth
				l_col2 := l_rand.item \\ 255
				l_rand.forth
				l_col3 := l_rand.item \\ 255
				-- prevent to dark colors
				if l_col1 <=35 and l_col2 <= 35 and l_col3 <= 35 then
					l_rand.forth
					l_col2 := l_rand.item \\ 200
					l_col2 := l_col2 + 50
				end
				create l_color.make_with_8_bit_rgb (l_col1,l_col2 ,l_col3)
				l_item.set_data (l_color)
			end
			l_item.set_background_color (l_color)
			l_item2.set_background_color (l_color)
			if not l_item2.text.is_equal (l_addr) then
				-- object addresses have changed, update view...
				update_obj_addresses
				--l_item2.set_text (l_addr)
			end
		end

	update_all_addresses(a_row:EV_GRID_ROW)
			-- updates the address column with the current addresses
		local
			i,count:INTEGER
			l_obj:TUPLE[ANY,ARRAY[INTEGER]]
			l_item:EV_GRID_LABEL_ITEM
			l_sub_row:EV_GRID_ROW
		do
			count := a_row.subrow_count
			from
				i := 1
			until
				i > count
			loop
				l_sub_row := a_row.subrow (i)
				l_obj ?= l_sub_row.data
				if l_obj /= void then
					l_item ?= a_row.subrow (i).item (4)
					l_item.set_text (object_addr_from_tagged_out (l_obj.reference_item (1).tagged_out))
				end
				if l_sub_row.subrow_count > 0 then
					update_all_addresses (l_sub_row)
				end
				i := i + 1
			end
		end

	update_root_object_names
			-- updates all the root object names
		local
			l_row:EV_GRID_ROW
			l_item:EV_GRID_LABEL_ITEM
			i,curr:INTEGER
		do
			if main_grid.row_count > 0 then
				from
					i := 1
					curr := 1
				until
					i > root_object_count
				loop
					l_row := main_grid.row(curr)
					l_item ?= l_row.item (1)
					l_item.set_text (root_object_name+i.out)

					curr := l_row.subrow_count_recursive + curr + 1

					i := i + 1
				end
			end
		end


feature{NONE} -- implementation key press commands

	try_delete_root_object
			-- delete selected root object
		local
			l_row:EV_GRID_ROW
		do
			if not main_grid.selected_rows.is_empty then
				--single selection is assumed
				l_row := main_grid.selected_rows.i_th (1)
				if l_row.parent_row = void then
					main_grid.remove_row (l_row.index)
					root_object_count := root_object_count - 1
					--update_root_object_names
				end
			end
		end


feature{NONE} -- implementation actions

	on_expanding_disp_object(a_parent:EV_GRID_ROW)
			-- action called when expanding a row
		local
			l_obj_addr:STRING
			l_tuple:TUPLE[ES_EBBRO_DISPLAYABLE,ARRAY[INTEGER]]
			l_obj:ES_EBBRO_DISPLAYABLE
			l_item:EV_GRID_LABEL_ITEM
		do
			l_tuple ?= a_parent.data
			l_obj ?= l_tuple.reference_item (1)
			l_obj_addr := object_addr_from_tagged_out(l_obj.tagged_out)
			--check parent
			if a_parent.subrow_count = 0 and then check_parent(l_obj_addr,a_parent) then
				-- user is entering a rekursion...
				mark_same_addr(a_parent,found_parent)
				l_item ?= a_parent.item (1)
				l_item.set_tooltip (tooltip_cycle)
				set_pixmap_item (l_item, style_cycle)

				if a_parent.subrow_count = 0 and cyclic_enabled then
					l_obj.set_is_cyclic

					a_parent.set_data ([l_obj,<<0>>])
					display_displayable_object (l_obj, a_parent)
				else
					a_parent.ensure_expandable
				end
			elseif a_parent.subrow_count = 0 then
				a_parent.set_data ([l_obj,<<0>>])
				display_displayable_object (l_obj, a_parent)
			end
		end

	on_collapsing_disp_object(an_obj:ES_EBBRO_DISPLAYABLE;a_parent:EV_GRID_ROW)
			-- not used at the moment
		do
			--main_grid.remove_rows (a_parent.index, a_parent.subrow_count_recursive)
			--i := a_parent.index
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
