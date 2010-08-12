note
	description: "This class will generated the required xml for runny rapidminer. It depends on the algorithm code and validation code."
	author: "Nikolay Kazmin"
	date: "$Date$"
	revision: "$Revision$"

class
	RM_XML_GENERATOR

inherit
	RM_CONSTANTS

create
	make

feature{NONE} -- Creation

	make (a_algorithm_name: STRING; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- `a_algorithm_name' is the algorithm name representing the type of algorithm to be performed by rapid miner.
			-- `a_validation_code' is the validation which will be performed by rapid miner.
			-- `a_arff_file_path' is the absolute file path to the arff file, which will provide the data for rapid miner.
			-- `a_selected_attributes' is the attributes to be selected by RapidMiner
			-- `a_label_name' is the target attribute name.
		require
			selected_attributes_not_empty: not a_selected_attributes.is_empty
			a_label_attribute_valid: a_selected_attributes.has (a_label_name)
			valid_algorithm: is_valid_algorithm_name (a_algorithm_name)
			valid_validation: is_valid_validation_code (a_validation_code)
		local
			rm_const: RM_CONSTANTS
		do
			algorithm_name := a_algorithm_name
			validation_code := a_validation_code
			arff_file_path := a_arff_file_path
			selected_attributes := a_selected_attributes
			label_name := a_label_name
		end

feature -- Access

	xml: STRING
		-- The generated xml

feature -- Interface

	generate_xml
			-- Generates the xml for rapidminer according to the arguments provided in the creation feature. Use `xml' to get the result.
		local
			rm_seed_generator: RM_SEED_XML_GENERATOR
		do
			create rm_seed_generator.make (algorithm_name, validation_code)
			rm_seed_generator.generate_xml
			xml := rm_seed_generator.xml

			put_file_path

			put_selected_attributes

			put_label_name

			put_algorithm_name

			if validation_code /= {RM_CONSTANTS}.no_validation then
				put_validation_name

				put_validation_parameters
			end

			put_algorithm_parameters
		ensure
			no_placeholder: not xml.has_substring (placeholder_algorithm_name)
			no_placeholder: not xml.has_substring (placeholder_algorithm_parameters)
			no_placeholder: not xml.has_substring (placeholder_data_file)
			no_placeholder: not xml.has_substring (placeholder_label_name)
			no_placeholder: not xml.has_substring (placeholder_selected_attributes)
			no_placeholder: not xml.has_substring (placeholder_validation_name)
			no_placeholder: not xml.has_substring (placeholder_validation_parameters)
		end

	set_algorithm_parameters (a_parameters: HASH_TABLE [STRING, STRING])
			-- Sets the algorithm parameters.
			-- `a_alg_params' is a set of parameters specifying options for the current algorithm. They will be written in the
			-- xml file given to rapid miner. The key is the parameter name and the value is the value.
		do
			algorithm_parameters := a_parameters
		ensure
			algorithm_parameters = a_parameters
		end

	set_validation_parameters (a_parameters: HASH_TABLE [STRING, STRING])
			-- Sets the validation parameters.
			-- `a_parameters' is a set of parameters specifying options for the current validation. They will be written in the
			-- xml file given to rapid miner. The key is the parameter name and the value is the value.
		do
			validation_parameters := a_parameters
		ensure
			validation_parameters = a_parameters
		end

feature{RM_XML_GENERATOR} -- The pieces of the generation. To be overriden if necessary.

	put_file_path
			-- Puts the file path in the `xml' at the place of `placeholder_data_file'
		require
			xml_not_empty: not xml.is_empty
			data_file_not_empty: not arff_file_path.is_empty
			has_the_file_path_placeholder: xml.has_substring (placeholder_data_file)
		local
			l_start_index, l_end_index: INTEGER
		do
			replace_placeholder (placeholder_data_file, arff_file_path)
		ensure
			no_more_file_path_placeholder: not xml.has_substring (placeholder_data_file)
			has_file_name: xml.has_substring (arff_file_path)
		end

	put_selected_attributes
			-- Puts the selected attributes in the `xml' at the place of `placeholder_selected_attributes'
		require
			xml_not_empty: not xml.is_empty
			selected_attributes_not_empty: not selected_attributes.is_empty
			has_the_selected_attributes_placeholder: xml.has_substring (placeholder_selected_attributes)
		local
			l_start_index, l_end_index: INTEGER
			l_attributes: STRING
		do
			l_attributes := ""
			from selected_attributes.start until selected_attributes.after	loop
				l_attributes.append (selected_attributes.item_for_iteration + "|")
				selected_attributes.forth
			end
			replace_placeholder (placeholder_selected_attributes, l_attributes)
		ensure
			no_more_label_name_placeholder: not xml.has_substring (placeholder_selected_attributes)
		end

	put_label_name
			-- Puts the label name in the `xml' at the place of `placeholder_label_name'
		require
			xml_not_empty: not xml.is_empty
			label_name_not_empty: not label_name.is_empty
			has_label_name_placeholder: xml.has_substring (placeholder_label_name)
		local
			l_start_index, l_end_index: INTEGER
		do
			replace_placeholder (placeholder_label_name, label_name)
		ensure
			no_more_label_name_placeholder: not xml.has_substring (placeholder_label_name)
			has_label_name: xml.has_substring (label_name)
		end

	put_validation_name
			-- Puts the validation name in the `xml' at the place of `placeholder_validation_name'
		require
			xml_not_empty: not xml.is_empty
			is_not_no_validation: validation_code /= no_validation
			has_the_validation_namer_placeholder: xml.has_substring (placeholder_validation_name)
		local
			l_start_index, l_end_index: INTEGER
			rm_constants: RM_CONSTANTS
		do
			create rm_constants
			replace_placeholder (placeholder_validation_name, rm_constants.validation_code_to_string (validation_code))
		ensure
			no_more_validation_placeholder: not xml.has_substring (placeholder_validation_name)
		end

	put_algorithm_name
			-- Puts the algorithm name in the `xml' at the place of `placeholder_algorithm_name'
		require
			xml_not_empty: not xml.is_empty
			has_the_algorithm_name_placeholder: xml.has_substring (placeholder_algorithm_name)
		local
			l_start_index, l_end_index: INTEGER
		do
			replace_placeholder (placeholder_algorithm_name, algorithm_name)
		ensure
			no_more_algorithm_placeholder: not xml.has_substring ({RM_CONSTANTS}.placeholder_algorithm_name)
			has_algorithm_name: xml.has_substring (algorithm_name)
		end

	put_algorithm_parameters
			-- Puts the algorithm parameters in the `xml' at the place of `placeholder_algorithm_parameters'
		require
			has_the_algorithm_params_placeholder: xml.has_substring (placeholder_algorithm_parameters)
		local
			l_params_string: STRING
			l_start_index, l_end_index: INTEGER
		do
			l_params_string := "%N"
			if validation_code /= {RM_CONSTANTS}.no_validation and validation_parameters /= Void then
				from algorithm_parameters.start until algorithm_parameters.after loop
					l_params_string.append (" <parameter key=%"")
					l_params_string.append (algorithm_parameters.key_for_iteration)
					l_params_string.append ("%" value=%"")
					l_params_string.append (algorithm_parameters.item_for_iteration)
					l_params_string.append ("%"/>")
					l_params_string.append ("%N")
					algorithm_parameters.forth
				end
			end
			replace_placeholder (placeholder_algorithm_parameters, l_params_string)
		ensure
			no_more_algorithm_params_placeholder:  not xml.has_substring (placeholder_algorithm_parameters)
		end

	put_validation_parameters
			-- Puts the algorithm parameters in the `xml' at the place of `placeholder_validation_parameters'
		require
			has_the_validation_params_placeholder: xml.has_substring (placeholder_validation_parameters)
		local
			l_params_string: STRING
			l_start_index, l_end_index: INTEGER
		do
			l_params_string := "%N"
			if algorithm_parameters /= Void then
				from validation_parameters.start until validation_parameters.after loop
					l_params_string.append (" <parameter key=%"")
					l_params_string.append (validation_parameters.key_for_iteration)
					l_params_string.append ("%" value=%"")
					l_params_string.append (validation_parameters.item_for_iteration)
					l_params_string.append ("%"/>")
					l_params_string.append ("%N")
					validation_parameters.forth
				end
			end
			replace_placeholder (placeholder_validation_parameters, l_params_string)
		ensure
			no_more_validation_params_placeholder:  not xml.has_substring (placeholder_validation_parameters)
		end

feature{NONE} -- Implemenation

	replace_placeholder (a_placehodler_name: STRING; a_replacement: STRING)
			-- replaces `a_placeholder' in the `xml' string with `a_replacement'
		require
			xml_not_empty: not xml.is_empty
			a_replacement_not_empty: not a_replacement.is_empty
			has_the_placeholder: xml.has_substring (a_placehodler_name)
		local
			l_start_index, l_end_index: INTEGER
		do
			l_start_index := xml.substring_index (a_placehodler_name, 1)
			l_end_index := l_start_index + a_placehodler_name.count - 1
			xml.replace_substring (a_replacement, l_start_index , l_end_index)
		ensure
			no_more_placeholder: not xml.has_substring (a_placehodler_name)
			has_replacement: xml.has_substring (a_replacement)
		end

feature{RM_XML_GENERATOR} -- internal data holders

	algorithm_name: STRING
			-- The name of the algorithm to be included in the generated xml file.

	validation_code: INTEGER
			-- The code for the validation to be included in the generated xml file.

	arff_file_path: STRING
			-- Absolute file path to the arff file to be included in the generated xml file.

	selected_attributes: LIST [STRING]
			-- A list of the selected attributes, from which rapid miner will try to infer contracts.

	label_name: STRING
			-- The target variable which will be given to rapid miner.

	algorithm_parameters: detachable HASH_TABLE [STRING, STRING]
			-- A set of parameters specifying options for the current algorithm. They will be written in the
			-- xml file given to rapid miner. The key is the parameter name and the value is the value.

	validation_parameters: detachable HASH_TABLE [STRING, STRING]
			-- A set of parameters specifying options for the current validation. They will be written in the
			-- xml file given to rapid miner. The key is the parameter name and the value is the value.

invariant

	algorithm_name_valid: is_valid_algorithm_name (algorithm_name)

	validation_valid: is_valid_validation_code (validation_code)

	label_belongs_to_selected: selected_attributes.has (label_name)

end
