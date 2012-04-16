note
	description: "Objects that provide editing possibility of a primitive type"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_EDITABLE_PRIMITIVE_ITEM

inherit
	EV_GRID_EDITABLE_ITEM
	ES_EBBRO_DISPLAY_CONST
	undefine
		copy, default_create
	end

create
	make_with_text_and_type,
	default_create,
	make_with_text

feature -- Creation

	make_with_text_and_type (a_text: STRING; a_type: STRING)
			-- adds the needed actions after initialization
		do
			default_create
			set_text (a_text)
			type := a_type
			set_text_validation_agent (agent update_value )
		end

feature {NONE}-- Implementation

	type: STRING

	update_value (a_value: STRING_32): BOOLEAN
			-- after the user changed the value in the gui,
			-- update that value in the DECODED object
		local
			l_root_obj: ANY
			retried:BOOLEAN
			l_prompt_provider:ES_PROMPT_PROVIDER
			l_window:EB_SHARED_WINDOW_MANAGER
		do
			if not retried then
				if not a_value.is_equal (text) and validate_input (a_value) then
					-- only update if value is different than already exisiting value
					l_root_obj := get_root_object
					if attached {ES_EBBRO_DISPLAYABLE} l_root_obj as l_root_disp then
						if l_root_disp.is_wrapper then
							if find_row_nondecoded (row.index - get_root_row_index + 1, l_root_disp.wrapped_object, a_value) = 0 then
								--set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 180, 180))
								Result := validate_input (a_value)
							else
								Result := false
							end
						elseif l_root_disp.original_decoded /= void  then
							if find_row_decoded (row.index - get_root_row_index + 1, l_root_disp.original_decoded, a_value) = 0 then
								--set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 180))
								Result := validate_input (a_value)
							else
								Result := false
							end
						end
					else
						-- simple known type
						if find_row_nondecoded (row.index - get_root_row_index + 1, l_root_obj, a_value) = 0 then
							--set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 180, 180))
							Result := true
						else
							Result := false
						end
					end

					if result then
						update_all_possible_shared_values(a_value)

						--add to history
						if attached {ES_EBBRO_DISPLAYABLE} l_root_obj as l_root_disp2 then
							l_root_disp2.history.add_item (current, current.text, a_value)
						end
					end
				else
					-- old and new value are the same or not valid input
					Result := False
				end
			else
				result := false
			end
		rescue
			retried := true
			create l_window
			create l_prompt_provider
			l_prompt_provider.show_error_prompt (update_value_error_msg, l_window.window_manager.last_focused_development_window.window, void)
			retry
		end


	validate_input (a_value: STRING): BOOLEAN
			-- test if a value entered is conform to a type
		local
			l_type_name: STRING
			l_label_item: EV_GRID_LABEL_ITEM
		do
			l_label_item ?= row.item (3)
			l_type_name := l_label_item.text

			if l_type_name.is_equal ("INTEGER_8") then
				Result := a_value.is_integer_8
			elseif l_type_name.is_equal ("INTEGER_16") then
				Result := a_value.is_integer_16
			elseif l_type_name.is_equal ("INTEGER_32") then
				Result := a_value.is_integer_32
			elseif l_type_name.is_equal ("INTEGER_64") then
				Result := a_value.is_integer_64

			elseif l_type_name.is_equal ("BOOLEAN") then
				Result := a_value.is_boolean

			elseif l_type_name.is_equal ("NATURAL_8") then
				Result := a_value.is_natural_8
			elseif l_type_name.is_equal ("NATURAL_16") then
				Result := a_value.is_natural_16
			elseif l_type_name.is_equal ("NATURAL_32") then
				Result := a_value.is_natural_32
			elseif l_type_name.is_equal ("NATURAL_64") then
				Result := a_value.is_natural_64

			elseif l_type_name.is_equal ("REAL_32") then
				Result := a_value.is_real
			elseif l_type_name.is_equal ("REAL_64") then
				Result := a_value.is_double

			elseif l_type_name.is_equal ("STRING_8") then
				Result := true
			elseif l_type_name.is_equal ("STRING_32") then
				Result := true
			elseif l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER_32") or l_type_name.is_equal ("CHARACTER_REF") then
				Result := is_valid_character_type (a_value)
			end
		end



