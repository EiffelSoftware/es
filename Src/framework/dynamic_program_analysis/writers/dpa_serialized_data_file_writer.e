note
	description: "A writer that writes the data from a dynamic program analysis to disk using serialized data files."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_SERIALIZED_DATA_FILE_WRITER

inherit
	DPA_DATA_FILE_WRITER

create
	make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_; a_output_path: like output_path; a_file_name_prefix: like file_name_prefix)
			--
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_output_path_not_void: a_output_path /= Void
			a_file_name_prefix_not_void: a_file_name_prefix /= Void
		do
			class_ := a_class
			feature_ := a_feature
			output_path := a_output_path
			file_name_prefix := a_file_name_prefix

			create analysis_order_pairs.make
			create expression_value_transitions.make

			restore

			create string_data_file_content.make (file_size_limit)
			string_data_file_content.append (class_.name)
			string_data_file_content.append_character ('%N')
			string_data_file_content.append (feature_.feature_name_32)
			string_data_file_content.append_character ('%N')
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			output_path_set: output_path.is_equal (a_output_path)
			file_name_prefix_set: file_name_prefix.is_equal (a_file_name_prefix)
		end

feature -- Access

	file_name_prefix: STRING
			--

feature -- Writing

	try_write
			--
		do
			update_string_data_file_content

			if string_data_file_content.count > file_size_limit then
				write
			end
		end

	write
			--
		local
			l_file: PLAIN_TEXT_FILE
		do
			update_string_data_file_content

			string_data_file_content.append ("EOF")

			create l_file.make_create_read_write (output_path + file_name_prefix + "_" + number_of_data_files.out + ".txt")
			l_file.put_string (string_data_file_content)
			l_file.close

			number_of_data_files := number_of_data_files + 1

			create string_data_file_content.make (file_size_limit)
			string_data_file_content.append (class_.name)
			string_data_file_content.append_character ('%N')
			string_data_file_content.append (feature_.feature_name_32)
			string_data_file_content.append_character ('%N')
		end

feature {NONE} -- Implementation

	string_data_file_content: STRING
			--

	file_size_limit: INTEGER = 5000000
			--

	number_of_data_files: INTEGER
			--

feature {NONE} -- Implementation

	restore
			--
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
			l_data: LIST [STRING]
		do
			from
				i := 1
				create l_file.make (output_path + file_name_prefix + "_" + i.out + ".txt")
			until
				not l_file.exists
			loop
				Check l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)

				l_data := l_file.last_string.split ('%N')

				check l_data.i_th (1).is_equal (class_.name) end
				check l_data.i_th (2).is_equal (feature_.feature_name_32) end
				check l_data.last.is_equal ("EOF") end
				l_file.close
				i := i + 1
				create l_file.make (output_path + file_name_prefix + "_" + i.out + ".txt")
			end
			number_of_data_files := i
		end

	update_string_data_file_content
			--
		local
			l_pre_bp_slot, l_post_bp_slot: INTEGER
			l_bp_slots: TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_loc_expr: STRING
			l_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
		do
			from
				analysis_order_pairs.start
			until
				analysis_order_pairs.after
			loop
				l_bp_slots := analysis_order_pairs.item
				l_pre_bp_slot := l_bp_slots.pre_state_bp_slot
				l_post_bp_slot := l_bp_slots.post_state_bp_slot

				string_data_file_content.append_integer (l_pre_bp_slot)
				string_data_file_content.append_character (';')
				string_data_file_content.append_integer (l_post_bp_slot)
				string_data_file_content.append_character ('%N')

				analysis_order_pairs.forth
			end
			create analysis_order_pairs.make

			create l_type_finder

			from
				expression_value_transitions.start
			until
				expression_value_transitions.after
			loop
				l_transition := expression_value_transitions.item_for_iteration

				l_loc_expr := l_transition.pre_state_bp.out + ";" + l_transition.expression.text

				-- Pre-state value
				l_type_finder.set_value (l_transition.pre_state_value)
				l_type_finder.find
				string_data_file_content.append (l_transition.expression.text)
				string_data_file_content.append_character (';')
				string_data_file_content.append_integer (l_transition.pre_state_bp)
				string_data_file_content.append_character (';')
				string_data_file_content.append (l_type_finder.type)
				string_data_file_content.append_character (';')
				string_data_file_content.append (l_transition.pre_state_value.text)
				string_data_file_content.append_character (';')
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.pre_state_value.type as l_type then
						string_data_file_content.append_integer (l_type.class_id)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					string_data_file_content.append (l_transition.pre_state_value.item.out)
				end
				string_data_file_content.append_character (';')

				-- Post-state value
				l_type_finder.set_value (l_transition.post_state_value)
				l_type_finder.find
				string_data_file_content.append_integer (l_transition.post_state_bp)
				string_data_file_content.append_character (';')
				string_data_file_content.append (l_type_finder.type)
				string_data_file_content.append_character (';')
				string_data_file_content.append (l_transition.post_state_value.text)
				string_data_file_content.append_character (';')
				if l_type_finder.type.is_equal (reference_value) then
					if attached {CL_TYPE_A} l_transition.post_state_value.type as l_type then
						string_data_file_content.append_integer (l_type.class_id)
					end
				end
				if l_type_finder.type.is_equal (string_value) then
					string_data_file_content.append (l_transition.post_state_value.item.out)
				end
				string_data_file_content.append_character ('%N')

				expression_value_transitions.forth
			end
			create expression_value_transitions.make
		end

end
