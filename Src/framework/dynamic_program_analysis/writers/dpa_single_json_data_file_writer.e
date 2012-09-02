note
	description: "A writer that writes the data from a dynamic program analysis to disk using one JSON data file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_SINGLE_JSON_DATA_FILE_WRITER

inherit
	DPA_JSON_DATA_FILE_WRITER

create
	make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_; a_output_path: like output_path; a_file_name: like file_name)
			-- Initialize current writer and restore data from previous sessions.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_output_path_not_void: a_output_path /= Void
			a_file_name_not_void: a_file_name /= Void
		do
			class_ := a_class
			feature_ := a_feature
			output_path := a_output_path
			file_name := a_file_name

			create analysis_order_pairs.make
			create expression_value_transitions.make

			create json_analysis_order_pairs.make_array
			create json_expression_value_transitions.make

			restore
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			output_path_set: output_path.is_equal (a_output_path)
			file_name_set: file_name.is_equal (a_file_name)
		end

feature -- Access

	file_name: STRING
			-- File name of the JSON data file.

feature -- Writing

	try_write
			-- Nothing to be done.
		do
		end

	write
			-- Write data to disk.
		local
			l_printer: DPA_PRINT_JSON_VISITOR
			l_file: PLAIN_TEXT_FILE
		do
			update_json_analysis_order_pairs
			update_json_expression_value_transitions

			-- Write object to disk.
			create l_printer.make
			json_data_file_content.accept (l_printer)

			create l_file.make_create_read_write (output_path + file_name + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {NONE} -- Implementation

	json_data_file_content: JSON_OBJECT
			-- JSON data file content containing all data such as class name, feature name,
			-- analysis order pairs and expression value transitions.

feature {NONE} -- Implementation

	restore
			-- Restore data from previous sessions.
		local
			l_file: PLAIN_TEXT_FILE
			l_file_content, l_class, l_feature: STRING
			l_parser: JSON_PARSER
			l_parsed_json_value: JSON_VALUE
		do
			create l_file.make (output_path + file_name + ".txt")
			if l_file.exists then
				check l_file.is_readable end
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_file_content := l_file.last_string
				create l_parser.make_parser (l_file_content)
				l_parsed_json_value := l_parser.parse
				check attached {JSON_OBJECT} l_parsed_json_value as l_json_object then
					l_class := string_from_json (l_json_object.item (class_json_string))
					check l_class.is_equal (class_.name) end
					l_feature := string_from_json (l_json_object.item (feature_json_string))
					check l_feature.is_equal (feature_.feature_name_32) end
					json_data_file_content := l_json_object
					check attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_expression_value_transitions then
						json_expression_value_transitions := l_expression_value_transitions
					end
					check attached {JSON_ARRAY} l_json_object.item (analysis_order_pairs_json_string) as l_analysis_order_pairs then
						json_analysis_order_pairs := l_analysis_order_pairs
					end
				end
			else
				create json_data_file_content.make
				create json_analysis_order_pairs.make_array
				create json_expression_value_transitions.make
				json_data_file_content.put (json_string_from_string (class_.name), class_json_string)
				json_data_file_content.put (json_string_from_string (feature_.feature_name_32), feature_json_string)
				json_data_file_content.put (json_analysis_order_pairs, analysis_order_pairs_json_string)
				json_data_file_content.put (json_expression_value_transitions, expression_value_transitions_json_string)
			end
		end

end
