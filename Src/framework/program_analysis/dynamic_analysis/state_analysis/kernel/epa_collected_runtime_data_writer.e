note
	description: "Summary description for {EPA_COLLECTED_RUNTIME_DATA_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA_WRITER

create
	make, default_create

feature -- Creation procedure

	make (a_class: like class_; a_feature: like feature_; a_data: like data; a_path: like path)
			--
		do
			set_class (a_class)
			set_feature (a_feature)
			set_data (a_data)
			set_path (a_path)
		end

feature -- Setting

	set_class (a_class: like class_)
			--
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			--
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_data (a_data: like data)
			--
		require
			a_data_not_void: a_data /= Void
		do
			data := a_data
		ensure
			data_set: data = a_data
		end

	set_path (a_path: like path)
			--
		require
			a_path_not_void: a_path /= Void
		do
			path := a_path
		ensure
			path_set: path.is_equal (a_path)
		end

feature -- Access

	class_: CLASS_C
			--

	feature_: FEATURE_I
			--

	data: LINKED_LIST [EPA_STATE_CHANGE]
			--

	path: STRING
			--

feature -- Write

	write
			--
		local
			l_file: PLAIN_TEXT_FILE
			l_object: JSON_OBJECT
			l_printer: PRINT_JSON_VISITOR
		do
			fill_map

			create l_object.make
			l_object.put (create {JSON_STRING}.make_json (class_.name), create {JSON_STRING}.make_json ("class"))
			l_object.put (create {JSON_STRING}.make_json (feature_.feature_name_32), create {JSON_STRING}.make_json ("feature"))

			build_execution_order_object
			l_object.put (last_json_value, create {JSON_STRING}.make_json ("execution_order"))

			build_map_object
			l_object.put (last_json_value, create {JSON_STRING}.make_json ("data"))

			create l_printer.make
			l_object.accept (l_printer)
			create l_file.make_create_read_write (path + class_.name + "." + feature_.feature_name_32 + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {NONE} -- Implementation

	fill_map
			--
		require
			data_not_void: data /= Void
		local
			l_list: LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]]
			l_pre_state: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_post_state: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_bp_slot: STRING
			l_key: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_pre_value: EPA_POSITIONED_VALUE
			l_post_value: EPA_POSITIONED_VALUE
		do
			create bp_expr_value_map.make_default
			across data as l_data loop
				l_bp_slot := l_data.item.pre_state_bp_slot.out
				l_pre_state := l_data.item.pre_state
				l_post_state := l_data.item.post_state
				across l_pre_state.keys.to_array as l_exprs loop
					l_key := l_bp_slot + ";" + l_exprs.item
					if not bp_expr_value_map.has (l_key) then
						l_value := l_pre_state.item (l_exprs.item)
						create l_pre_value.make (l_data.item.pre_state_bp_slot, l_value)
						l_value := l_post_state.item (l_exprs.item)
						create l_post_value.make (l_data.item.post_state_bp_slot, l_value)

						create l_list.make
						l_list.extend ([l_pre_value, l_post_value])

						bp_expr_value_map.force_last (l_list, l_key)
					else
						l_list := bp_expr_value_map.item (l_key)
						l_value := l_pre_state.item (l_exprs.item)
						create l_pre_value.make (l_data.item.pre_state_bp_slot, l_value)
						l_value := l_post_state.item (l_exprs.item)
						create l_post_value.make (l_data.item.post_state_bp_slot, l_value)
						l_list.extend ([l_pre_value, l_post_value])
					end
				end
			end
		ensure
			bp_expr_value_map_not_void: bp_expr_value_map /= Void
		end

	build_execution_order_object
			--
		local
			l_execution_order: JSON_ARRAY
			l_object: JSON_OBJECT
			i: INTEGER
			l_value: STRING
		do
			create l_execution_order.make_array
			from
				data.start
				i := 1
			until
				data.after
			loop
				l_value := data.item.pre_state_bp_slot.out + ";" + data.item.post_state_bp_slot.out
				l_execution_order.add (create {JSON_STRING}.make_json (l_value))
				i := i + 1
				data.forth
			end
			last_json_value := l_execution_order
		end

	build_map_object
			--
		local
			l_tuple: TUPLE [pre_value: EPA_POSITIONED_VALUE; post_value: EPA_POSITIONED_VALUE]
			l_json_values: JSON_OBJECT
			l_json_array: JSON_ARRAY
			l_json_object: JSON_OBJECT
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
		do
			create l_type_finder

			create l_json_object.make

			across bp_expr_value_map.keys.to_array as l_keys loop
				create l_json_array.make_array
				across bp_expr_value_map.item (l_keys.item) as l_values loop
					l_tuple := l_values.item

					create l_json_values.make

					-- Pre-state information
					l_type_finder.set_value (l_tuple.pre_value.value)
					l_type_finder.find
					l_json_values.put (create {JSON_STRING}.make_json (l_type_finder.type), create {JSON_STRING}.make_json ("pre_type"))
					l_json_values.put (create {JSON_STRING}.make_json (l_tuple.pre_value.value.text), create {JSON_STRING}.make_json ("pre_value"))
					l_json_values.put (create {JSON_STRING}.make_json (l_tuple.pre_value.bp_slot.out), create {JSON_STRING}.make_json ("pre_bp"))
					if l_type_finder.type.is_equal ("EPA_REFERENCE_VALUE") then
						if attached {CL_TYPE_A} l_tuple.pre_value.value.type as l_type then
							l_json_values.put (create {JSON_STRING}.make_json (l_type.class_id.out), create {JSON_STRING}.make_json ("pre_ref_class_id"))
						end
					end

					-- Post-state information
					l_type_finder.set_value (l_tuple.post_value.value)
					l_type_finder.find
					l_json_values.put (create {JSON_STRING}.make_json (l_type_finder.type), create {JSON_STRING}.make_json ("post_type"))
					l_json_values.put (create {JSON_STRING}.make_json (l_tuple.post_value.value.text), create {JSON_STRING}.make_json ("post_value"))
					l_json_values.put (create {JSON_STRING}.make_json (l_tuple.post_value.bp_slot.out), create {JSON_STRING}.make_json ("post_bp"))
					if l_type_finder.type.is_equal ("EPA_REFERENCE_VALUE") then
						if attached {CL_TYPE_A} l_tuple.post_value.value.type as l_type then
							l_json_values.put (create {JSON_STRING}.make_json (l_type.class_id.out), create {JSON_STRING}.make_json ("post_ref_class_id"))
						end
					end

					l_json_array.add (l_json_values)
				end
				l_json_object.put (l_json_array, create {JSON_STRING}.make_json (l_keys.item))
			end

			last_json_value := l_json_object
		end

feature {NONE} -- Implementation

	bp_expr_value_map: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			--

	last_json_value: JSON_VALUE
			--

end
