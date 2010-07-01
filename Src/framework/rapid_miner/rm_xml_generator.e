note
	description: "Summary description for {RM_XML_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_XML_GENERATOR

create
	make

feature{NONE}

	make(a_algorithm_code: INTEGER; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST[STRING]; a_label_name: STRING)
		local
			rm_const: RM_CONSTANTS
		do
			algorithm_code := a_algorithm_code
			validation_code := a_validation_code
			arff_file_path := a_arff_file_path
			selected_attributes := a_selected_attributes
			label_name := a_label_name

			create rm_const.make
			rm_env := rm_const.rm_environment
		end

feature -- Access

	xml: STRING
		-- the generated xml

feature -- Interface

	generate_xml
			-- generates the xml for rapidminer according to the arguments provided in the creation feature
		local
			rm_seed_generator: RM_SEED_XML_GENERATOR
		do
			create rm_seed_generator.make (algorithm_code, validation_code)
			rm_seed_generator.generate_xml
			xml := rm_seed_generator.xml

			put_file_path

			put_selected_attributes

			put_label_name

			put_algorithm_name

			if validation_code /= {RM_CONSTANTS}.no_validation then
				put_validation_name
			end

			if algorithm_parameters /= Void then
				put_algorithm_parameters
			end

			if validation_code /= {RM_CONSTANTS}.no_validation and validation_parameters /= Void then
				put_validation_parameters
			end


		end

	set_algorithm_parameters(a_alg_params: HASH_TABLE[STRING, STRING])
			-- sets the algorithm parameters
		do
			algorithm_parameters := a_alg_params
		end

	set_validation_parameters(a_val_params: HASH_TABLE[STRING, STRING])
			-- sets the validation parameters
		do
			validation_parameters := a_val_params
		end