--	find_row_decoded (a_position: INTEGER; a_decoded: GENERAL_DECODED; a_new_value: STRING): INTEGER
		-- recursive breadth first search through a decoded object to find the field at position `a_position'.
		-- returns the remaining positions to search if not found
		-- returns 0 if the field was found, -1 if not found
--		local
--			i,pos: INTEGER
--			attr: ANY
--			internal: INTERNAL
--		do
--			create internal
--			internal.mark (a_decoded)
				-- to prevent recursive searching
--			from
--				i := 1
--				pos := a_position
--			until
--				i > a_decoded.attribute_values.count or pos <= 0
--			loop
--				pos := pos - 1
--				attr := a_decoded.attribute_values.i_th (i).object
--				if attr /= void then
--					if base_types.has (attr.generating_type) then
--						if pos = 1 then
--							-- found: update the attribute of that decoded object
--							change_value_decoded (a_decoded, a_new_value, i)
--							pos := 0
--						end
--					elseif not internal.is_marked (attr) then
--						if {a_dec_attr: GENERAL_DECODED} attr then
--							pos := find_row_decoded (pos, a_dec_attr, a_new_value)
--						elseif {arr: ARRAY[ANY]} attr then
							--array type
--							pos := find_row_array (pos, arr, a_new_value)
--						elseif {spec:SPECIAL[ANY]} attr then
							--special type
							--TODO: implement for special types
--							pos := find_row_special(pos,spec,a_new_value)
--						elseif {chain:CHAIN[ANY]} attr then
--							pos := find_row_chain(pos,chain,a_new_value)
--						elseif {l_tuple:TUPLE[ANY]} attr then
--							pos := find_row_tuple(pos,l_tuple,a_new_value)
--						elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} attr then
--							pos := find_row_hashtable(pos,l_hash,a_new_value)
--						else
--							pos := find_row_nondecoded (pos, attr, a_new_value)
--						end

--					end
--				else
					--pos := pos + 1
					--cycle_abort := true
--				end
--				i := i + 1

--			end
--			Result := pos
--			internal.unmark (a_decoded)
--		end

	find_row_nondecoded(a_position: INTEGER; a_obj: ANY; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			i: INTEGER
			field: ANY
			pos: INTEGER
		do
	--		create internal
	--		pos := a_position
	--		internal.mark (a_obj)
	--		if {root_array: ARRAY[ANY]} a_obj then
	--			pos := find_row_array (pos, root_array, a_new_value)
	--		elseif {root_spec:SPECIAL[ANY]} a_obj then
	--			pos := find_row_special (pos, root_spec, a_new_value)
	--		elseif {root_chain:CHAIN[ANY]} a_obj then
	--			pos := find_row_chain(pos,root_chain,a_new_value)
	--		elseif {root_tuple:TUPLE[ANY]} a_obj then
	--			pos := find_row_tuple(pos,root_tuple,a_new_value)
	--		elseif {root_hash:HASH_TABLE[ANY,HASHABLE]} a_obj then
	--			pos := find_row_hashtable(pos,root_hash,a_new_value)
	--		else
	--			from
	--				i := 1
	--			until
	--				i > internal.field_count (a_obj) or pos <= 0
	--			loop
	--				pos := pos - 1
	--				field := internal.field (i, a_obj)
--
--					if field /= Void then
--						if base_types.has (field.generating_type) then
--								--base type
--							if pos = 1 then
--								change_value_nondecoded (a_obj, a_new_value, i)
--
--								pos := 0
---							end
--						elseif not internal.is_marked (field) then
--					--		if {a_dec: GENERAL_DECODED} field then
--								--decoded
					--			pos := find_row_decoded (pos, a_dec, a_new_value)
					--		elseif {arr: ARRAY[ANY]} field then
								-- array type
					--			pos := find_row_array (pos, arr, a_new_value)
					--		elseif {spec:SPECIAL[ANY]} field then
								--special type
								--TODO: implement for special types
					--			pos := find_row_special(pos,spec,a_new_value)
					--		elseif {chain:CHAIN[ANY]} field then
					--			pos := find_row_chain(pos,chain,a_new_value)
					--		elseif {l_tuple:TUPLE[ANY]} field then
					--			pos := find_row_tuple(pos,l_tuple,a_new_value)
					--		elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
					--			pos := find_row_hashtable(pos,l_hash,a_new_value)
					--		else
					--			pos := find_row_nondecoded (pos, field, a_new_value)
					--		end
					--	end
				--	end
				--	i := i + 1
			--	end
		--	end
		--	Result := pos
		--	internal.unmark (a_obj)
		end


	find_row_array(a_position: INTEGER; an_array: ARRAY[ANY]; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			i: INTEGER
			field: ANY
			pos: INTEGER
		do
	--		create internal
	--		pos := a_position
	--		internal.mark (an_array)
	--		from
	--			i := 1
	--		until
	--			i > an_array.count or pos <= 0
	--		loop
	--			pos := pos -1
	--			field := an_array.item (i)
	--			if field /= Void then
	--				if base_types.has (field.generating_type) then
	--						--base type
	--					if pos = 1 then
	--						change_value_array (an_array, a_new_value, a_position)
	--						pos := 0
	--					end
	--				elseif not internal.is_marked (field) then
	--		--			if {a_dec: GENERAL_DECODED} field then
			--				--decoded
			--				pos := find_row_decoded (pos, a_dec, a_new_value)
			--			elseif {spec:SPECIAL[ANY]} field then
							--special type
							--TODO: implement for special types
			--				pos := find_row_special(pos,spec,a_new_value)
			--			elseif {arr: ARRAY[ANY]} field then
			--				-- array type
			--				pos := find_row_array (pos, arr, a_new_value)
			--			elseif {chain:CHAIN[ANY]} field then
			--					pos := find_row_chain(pos,chain,a_new_value)
			--			elseif {l_tuple:TUPLE[ANY]} field then
			--					pos := find_row_tuple(pos,l_tuple,a_new_value)
			--			elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
			--					pos := find_row_hashtable(pos,l_hash,a_new_value)
			--			else
			--				pos := find_row_nondecoded (pos, field, a_new_value)
			--			end
			--		end
	--			end


	--			i := i + 1

	--		end
	--		Result := pos
	--		internal.unmark (an_array)
		end


	find_row_special(a_position: INTEGER; a_spec: SPECIAL[ANY]; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			i: INTEGER
			field: ANY
			pos: INTEGER
		do
--			create internal
--			pos := a_position
--			internal.mark (a_spec)
--			from
--				i := 0
--			until
--				i > a_spec.count-1 or pos <= 0
--			loop
--				pos := pos -1
--				field := a_spec.item (i)
--				if field /= Void then
--					if base_types.has (field.generating_type) then
--							--base type
--						if pos = 1 then
--							change_value_spec (a_spec, a_new_value, a_position-1)
--							pos := 0
--						end
--					elseif not internal.is_marked (field) then
--						if {a_dec: GENERAL_DECODED} field then
--							--decoded
--							pos := find_row_decoded (pos, a_dec, a_new_value)
--						elseif {spec:SPECIAL[ANY]} field then
--							--special type
--							--TODO: implement for special types
---							pos := find_row_special(pos,spec,a_new_value)
--						elseif {arr: ARRAY[ANY]} field then
--							-- array type
--							pos := find_row_array (pos, arr, a_new_value)
--						elseif {chain:CHAIN[ANY]} field then
---								pos := find_row_chain(pos,chain,a_new_value)
--						elseif {l_tuple:TUPLE[ANY]} field then
--								pos := find_row_tuple(pos,l_tuple,a_new_value)
--						elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
--								pos := find_row_hashtable(pos,l_hash,a_new_value)
--						else
--							pos := find_row_nondecoded (pos, field, a_new_value)
--						end
--					end
--				end
--

--				i := i + 1

--			end
--			Result := pos
--			internal.unmark (a_spec)
		end

	find_row_chain(a_position: INTEGER; a_chain: CHAIN[ANY]; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			field: ANY
			pos: INTEGER
		do
--			create internal
--			pos := a_position
--			internal.mark (a_chain)
--			from
--				a_chain.start
--			until
--				a_chain.after or pos <= 0
--			loop
--				pos := pos -1
--				field := a_chain.item
--				if field /= Void then
--					if base_types.has (field.generating_type) then
--							--base type
--						if pos = 1 then
--							change_value_chain (a_chain, a_new_value, a_position)
---							pos := 0
--						end
--					elseif not internal.is_marked (field) then
--						if {a_dec: GENERAL_DECODED} field then
--							--decoded
--							pos := find_row_decoded (pos, a_dec, a_new_value)
--						elseif {spec:SPECIAL[ANY]} field then
--							--special type
--							--TODO: implement for special types
--							pos := find_row_special(pos,spec,a_new_value)
--						elseif {arr: ARRAY[ANY]} field then
--							-- array type
--							pos := find_row_array (pos, arr, a_new_value)
--						elseif {chain:CHAIN[ANY]} field then
--								pos := find_row_chain(pos,chain,a_new_value)
--						elseif {l_tuple:TUPLE[ANY]} field then
--								pos := find_row_tuple(pos,l_tuple,a_new_value)
--						elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
--								pos := find_row_hashtable(pos,l_hash,a_new_value)
--						else
--							pos := find_row_nondecoded (pos, field, a_new_value)
--						end
--					end
--				end
--
--				a_chain.forth
----
--			end
--			Result := pos
--			internal.unmark (a_chain)
		end

	find_row_tuple(a_position: INTEGER; a_tuple: TUPLE[ANY]; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			i: INTEGER
			field: ANY
			pos: INTEGER
		do
--			create internal
--			pos := a_position
--			internal.mark (a_tuple)
--			from
--				i := 1
--			until
--				i > a_tuple.count or pos <= 0
--			loop
--				pos := pos -1
--				field := a_tuple.item (i)
--				if field /= Void then
--					if base_types.has (field.generating_type) then
--							--base type
--						if pos = 1 then
--							change_value_tuple (a_tuple, a_new_value, a_position)
--							pos := 0
--						end
--					elseif not internal.is_marked (field) then
--						if {a_dec: GENERAL_DECODED} field then
--							--decoded
--							pos := find_row_decoded (pos, a_dec, a_new_value)
--						elseif {spec:SPECIAL[ANY]} field then
--							--special type
--							--TODO: implement for special types
--							pos := find_row_special(pos,spec,a_new_value)
--						elseif {arr: ARRAY[ANY]} field then
--							-- array type
--							pos := find_row_array (pos, arr, a_new_value)
--						elseif {chain:CHAIN[ANY]} field then
--								pos := find_row_chain(pos,chain,a_new_value)
--						elseif {l_tuple:TUPLE[ANY]} field then
--								pos := find_row_tuple(pos,l_tuple,a_new_value)
--						elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
--								pos := find_row_hashtable(pos,l_hash,a_new_value)
--						else
--							pos := find_row_nondecoded (pos, field, a_new_value)
--						end
--					end
--				end
--
--
--				i := i + 1
--
--			end
--			Result := pos
--			internal.unmark (a_tuple)
		end

	find_row_hashtable(a_position: INTEGER; a_hash: HASH_TABLE[ANY,HASHABLE]; a_new_value: STRING): INTEGER
			-- same as `find_row_decoded', but for a non-DECODED object
		local
			internal: INTERNAL
			field:ANY
			pos: INTEGER
		do
