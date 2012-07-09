note
	description: "Class to write the dynamically gained runtime data to disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_MULTIPLE_JSON_DATA_FILES_WRITER

inherit
	DPA_JSON_DATA_FILE_WRITER

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
			number_of_data_files := 0
		ensure
			context_class_set: context_class = a_context_class
			analyzed_feature_set: analyzed_feature = a_analyzed_feature
			output_path_set: output_path.is_equal (a_output_path)
			file_name_prefix_set: file_name_prefix.is_equal (a_file_name_prefix)
		end

feature -- Access

	keys: DS_HASH_SET [STRING]
			--

	number_of_data_files: INTEGER
			--

	file_name_prefix: STRING
			--

feature -- Setting

	set_keys (a_keys: like keys)
			--
		require
			a_keys_not_void: a_keys /= Void
		do
			keys := a_keys
		ensure
			keys_set: keys = a_keys
		end

feature -- Basic operations

	generate_root_file
			-- Writes `context_class', `analyzed_feature' and `collected_runtime_data' to `output_path'
		local
			l_file: PLAIN_TEXT_FILE
			l_object, l_data: JSON_OBJECT
			l_analysis_order, l_keys: JSON_ARRAY
			l_printer: DPA_PRINT_JSON_VISITOR
		do
			-- Object to be written to the disk.
			create l_object.make

			-- Add context class and feature information
			l_object.put (json_string_from_string (context_class.name), json_string_from_string ("class"))
			l_object.put (json_string_from_string (analyzed_feature.feature_name_32), json_string_from_string ("feature"))

			l_keys := keys_from_set (keys)
			l_object.put (l_keys, json_string_from_string ("keys"))

			l_object.put (json_string_from_string (number_of_data_files.out), json_string_from_string ("number_of_data_files"))

			-- Write object to disk.
			create l_printer.make
			l_object.accept (l_printer)

			create l_file.make_create_read_write (output_path + file_name_prefix + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {EPA_COLLECTED_RUNTIME_DATA_PROCESSOR2} -- Implementation

	write
			--
		local
			l_file: PLAIN_TEXT_FILE
			l_object, l_data: JSON_OBJECT
			l_analysis_order: JSON_ARRAY
			l_printer: DPA_PRINT_JSON_VISITOR
		do
			-- Object to be written to the disk.
			create l_object.make

			-- Add analysis order.
			l_analysis_order := analysis_order_from_list (analysis_order)
			l_object.put (l_analysis_order, analysis_order_json_string)

			-- Add collected runtime data.
			l_data := json_object_from_runtime_data (collected_runtime_data)
			l_object.put (l_data, data_json_string)

			-- Write object to disk.
			create l_printer.make
			l_object.accept (l_printer)

			number_of_data_files := number_of_data_files + 1
			create l_file.make_create_read_write (output_path + file_name_prefix + "_data_" + number_of_data_files.out + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {NONE} -- Implementation

	keys_from_set (a_keys: like keys): JSON_ARRAY
			--
		require
			a_keys_not_void: a_keys /= Void
		do
			create Result.make_array
			from
				a_keys.start
			until
				a_keys.after
			loop
				Result.add (json_string_from_string (a_keys.item_for_iteration))
				a_keys.forth
			end
		end

end
