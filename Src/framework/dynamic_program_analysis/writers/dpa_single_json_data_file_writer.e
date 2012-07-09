note
	description: "Class to write the dynamically gained runtime data to disk."
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

	make (a_context_class: like context_class; a_analyzed_feature: like analyzed_feature; a_output_path: like output_path; a_file_name: like file_name)
			--
		require
			a_context_class_not_void: a_context_class /= Void
			a_analyzed_feature_not_void: a_analyzed_feature /= Void
			a_output_path_not_void: a_output_path /= Void
			a_file_name_not_void: a_file_name /= Void
		do
			context_class := a_context_class
			analyzed_feature := a_analyzed_feature
			output_path := a_output_path
			file_name := a_file_name
		ensure
			context_class_set: context_class = a_context_class
			analyzed_feature_set: analyzed_feature = a_analyzed_feature
			output_path_set: output_path.is_equal (a_output_path)
			file_name_set: file_name.is_equal (a_file_name)
		end

feature -- Access

	file_name: STRING
			--

feature -- Basic operations

	write
			-- Writes `context_class', `analyzed_feature' and `collected_runtime_data' to `output_path'
		local
			l_object, l_data: JSON_OBJECT
			l_analysis_order: JSON_ARRAY
			l_map: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			l_printer: DPA_PRINT_JSON_VISITOR
			l_file: PLAIN_TEXT_FILE
		do
			-- Object to be written to the disk.
			create l_object.make

			-- Add context class and feature information
			l_object.put (json_string_from_string (context_class.name), json_string_from_string ("class"))
			l_object.put (json_string_from_string (analyzed_feature.feature_name_32), json_string_from_string ("feature"))

			-- Add analysis order.
			l_analysis_order := analysis_order_from_list (analysis_order)
			l_object.put (l_analysis_order, analysis_order_json_string)

			-- Add collected runtime data.
			l_data := json_object_from_runtime_data (collected_runtime_data)
			l_object.put (l_data, data_json_string)

			-- Write object to disk.
			create l_printer.make
			l_object.accept (l_printer)

			create l_file.make_create_read_write (output_path + file_name + ".txt")
			l_file.put_string (l_printer.to_json)
			l_file.close
		end

end
