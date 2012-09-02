note
	description: "A writer that writes the data from a dynamic program analysis to disk using one or multiple JSON data files."
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

			restore
			initialize_json_data_file_content
			update_string_data_file_content
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
			update_json_analysis_order_pairs
			update_json_expression_value_transitions

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
			update_json_analysis_order_pairs
			update_json_expression_value_transitions

			update_string_data_file_content

			create l_file.make_create_read_write (output_path + file_name_prefix + "_" + number_of_data_files.out + ".txt")
			l_file.put_string (string_data_file_content)
			l_file.close

			number_of_data_files := number_of_data_files + 1

			initialize_json_data_file_content

			update_string_data_file_content
		end

feature {NONE} -- Implementation

	json_data_file_content: JSON_OBJECT
			--

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
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
			l_file_content, l_class, l_feature: STRING
			l_parser: JSON_PARSER
			l_parsed_json_value: JSON_VALUE
		do
			from
				i := 1
				create l_file_name.make_from_string (output_path + file_name_prefix + "_" + i.out + ".txt")
				check l_file_name.is_valid end
				create l_file.make (l_file_name.string)
			until
				not l_file.exists
			loop
				check l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_file_content := l_file.last_string
				create l_parser.make_parser (l_file_content)
				l_parsed_json_value := l_parser.parse
				if attached {JSON_OBJECT} l_parsed_json_value as l_json_object then
					l_class := string_from_json (l_json_object.item (class_json_string))
					Check l_class.is_equal (class_.name) end
					l_feature := string_from_json (l_json_object.item (feature_json_string))
					Check l_feature.is_equal (feature_.feature_name_32) end
				end
				i := i + 1
				create l_file.make (output_path + file_name_prefix + "_" + i.out + ".txt")
			end
			number_of_data_files := i
		end

	initialize_json_data_file_content
			--
		do
			create analysis_order_pairs.make
			create expression_value_transitions.make

			create json_analysis_order_pairs.make_array
			create json_expression_value_transitions.make

			create json_data_file_content.make
			json_data_file_content.put (json_string_from_string (class_.name), class_json_string)
			json_data_file_content.put (json_string_from_string (feature_.feature_name_32), feature_json_string)
			json_data_file_content.put (json_analysis_order_pairs, analysis_order_pairs_json_string)
			json_data_file_content.put (json_expression_value_transitions, expression_value_transitions_json_string)
		end

	update_string_data_file_content
			--
		local
			l_json_printer: DPA_PRINT_JSON_VISITOR
		do
			create l_json_printer.make
			json_data_file_content.accept (l_json_printer)
			string_data_file_content := l_json_printer.to_json
		end

end