--			create internal
--			pos := a_position
--			internal.mark (a_hash)
--			from
--				a_hash.start
--			until
--				a_hash.off or pos <= 0
--			loop
--				-- decrementing more than 1 ...because hash_table is displayed with the placeholder row pair(key,item) in the GUI
--				pos := pos - 3
--				field := a_hash.item_for_iteration
--				if field /= Void then
--					if base_types.has (field.generating_type) then
--							--base type
--						if pos <= 1 then
--							change_value_hashtable (a_hash, a_new_value, a_position)
--							pos := 0
--						end
--					elseif not internal.is_marked (field) then
--						if {a_dec: GENERAL_DECODED} field then
--							--decoded
--							pos := find_row_decoded (pos, a_dec, a_new_value)
--						elseif {spec:SPECIAL[ANY]} field then
--							--special type
--							--TODO: implement for special types
--							pos := find_row_special(pos,spec,a_new_value)
--						elseif {arr: ARRAY[ANY]} field then
--							-- array type
--							pos := find_row_array (pos, arr, a_new_value)
--						elseif {chain:CHAIN[ANY]} field then
--								pos := find_row_chain(pos,chain,a_new_value)
--						elseif {l_tuple:TUPLE[ANY]} field then
--								pos := find_row_tuple(pos,l_tuple,a_new_value)
--						elseif {l_hash:HASH_TABLE[ANY,HASHABLE]} field then
--								pos := find_row_hashtable(pos,l_hash,a_new_value)
--						else
--							pos := find_row_nondecoded (pos, field, a_new_value)
--						end
--					end
--				end
--
--				if pos /= 0 then
--					a_hash.forth
--				end
--
--			end
--			Result := pos

