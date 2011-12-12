note
	description: "Class to write the dynamically gained runtime data to disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA_WRITER

create
	make, default_create

feature -- Initialization

	make (a_class: like context_class; a_feature: like analyzed_feature; a_data: like collected_runtime_data; a_path: like output_path)
			-- Initialize `context_class' with `a_class',
			-- `analyzed_feature' with `a_feature',
			-- `collected_runtime_data' with `a_data' and
			-- `output_path' with `a_path'.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_data (a_data)
			set_path (a_path)
		end

feature -- Setting

	set_class (a_class: like context_class)
			-- Set `context_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			context_class := a_class
		ensure
			context_class_set: context_class = a_class
		end

	set_feature (a_feature: like analyzed_feature)
			-- Set `analyzed_feature' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			analyzed_feature := a_feature
		ensure
			analyzed_feature_set: analyzed_feature = a_feature
		end

	set_data (a_data: like collected_runtime_data)
			-- Set `collected_runtime_data' to `a_data'.
		require
			a_data_not_void: a_data /= Void
		do
			collected_runtime_data := a_data
		ensure
			collected_runtime_data_set: collected_runtime_data = a_data
		end

	set_path (a_path: like output_path)
			-- Set `output_path' to `a_path'.
		require
			a_path_not_void: a_path /= Void
		do
			output_path := a_path
		ensure
			output_path_set: output_path.is_equal (a_path)
		end

feature -- Access

	context_class: CLASS_C
			-- Context class to which `analyzed_feature' belongs.

	analyzed_feature: FEATURE_I
			-- Feature which was analyzed through dynamic means.

	collected_runtime_data: LINKED_LIST [EPA_STATE_CHANGE]
			-- Runtime data collected through dynamic means.

	output_path: STRING
			-- Output-path where the file should be written to.

feature -- Basic operations

	write
			-- Writes `context_class', `analyzed_feature' and `collected_runtime_data' to `output_path'
		local
			l_file: PLAIN_TEXT_FILE
			l_object, l_data: JSON_OBJECT
			l_analysis_order: JSON_ARRAY
			l_printer: PRINT_JSON_VISITOR
			l_map: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
		do
			-- Object to be written to the disk.
			create l_object.make

			-- Add context class and feature information
			l_object.put (create {JSON_STRING}.make_json (context_class.name), create {JSON_STRING}.make_json ("class"))
			l_object.put (create {JSON_STRING}.make_json (analyzed_feature.feature_name_32), create {JSON_STRING}.make_json ("feature"))

			-- Add analysis order.
			l_analysis_order := analysis_order_from_runtime_data
			l_object.put (l_analysis_order, create {JSON_STRING}.make_json ("execution_order"))

			-- Add collected runtime data.
			l_map := map_from_runtime_data
			l_data := json_object_from_runtime_data (l_map)
			l_object.put (l_data, create {JSON_STRING}.make_json ("data"))

			-- Write object to disk.
			create l_printer.make
			l_object.accept (l_printer)
			create l_file.make_create_read_write (output_path + context_class.name + "." + analyzed_feature.feature_name_32 + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {NONE} -- Implementation

	map_from_runtime_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			-- Transformed runtime data.
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.
		require
			collected_runtime_data_not_void: collected_runtime_data /= Void
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
			create Result.make_default
			across collected_runtime_data as l_data loop
				l_bp_slot := l_data.item.pre_state_bp_slot.out
				l_pre_state := l_data.item.pre_state
				l_post_state := l_data.item.post_state
				across l_pre_state.keys.to_array as l_exprs loop
					l_key := l_bp_slot + ";" + l_exprs.item
					if not Result.has (l_key) then
						l_value := l_pre_state.item (l_exprs.item)
						create l_pre_value.make (l_data.item.pre_state_bp_slot, l_value)
						l_value := l_post_state.item (l_exprs.item)
						create l_post_value.make (l_data.item.post_state_bp_slot, l_value)

						create l_list.make
						l_list.extend ([l_pre_value, l_post_value])

						Result.force_last (l_list, l_key)
					else
						l_list := Result.item (l_key)
						l_value := l_pre_state.item (l_exprs.item)
						create l_pre_value.make (l_data.item.pre_state_bp_slot, l_value)
						l_value := l_post_state.item (l_exprs.item)
						create l_post_value.make (l_data.item.post_state_bp_slot, l_value)
						l_list.extend ([l_pre_value, l_post_value])
					end
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	analysis_order_from_runtime_data: JSON_ARRAY
			-- JSON array of pre-state / post-state pairs in the order they were analyzed.
		local
			l_object: JSON_OBJECT
			i: INTEGER
			l_value: STRING
		do
			create Result.make_array
			from
				collected_runtime_data.start
				i := 1
			until
				collected_runtime_data.after
			loop
				l_value := collected_runtime_data.item.pre_state_bp_slot.out + ";" + collected_runtime_data.item.post_state_bp_slot.out
				Result.add (create {JSON_STRING}.make_json (l_value))
				i := i + 1
				collected_runtime_data.forth
			end
		end

	json_object_from_runtime_data (a_collected_runtime_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]): JSON_OBJECT
			-- Transform `a_collected_runtime_data' into a JSON object.
		require
			a_collected_runtime_data_not_void: a_collected_runtime_data /= Void
		local
			l_tuple: TUPLE [pre_value: EPA_POSITIONED_VALUE; post_value: EPA_POSITIONED_VALUE]
			l_json_values: JSON_OBJECT
			l_json_array: JSON_ARRAY
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
		do
			create l_type_finder

			create Result.make

			-- Iterate over keys.
			across a_collected_runtime_data.keys.to_array as l_keys loop
				create l_json_array.make_array
				-- Iterate over values.
				across a_collected_runtime_data.item (l_keys.item) as l_values loop
					l_tuple := l_values.item

					create l_json_values.make

					-- Pre-state value
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

					-- Post-state value
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
				Result.put (l_json_array, create {JSON_STRING}.make_json (l_keys.item))
			end
		end

end