feature{RM_XML_GENERATOR}

	put_file_path
			-- puts the file name into the xml string at the appropriate placeholder
		require
			xml_not_empty: not xml.is_empty
			data_file_not_empty: not arff_file_path.is_empty
			has_the_file_path_placeholder: xml.has_substring ({RM_CONSTANTS}.data_file_placeholder)
		local
			l_start_index, l_end_index: INTEGER
		do
			l_start_index := xml.substring_index ({RM_CONSTANTS}.data_file_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.data_file_placeholder.count - 1
			xml.replace_substring (arff_file_path, l_start_index , l_end_index)
		ensure
			no_more_file_path_placeholder: not xml.has_substring ({RM_CONSTANTS}.data_file_placeholder)
			has_file_name: xml.has_substring (arff_file_path)
		end

	put_selected_attributes
			-- puts the selected attributes into the xml string at the appropriate placeholder
		require
			xml_not_empty: not xml.is_empty
			selected_attributes_not_empty: not selected_attributes.is_empty
			has_the_selected_attributes_placeholder: xml.has_substring ({RM_CONSTANTS}.selected_attributes_placeholder)
		local
			l_start_index, l_end_index: INTEGER
			l_attributes: STRING
		do
			l_attributes := ""
			from selected_attributes.start until selected_attributes.after	loop
				l_attributes.append (selected_attributes.item_for_iteration + "|")
				selected_attributes.forth
			end
			l_start_index := xml.substring_index ({RM_CONSTANTS}.selected_attributes_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.selected_attributes_placeholder.count - 1
			xml.replace_substring (l_attributes, l_start_index , l_end_index)
		ensure
			no_more_label_name_placeholder: not xml.has_substring ({RM_CONSTANTS}.selected_attributes_placeholder)
		end

	put_label_name
			-- puts the label name into the xml string at the appropriate placeholder
		require
			xml_not_empty: not xml.is_empty
			label_name_not_empty: not label_name.is_empty
			has_label_name_placeholder: xml.has_substring ({RM_CONSTANTS}.label_name_placeholder)
		local
			l_start_index, l_end_index: INTEGER
		do
			l_start_index := xml.substring_index ({RM_CONSTANTS}.label_name_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.label_name_placeholder.count - 1
			xml.replace_substring (label_name, l_start_index , l_end_index)
		ensure
			no_more_label_name_placeholder: not xml.has_substring ({RM_CONSTANTS}.label_name_placeholder)
			has_label_name: xml.has_substring (label_name)
		end

	put_validation_name
			-- puts the validation into the xml string at the appropriate placeholder
		require
			xml_not_empty: not xml.is_empty
			is_not_no_validation: validation_code /= {RM_CONSTANTS}.no_validation
			has_the_validation_namer_placeholder: xml.has_substring ({RM_CONSTANTS}.validation_name_placeholder)
		local
			l_start_index, l_end_index: INTEGER
			rm_constants: RM_CONSTANTS
		do
			l_start_index := xml.substring_index ({RM_CONSTANTS}.validation_name_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.validation_name_placeholder.count - 1
			create rm_constants.make
			xml.replace_substring (rm_constants.validation_code_to_string (validation_code), l_start_index , l_end_index)
		ensure
			no_more_validation_placeholder: not xml.has_substring ({RM_CONSTANTS}.validation_name_placeholder)
		end

	put_algorithm_name
			-- puts the algorithm name in the xml
		require
			xml_not_empty: not xml.is_empty
			has_the_algorithm_name_placeholder: xml.has_substring ({RM_CONSTANTS}.algorithm_name_placeholder)
		local
			l_start_index, l_end_index: INTEGER
			rm_constants: RM_CONSTANTS
		do
			l_start_index := xml.substring_index ({RM_CONSTANTS}.algorithm_name_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.algorithm_name_placeholder.count - 1
			create rm_constants.make
			xml.replace_substring (rm_constants.algorithm_code_to_string (algorithm_code), l_start_index , l_end_index)
		ensure
			no_more_algorithm_placeholder: not xml.has_substring ({RM_CONSTANTS}.algorithm_name_placeholder)
		end

	put_algorithm_parameters
			-- puts the algorithm parameters into the xml string at the appropriate placeholder
		require
			algorithm_params_is_not_void: algorithm_parameters /= Void
			has_the_algorithm_params_placeholder: xml.has_substring ({RM_CONSTANTS}.algorithm_parameters_placeholder)
		local
			l_params_string: STRING
			l_start_index, l_end_index: INTEGER
		do
			l_params_string := "%N"
			from algorithm_parameters.start until algorithm_parameters.after loop
				l_params_string.append (" <parameter key=%"")
				l_params_string.append (algorithm_parameters.key_for_iteration)
				l_params_string.append ("%" value=%"")
				l_params_string.append (algorithm_parameters.item_for_iteration)
				l_params_string.append ("%"/>")
				l_params_string.append ("%N")
				algorithm_parameters.forth
			end
			l_start_index := xml.substring_index ({RM_CONSTANTS}.algorithm_parameters_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.algorithm_parameters_placeholder.count - 1
			xml.replace_substring (l_params_string, l_start_index , l_end_index)
		ensure
			no_more_algorithm_params_placeholder:  not xml.has_substring ({RM_CONSTANTS}.algorithm_parameters_placeholder)
		end

	put_validation_parameters
			-- puts the validation parameters into the xml string at the appropriate placeholder
		require
			validation_params_is_not_void: validation_parameters /= Void
			has_the_validation_params_placeholder: xml.has_substring ({RM_CONSTANTS}.validation_parameters_placeholder)
		local
			l_params_string: STRING
			l_start_index, l_end_index: INTEGER
		do
			l_params_string := "%N"
			from validation_parameters.start until validation_parameters.after loop
				l_params_string.append (" <parameter key=%"")
				l_params_string.append (validation_parameters.key_for_iteration)
				l_params_string.append ("%" value=%"")
				l_params_string.append (validation_parameters.item_for_iteration)
				l_params_string.append ("%"/>")
				l_params_string.append ("%N")
				validation_parameters.forth
			end
			l_start_index := xml.substring_index ({RM_CONSTANTS}.validation_parameters_placeholder, 1)
			l_end_index := l_start_index + {RM_CONSTANTS}.validation_parameters_placeholder.count - 1
			xml.replace_substring (l_params_string, l_start_index , l_end_index)
		ensure
			no_more_validation_params_placeholder:  not xml.has_substring ({RM_CONSTANTS}.validation_parameters_placeholder)
		end

feature{RM_XML_GENERATOR} -- internal data holders

	rm_env: RM_ENVIRONMENT

	algorithm_code: INTEGER

	validation_code: INTEGER

	arff_file_path: STRING

	selected_attributes: LIST[STRING]

	label_name: STRING

	algorithm_parameters: detachable HASH_TABLE[STRING, STRING]

	validation_parameters: detachable HASH_TABLE[STRING, STRING]

end
