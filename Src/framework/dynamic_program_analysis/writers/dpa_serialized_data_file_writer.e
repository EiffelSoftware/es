note
	description: "Summary description for {EPA_SERIALIZED_DATA_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_SERIALIZED_DATA_FILE_WRITER

inherit
	DPA_DATA_FILE_WRITER

	EPA_UTILITY

create
	make

feature {NONE} -- Initialization

	make (a_context_class: like context_class; a_analyzed_feature: like analyzed_feature; a_output_path: like output_path; a_file_name_prefix: like file_name_prefix)
			--
		require
			a_context_class_not_void: a_context_class /= Void
			a_analyzed_feature_not_void: a_analyzed_feature /= Void
			a_output_path_not_void: a_output_path /= Void
			a_file_name_prefix_not_void: a_file_name_prefix /= Void
		do
			context_class := a_context_class
			analyzed_feature := a_analyzed_feature
			output_path := a_output_path
			file_name_prefix := a_file_name_prefix
			initialize
		ensure
			context_class_set: context_class = a_context_class
			analyzed_feature_set: analyzed_feature = a_analyzed_feature
			output_path_set: output_path.is_equal (a_output_path)
			file_name_prefix_set: file_name_prefix.is_equal (a_file_name_prefix)
		end

feature -- Access

	file_name_prefix: STRING
			--

feature -- Basic operations

	generate_root_file
			-- Writes `context_class', `analyzed_feature' and `collected_runtime_data' to `output_path'
		local
			l_file: RAW_FILE
		do
			create l_file.make_create_read_write (output_path + file_name_prefix + ".txt")
			l_file.put_string (context_class.name)
			l_file.put_new_line
			l_file.put_string (analyzed_feature.feature_name_32)
			l_file.put_new_line
			l_file.put_string (number_of_data_files.out)
			l_file.close
		end

	generate_keys_file
			-- Writes `context_class', `analyzed_feature' and `collected_runtime_data' to `output_path'
		local
			l_file: RAW_FILE
			l_keys: STRING
		do
			create l_file.make_create_read_write (output_path + file_name_prefix + "_keys.txt")

			from
				keys.start
			until
				keys.after
			loop
				l_file.put_string (keys.item_for_iteration)
				if not keys.is_last then
					l_file.put_new_line
				end
				keys.forth
			end

			l_file.close
		end

feature -- Basic operations

	write
			--
		local
			l_file: RAW_FILE
			l_analysis_order_item: TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]
			l_pre_state_bp, l_post_state_bp, l_serialized_analysis_order_item: STRING
			l_keys: DS_BILINEAR [STRING]
			l_key: STRING
			l_expression: STRING
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
			l_data: LINKED_LIST [TUPLE [INTEGER, EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]]
			l_tuple: TUPLE [call_stack_count: INTEGER; pre_value: EPA_POSITIONED_VALUE; post_value: EPA_POSITIONED_VALUE]
		do
			create l_file.make_create_read_write (output_path + file_name_prefix + "_data_" + number_of_data_files.out + ".txt")

			from
				analysis_order.start
			until
				analysis_order.after
			loop
				l_analysis_order_item := analysis_order.item
				l_pre_state_bp := l_analysis_order_item.pre_state_bp.out
				l_post_state_bp := l_analysis_order_item.post_state_bp.out
				create l_serialized_analysis_order_item.make (l_pre_state_bp.count + l_post_state_bp.count + 1)
				l_serialized_analysis_order_item.append (l_pre_state_bp)
				l_serialized_analysis_order_item.append_character (';')
				l_serialized_analysis_order_item.append (l_post_state_bp)
				l_file.put_string (l_serialized_analysis_order_item)
				l_file.put_new_line

				analysis_order.forth
			end

			l_keys := collected_runtime_data.keys

			from
				l_keys.start
			until
				l_keys.after
			loop
				l_key := l_keys.item_for_iteration
				l_expression := l_key.split (';').i_th (2)

				l_data := collected_runtime_data.item (l_key)

				from
					l_data.start
				until
					l_data.after
				loop
					l_tuple := l_data.item

					l_file.put_string (l_expression)
					l_file.put_character (';')

					l_file.put_string (l_tuple.call_stack_count.out)
					l_file.put_character (';')

					l_file.put_string (l_tuple.pre_value.bp_slot.out)
					l_file.put_character (';')

					l_type_finder.set_value (l_tuple.pre_value.value)
					l_type_finder.find

					l_file.put_string (l_type_finder.type)
					l_file.put_character (';')

					if l_type_finder.type.is_equal (reference_value) then
						if attached {CL_TYPE_A} l_tuple.pre_value.value.type as l_type then
							l_file.put_string (l_type.class_id.out)
						end
					end

					if l_type_finder.type.is_equal (string_value) then
						l_file.put_string (l_tuple.pre_value.value.item.out)
					end

					l_file.put_character (';')

					l_file.put_string (l_tuple.pre_value.value.text)
					l_file.put_character (';')

					l_file.put_string (l_tuple.post_value.bp_slot.out)
					l_file.put_character (';')

					l_type_finder.set_value (l_tuple.post_value.value)
					l_type_finder.find

					l_file.put_string (l_type_finder.type)
					l_file.put_character (';')

					if l_type_finder.type.is_equal (reference_value) then
						if attached {CL_TYPE_A} l_tuple.post_value.value.type as l_type then
							l_file.put_string (l_type.class_id.out)
						end
					end

					if l_type_finder.type.is_equal (string_value) then
						l_file.put_string (l_tuple.post_value.value.item.out)
					end

					l_file.put_character (';')

					l_file.put_string (l_tuple.post_value.value.text)
					l_file.put_new_line

					l_data.forth
				end

				l_keys.forth
			end

			l_file.close
		end

feature {NONE} -- Implementation

	number_of_data_files: INTEGER
			--

	keys: DS_HASH_SET [STRING]
			--

feature {NONE} -- Implementation

	initialize
			--
		do
			number_of_data_files := 0
			create keys.make_default
			keys.set_equality_tester (string_equality_tester)
		end

end