--			internal.unmark (a_hash)
		end

	get_root_row_index: INTEGER
			-- returns the index of the root row for that object
		do
			Result := get_root_row.index
		end

	get_root_object: ANY
			-- returns the root object
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_obj:ANY
			l_row: EV_GRID_ROW
		do
			l_row := get_root_row
			l_data ?= l_row.data
			l_obj ?= l_data.reference_item (1)

			if l_data /= Void and then l_obj /= Void then
				Result := l_obj
			end
		end


	get_root_row: EV_GRID_ROW
			-- returns the root row this item is part of
		local
			r: EV_GRID_ROW
		do
			from
				r := row
			until
				r.parent_row = Void
			loop
				r := r.parent_row
					-- no parent, so `r' has to be the root
			end

			Result := r
		end



--	change_value_decoded (a_decoded: GENERAL_DECODED; a_value: STRING; a_position: INTEGER) is
			-- change the value at a specified position given a `DECODED' object
--		do
--			a_decoded.change_value (a_value, a_position)
--		end

	change_value_nondecoded (a_obj: ANY; a_value: STRING; a_position: INTEGER)
			-- change the value at a specified position given a nondecoded object
		local
			l_type_name: STRING
			l_internal: INTERNAL
		do
			create l_internal
			l_type_name := l_internal.type_name (a_obj)

			if l_type_name.is_equal ("INTEGER_8") then
				l_internal.set_integer_8_field (a_position, a_obj, a_value.to_integer_8)
			elseif l_type_name.is_equal ("INTEGER_16") then
				l_internal.set_integer_16_field (a_position, a_obj, a_value.to_integer_16)
			elseif l_type_name.is_equal ("INTEGER_32") then
				l_internal.set_integer_32_field (a_position, a_obj, a_value.to_integer_32)
			elseif l_type_name.is_equal ("INTEGER_64") then
				l_internal.set_integer_64_field (a_position, a_obj, a_value.to_integer_64)

			elseif l_type_name.is_equal ("NATURAL_8") then
				l_internal.set_natural_8_field (a_position, a_obj, a_value.to_natural_8)
			elseif l_type_name.is_equal ("NATURAL_16") then
				l_internal.set_natural_16_field (a_position, a_obj, a_value.to_natural_16)
			elseif l_type_name.is_equal ("NATURAL_32") then
				l_internal.set_natural_32_field (a_position, a_obj, a_value.to_natural_32)
			elseif l_type_name.is_equal ("NATURAL_64") then
				l_internal.set_natural_64_field (a_position, a_obj, a_value.to_natural_64)

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					l_internal.set_boolean_field (a_position, a_obj, true)
				else
					l_internal.set_boolean_field (a_position, a_obj, false)
				end

			elseif l_type_name.is_equal ("REAL_32") then
				l_internal.set_real_32_field (a_position, a_obj, a_value.to_real)
			elseif l_type_name.is_equal ("REAL_64") then
				l_internal.set_real_64_field (a_position, a_obj, a_value.to_double)

			elseif l_type_name.is_equal ("STRING_8") then
				l_internal.set_reference_field (a_position, a_obj, a_value.to_string_8)
			elseif l_type_name.is_equal ("STRING_32") then
				l_internal.set_reference_field (a_position, a_obj, a_value.to_string_32)
			elseif l_type_name.is_equal ("CHARACTER_8") then
				l_internal.set_character_8_field (a_position, a_obj, a_value.item (1))
			elseif l_type_name.is_equal ("CHARACTER") then
				l_internal.set_character_field (a_position, a_obj, a_value.item (1))
			elseif l_type_name.is_equal ("CHARACTER_32") then
				l_internal.set_character_32_field (a_position, a_obj, a_value.item (1))
			else
				check
					type_not_supported: false
				end
			end
		end


	change_value_array (a_array: ARRAY[ANY]; a_value: STRING; a_position: INTEGER)
			-- change one field of an array (non-DECODED)
		local
			l_internal: INTERNAL
			l_type_name: STRING
			l_pos: INTEGER

		do
			create l_internal
			l_pos := a_position -1
			l_type_name := l_internal.type_name (a_array.item (l_pos))


			if l_type_name.is_equal ("INTEGER_8") then
				a_array.put (a_value.to_integer_8, l_pos)
			elseif l_type_name.is_equal ("INTEGER_16") then
				a_array.put (a_value.to_integer_16, l_pos)
			elseif l_type_name.is_equal ("INTEGER_32") then
				a_array.put (a_value.to_integer_32, l_pos)
			elseif l_type_name.is_equal ("INTEGER_64") then
				a_array.put (a_value.to_integer_64, l_pos)

			elseif l_type_name.is_equal ("NATURAL_8") then
				a_array.put (a_value.to_natural_8, l_pos)
			elseif l_type_name.is_equal ("NATURAL_16") then
				a_array.put (a_value.to_natural_16, l_pos)
			elseif l_type_name.is_equal ("NATURAL_32") then
				a_array.put (a_value.to_natural_32, l_pos)
			elseif l_type_name.is_equal ("NATURAL_64") then
				a_array.put (a_value.to_natural_64, l_pos)

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					a_array.put (true, l_pos)
				else
					a_array.put (false, l_pos)
				end

			elseif l_type_name.is_equal ("REAL_32") then
				a_array.put (a_value.to_real, l_pos)
			elseif l_type_name.is_equal ("REAL_64") then
				a_array.put (a_value.to_double, l_pos)

			elseif l_type_name.is_equal ("STRING_8") then
				a_array.put (a_value.to_string_8, l_pos)
			elseif l_type_name.is_equal ("STRING_32") then
				a_array.put (a_value.to_string_32, l_pos)
			elseif l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_32")  then
				a_array.put (a_value.item (1), l_pos)
			else
				check
					type_not_supported: false
				end
			end

		end

	change_value_spec(a_spec: SPECIAL[ANY]; a_value: STRING; a_position: INTEGER)
			-- change one field of an special (non-DECODED)
		local
			l_internal: INTERNAL
			l_type_name: STRING
			l_pos: INTEGER

		do
			create l_internal
			l_pos := a_position -1
			l_type_name := l_internal.type_name (a_spec.item (l_pos))

			if l_type_name.is_equal ("INTEGER_8") then
				a_spec.put (a_value.to_integer_8, l_pos)
			elseif l_type_name.is_equal ("INTEGER_16") then
				a_spec.put (a_value.to_integer_16, l_pos)
			elseif l_type_name.is_equal ("INTEGER_32") then
				a_spec.put (a_value.to_integer_32, l_pos)
			elseif l_type_name.is_equal ("INTEGER_64") then
				a_spec.put (a_value.to_integer_64, l_pos)

			elseif l_type_name.is_equal ("NATURAL_8") then
				a_spec.put (a_value.to_natural_8, l_pos)
			elseif l_type_name.is_equal ("NATURAL_16") then
				a_spec.put (a_value.to_natural_16, l_pos)
			elseif l_type_name.is_equal ("NATURAL_32") then
				a_spec.put (a_value.to_natural_32, l_pos)
			elseif l_type_name.is_equal ("NATURAL_64") then
				a_spec.put (a_value.to_natural_64, l_pos)

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					a_spec.put (true, l_pos)
				else
					a_spec.put (false, l_pos)
				end

			elseif l_type_name.is_equal ("REAL_32") then
				a_spec.put (a_value.to_real, l_pos)
			elseif l_type_name.is_equal ("REAL_64") then
				a_spec.put (a_value.to_double, l_pos)

			elseif l_type_name.is_equal ("STRING_8") then
				a_spec.put (a_value.to_string_8, l_pos)
			elseif l_type_name.is_equal ("STRING_32") then
				a_spec.put (a_value.to_string_32, l_pos)
			elseif l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_32")  then
				a_spec.put (a_value.item (1), l_pos)
			else
				check
					type_not_supported: false
				end
			end

		end

	change_value_chain(a_chain: CHAIN[ANY]; a_value: STRING; a_position: INTEGER)
			-- change one field of a chain (non-DECODED)
		local
			l_internal: INTERNAL
			l_type_name: STRING
			l_pos: INTEGER

		do
			create l_internal
			l_pos := a_position -1
			l_type_name := l_internal.type_name (a_chain.i_th (l_pos))


			if l_type_name.is_equal ("INTEGER_8") then
				a_chain.put_i_th  (a_value.to_integer_8, l_pos)
			elseif l_type_name.is_equal ("INTEGER_16") then
				a_chain.put_i_th  (a_value.to_integer_16, l_pos)
			elseif l_type_name.is_equal ("INTEGER_32") then
				a_chain.put_i_th (a_value.to_integer_32, l_pos)
			elseif l_type_name.is_equal ("INTEGER_64") then
				a_chain.put_i_th  (a_value.to_integer_64, l_pos)

			elseif l_type_name.is_equal ("NATURAL_8") then
				a_chain.put_i_th  (a_value.to_natural_8, l_pos)
			elseif l_type_name.is_equal ("NATURAL_16") then
				a_chain.put_i_th (a_value.to_natural_16, l_pos)
			elseif l_type_name.is_equal ("NATURAL_32") then
				a_chain.put_i_th  (a_value.to_natural_32, l_pos)
			elseif l_type_name.is_equal ("NATURAL_64") then
				a_chain.put_i_th  (a_value.to_natural_64, l_pos)

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					a_chain.put_i_th  (true, l_pos)
				else
					a_chain.put_i_th  (false, l_pos)
				end

			elseif l_type_name.is_equal ("REAL_32") then
				a_chain.put_i_th (a_value.to_real, l_pos)
			elseif l_type_name.is_equal ("REAL_64") then
				a_chain.put_i_th  (a_value.to_double, l_pos)

			elseif l_type_name.is_equal ("STRING_8") then
				a_chain.put_i_th  (a_value.to_string_8, l_pos)
			elseif l_type_name.is_equal ("STRING_32") then
				a_chain.put_i_th  (a_value.to_string_32, l_pos)
			elseif l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_32")  then
				a_chain.put_i_th (a_value.item (1), l_pos)
			else
				check
					type_not_supported: false
				end
			end

		end

	change_value_tuple(a_tuple: TUPLE[ANY]; a_value: STRING; a_position: INTEGER)
			-- change one field of a tuple (non-DECODED)
		local
			l_internal: INTERNAL
			l_type_name: STRING
			l_pos: INTEGER

		do
			create l_internal
			l_pos := a_position -1
			l_type_name := l_internal.type_name (a_tuple.item (l_pos))


			if l_type_name.is_equal ("INTEGER_8") then
				a_tuple.put  (a_value.to_integer_8, l_pos)
			elseif l_type_name.is_equal ("INTEGER_16") then
				a_tuple.put   (a_value.to_integer_16, l_pos)
			elseif l_type_name.is_equal ("INTEGER_32") then
				a_tuple.put  (a_value.to_integer_32, l_pos)
			elseif l_type_name.is_equal ("INTEGER_64") then
				a_tuple.put  (a_value.to_integer_64, l_pos)

			elseif l_type_name.is_equal ("NATURAL_8") then
				a_tuple.put   (a_value.to_natural_8, l_pos)
			elseif l_type_name.is_equal ("NATURAL_16") then
				a_tuple.put  (a_value.to_natural_16, l_pos)
			elseif l_type_name.is_equal ("NATURAL_32") then
				a_tuple.put   (a_value.to_natural_32, l_pos)
			elseif l_type_name.is_equal ("NATURAL_64") then
				a_tuple.put   (a_value.to_natural_64, l_pos)

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					a_tuple.put  (true, l_pos)
				else
					a_tuple.put   (false, l_pos)
				end

			elseif l_type_name.is_equal ("REAL_32") then
				a_tuple.put  (a_value.to_real, l_pos)
			elseif l_type_name.is_equal ("REAL_64") then
				a_tuple.put   (a_value.to_double, l_pos)

			elseif l_type_name.is_equal ("STRING_8") then
				a_tuple.put (a_value.to_string_8, l_pos)
			elseif l_type_name.is_equal ("STRING_32") then
				a_tuple.put   (a_value.to_string_32, l_pos)
			elseif l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_32")  then
				a_tuple.put (a_value.item (1), l_pos)
			else
				check
					type_not_supported: false
				end
			end

		end

	change_value_hashtable(a_hash: HASH_TABLE[ANY,HASHABLE]; a_new_value: STRING; a_position: INTEGER)
			-- change one field of a hashtable (non-DECODED)
		local
			l_internal: INTERNAL
			l_type_name: STRING
			l_hash_table_index,l_edited_row_index,l_item_index: INTEGER
			l_value:ANY

		do
			create l_internal

			l_hash_table_index := row.parent_row.parent_row.index
			l_edited_row_index := row.index
			if l_hash_table_index + (a_hash.count * 3) >= l_edited_row_index then
				-- value has been changed in this hashtable.

				if row.parent_row.subrow (1).is_equal(row) then
					-- key has been edited
					l_item_index := (((l_edited_row_index - 1) - l_hash_table_index) / a_hash.count).ceiling
					a_hash.replace_key (create {STRING}.make_from_string (a_new_value), a_hash.current_keys.item (l_item_index))

				else
					--value has been edited
					l_item_index := (((l_edited_row_index - 2) - l_hash_table_index) / a_hash.count).ceiling
					l_type_name := a_hash.generating_type.substring (a_hash.generating_type.index_of ('[', 1)+1, a_hash.generating_type.index_of (',', 1)-1)
					l_type_name.right_adjust
					l_type_name.left_adjust
					l_value := generate_correct_object(l_type_name,create {STRING}.make_from_string (a_new_value))

					a_hash.replace (l_value, a_hash.current_keys.item (l_item_index))

				end
			end

		end

