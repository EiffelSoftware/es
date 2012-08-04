note
	description: "Summary description for {DPA_DATA_WRITER}."
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
			--
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
			--

feature -- Writing

	try_write
			-- Nothing to be done
		do
		end

	write
			--
		local
			l_json_data_file_content: JSON_OBJECT
			l_printer: DPA_PRINT_JSON_VISITOR
			l_file: PLAIN_TEXT_FILE
			l_json_analysis_order_pairs, l_json_expression_value_transitions: JSON_OBJECT
		do
			update_json_analysis_order_pairs
			update_json_expression_value_transitions

			create l_json_data_file_content.make
			l_json_data_file_content.put (json_string_from_string (class_.name), class_json_string)
			l_json_data_file_content.put (json_string_from_string (feature_.feature_name_32), feature_json_string)
			l_json_data_file_content.put (json_string_from_string (number_of_analyses.out), number_of_analyses_json_string)
			if existing_json_analysis_order_pairs /= Void then
				existing_json_analysis_order_pairs.put (json_analysis_order_pairs, json_string_from_string (number_of_analyses.out))
				l_json_data_file_content.put (existing_json_analysis_order_pairs, analysis_order_pairs_json_string)
			else
				create l_json_analysis_order_pairs.make
				l_json_analysis_order_pairs.put (json_analysis_order_pairs, json_string_from_string (number_of_analyses.out))
				l_json_data_file_content.put (l_json_analysis_order_pairs, analysis_order_pairs_json_string)
			end
			if existing_json_expression_value_transitions /= Void then
				existing_json_expression_value_transitions.put (json_expression_value_transitions, json_string_from_string (number_of_analyses.out))
				l_json_data_file_content.put (existing_json_expression_value_transitions, expression_value_transitions_json_string)
			else
				create l_json_expression_value_transitions.make
				l_json_expression_value_transitions.put (json_expression_value_transitions, json_string_from_string (number_of_analyses.out))
				l_json_data_file_content.put (l_json_expression_value_transitions, expression_value_transitions_json_string)
			end

			-- Write object to disk.
			create l_printer.make
			l_json_data_file_content.accept (l_printer)

			create l_file.make_create_read_write (output_path + file_name + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

feature {NONE} -- Implementation

	existing_json_analysis_order_pairs: JSON_OBJECT
			--

	existing_json_expression_value_transitions: JSON_OBJECT
			--

feature {NONE} -- Implementation

	restore
			--	
		local
			l_file: PLAIN_TEXT_FILE
			l_file_content, l_class, l_feature: STRING
			l_parser: JSON_PARSER
			l_parsed_json_value: JSON_VALUE
			l_number_of_analyses: INTEGER
		do
			number_of_analyses := 1
			create l_file.make (output_path + file_name + ".txt")
			if l_file.exists then
				Check l_file.is_readable end
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
					l_number_of_analyses := string_from_json (l_json_object.item (number_of_analyses_json_string)).to_integer
					Check l_number_of_analyses + 1 > number_of_analyses end
					number_of_analyses := l_number_of_analyses + 1
					if attached {JSON_OBJECT} l_json_object.item (expression_value_transitions_json_string) as l_expression_value_transitions then
						existing_json_expression_value_transitions := l_expression_value_transitions
					end
					if attached {JSON_OBJECT} l_json_object.item (analysis_order_pairs_json_string) as l_analysis_order_pairs then
						existing_json_analysis_order_pairs := l_analysis_order_pairs
					end
				end
			end
		end

	string_from_json (a_json_value: JSON_VALUE): STRING
			-- String contained in `a_json_value' if `a_json_value' is a JSON_STRING.
		require
			a_json_value_not_void: a_json_value /= Void
		do
			if attached {JSON_STRING} a_json_value as l_json_string then
				Result := l_json_string.item
			end
		end

end