feature {NONE} -- Implementation helper

	parent_disp_row:EV_GRID_ROW

	offset_index:INTEGER

	parent_display_object:ES_EBBRO_DISPLAYABLE

	change_value:STRING

	update_all_possible_shared_values(a_value:STRING)
			-- if the currently edited value, belongs to an object which is shared among other objects
			-- this procedure updates all values - which belong to the same displayable object (to which the edited item belongs to)
		local
			l_root_row:EV_GRID_ROW
			l_internal:INTERNAL
		do
			parent_disp_row := void
			parent_display_object := get_first_display_parent(row)

			offset_index := get_local_index(parent_disp_row,row)

			change_value := a_value

			l_root_row := get_root_row

			create l_internal

			l_internal.mark (parent_disp_row)

			update_all_possible_values_rek(l_root_row)

			l_internal.unmark (parent_disp_row)


		end

	update_all_possible_values_rek(a_row:EV_GRID_ROW)
			-- if the currently edited value, belongs to an object which is shared among other objects
			-- this procedure updates all values - which belong to the same ES_EBBRO_ES_EBBRO_DISPLAYABLE object (to which the edited item belongs to)
			-- rekursive implementation to update values ...
			-- rekursion built on 'a_row'
			-- other values could actually be attributes and then accessed when needed...
		local
			i,nb:INTEGER
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_obj:ES_EBBRO_DISPLAYABLE
			l_row,l_root_row: EV_GRID_ROW
			l_item:EV_GRID_LABEL_ITEM
			l_internal:INTERNAL
		do
			create l_internal
			from
				i := 1
				nb := a_row.subrow_count
			until
				i > nb
			loop
				l_root_row := a_row.subrow (i)
				if not l_internal.is_marked (l_root_row) then
					l_data ?= l_root_row.data
					if l_data /= void and l_root_row.subrow_count > 0 then
						l_obj ?= l_data.reference_item (1)
						if l_obj /= void and then l_obj = parent_display_object then
							l_row := l_root_row.subrow (offset_index)
							l_item ?= l_row.item (2)
							l_item.set_text (change_value)
						end
					end
					if l_root_row.subrow_count > 0 then
						update_all_possible_values_rek(l_root_row)
					end
				end

				i := i + 1
			end
		end



	get_first_display_parent(a_row:EV_GRID_ROW):ES_EBBRO_DISPLAYABLE
			-- returns the display object to which the currently edited row belongs to...
			-- rekursivly goes from parent to parent ...until the first displayable.
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_obj:ES_EBBRO_DISPLAYABLE
		do
			--parent_row_count := parent_row_count + 1
			l_data ?= a_row.data
			if l_data /= void then
				l_obj ?= l_data.reference_item (1)
			end
			if l_obj /= void then
				parent_disp_row := a_row
				result := l_obj
			else
				result := get_first_display_parent(a_row.parent_row)
			end
		end

	get_local_index(a_parent_row:EV_GRID_ROW;a_child_row:EV_GRID_ROW):INTEGER
			-- returns the real offset from a parent row (which holds the display object) and the row
			-- which value has been edited.
		local
			i,nb:INTEGER
			abort:BOOLEAN
			l_root_row:EV_GRID_ROW
		do
			from
				i := 1
				nb := a_parent_row.subrow_count
			until
				i > nb or abort
			loop
				l_root_row := a_parent_row.subrow (i)
				if l_root_row = a_child_row then
					abort := true
				else
					if l_root_row.subrow_count > 0 then
						result := result + get_local_index(l_root_row,a_child_row)
					end
				end
				result := result + 1
				i := i + 1
			end
			if not abort then
				result := 0
			end
		end

	is_valid_character_type(a_value:STRING):BOOLEAN
			-- checks whether value is a character
		do
			result := a_value.count <=1
		end


	generate_correct_object(l_type_name:STRING;a_value:STRING):ANY
			-- creates a object which corresponds to l_type_name from a_value
		do

			if l_type_name.is_equal ("INTEGER_8") then
				result := a_value.to_integer_8
			elseif l_type_name.is_equal ("INTEGER_16") then
				result := a_value.to_integer_16
			elseif l_type_name.is_equal ("INTEGER_32") then
				result := a_value.to_integer_32
			elseif l_type_name.is_equal ("INTEGER_64") then
				result := a_value.to_integer_64

			elseif l_type_name.is_equal ("NATURAL_8") then
				result := a_value.to_natural_8
			elseif l_type_name.is_equal ("NATURAL_16") then
				result := a_value.to_natural_16
			elseif l_type_name.is_equal ("NATURAL_32") then
				result := a_value.to_natural_32
			elseif l_type_name.is_equal ("NATURAL_64") then
				result := a_value.to_natural_64

			elseif l_type_name.is_equal ("BOOLEAN") then
				if a_value.as_lower.is_equal ("true") then
					result := true
				else
					result := false
				end

			elseif l_type_name.is_equal ("REAL_32") then
				result := a_value.to_real
			elseif l_type_name.is_equal ("REAL_64") then
				result := a_value.to_double

			elseif l_type_name.is_equal ("STRING_8") then
				result := a_value.to_string_8
			elseif l_type_name.is_equal ("STRING_32") then
				result := a_value.to_string_32
			elseif l_type_name.is_equal ("CHARACTER_8") or l_type_name.is_equal ("CHARACTER") or l_type_name.is_equal ("CHARACTER_32")  then
				result := a_value.item (1)
			else
				check
					type_not_supported: false
				end
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
