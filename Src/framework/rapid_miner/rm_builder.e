note
	description: "Represents a clasifier bulder class."
	author: "Nikolay Kazmin"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RM_BUILDER

inherit
	RM_CONSTANTS


feature{RM_BUILDER} -- Initializaiton

	initialize (a_algorithm_name: STRING; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- `a_algorithm_name' is the algorithm name representing the type of algorithm to be performed by rapid miner.
			-- `a_validation_code' is the validation which will be performed by rapid miner.
			-- `a_arff_file_path' is the absolute file path to the arff file, which will provide the data for rapid miner.
			-- `a_selected_attributes' is the attributes to be selected by RapidMiner
			-- `a_label_name' is the target attribute name.
			-- Initialize some attributes.
		require
			selected_attributes_not_empty: not a_selected_attributes.is_empty
			a_label_attribute_valid: a_selected_attributes.has (a_label_name)
			valid_algorithm: is_valid_algorithm_name (a_algorithm_name)
		do
			algorithm_name := a_algorithm_name.twin
			validation_code := a_validation_code
			arff_file_path := a_arff_file_path.twin
			selected_attributes := a_selected_attributes
			label_name := a_label_name.twin
		end

	initialize_with_relation (a_algorithm_name: STRING; a_relation: WEKA_ARFF_RELATION; a_selected_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_label_attribute: WEKA_ARFF_ATTRIBUTE)
			-- Initialize current with ARFF relation `a_relation'.
			-- `a_algorithm_name' is the algorithm name representing the type of algorithm to be performed by rapid miner.
			-- `a_validation_code' is the validation which will be performed by rapid miner.
			-- `a_selected_attributes' is a subset of attributes in `a_relation', which will be used for the tree learning.
			-- `a_label_attribute' is the goal attribute whose values are to be classified by the learnt tree.
			-- Use default decision tree algorithm, and default validation criterion.
		require
			a_selection_attributes_valid: a_selected_attributes.is_subset (a_relation.attribute_set)
			a_label_attribute_valid: a_selected_attributes.has (a_label_attribute)
			valid_algorithm: is_valid_algorithm_name (a_algorithm_name)
		local
			l_arff_file: PLAIN_TEXT_FILE
			l_attr_list: LINKED_LIST [STRING]
		do
			create l_arff_file.make_create_read_write (rm_environment.rapid_miner_arff_file_path)
			a_relation.to_medium (l_arff_file)
			l_arff_file.close

			create l_attr_list.make
			from a_selected_attributes.start until a_selected_attributes.after loop
				l_attr_list.force (a_selected_attributes.item_for_iteration.name)
				a_selected_attributes.forth
			end

			initialize (a_algorithm_name, no_validation, rm_environment.rapid_miner_arff_file_path, l_attr_list, a_label_attribute.name)
		end

feature -- Interface

	build
			-- Build the classification with the help of rapidminer. Implements the template method pattern.
		do
			prepare_xml_file

			run_rapidminer

			parse_model

			parse_performance

			clean_files
		end

feature -- Setters

	set_algorithm_parameters (a_parameters: HASH_TABLE [STRING, STRING])
			-- Sets the algorithm parameters.
			-- `a_parameters' is a set of parameters specifying options for the current algorithm. They will be written in the
			-- XML file given to rapid miner. The key is the parameter name and the value is the value.
		do
			algorithm_parameters := a_parameters
		ensure
			algorithm_parameters = a_parameters
		end

	set_validation_parameters (a_parameters: HASH_TABLE [STRING, STRING])
			-- Sets the validation parameters.
			-- `a_parameters' is a set of parameters specifying options for the current validation. They will be written in the
			-- XML file given to rapid miner. The key is the parameter name and the value is the value.
		do
			validation_parameters := a_parameters
		ensure
			validation_parameters = a_parameters
		end

	set_validation_type (a_validation_code: INTEGER)
			-- Set `validation_code' with `a_validation_code'.
		require
			valid_type: is_valid_validation_code (a_validation_code)
		do
			validation_code := a_validation_code
		ensure
			validation_code = a_validation_code
		end

	set_algorithm_type (a_algorithm_name: STRING)
			-- Set `algorithm_name' with `a_algorithm_name'.
		require
			valid_algorithm: is_valid_algorithm_name (a_algorithm_name)
		do
			algorithm_name := a_algorithm_name
		ensure
			algorithm_name = a_algorithm_name
		end


feature{RM_BUILDER} -- Implementation

	parse_model
			-- Parses the model file. The model file is the file where rapidminer writes the generated
			-- model by running decision tree, linear regression or other algorithm. The location of
			-- that file is taken from rm_environment.
		deferred
		end

	parse_performance
			-- Parses the performance file. The performance file is the file where rapid miner writes the
			-- validation data(if validation is set to be performed. The location of
			-- that file is taken from rm_environment.
		deferred
		end

	run_rapidminer
			-- Executes rapidminer with the appropriate xml file which location is stored in rm_environment.
			-- The xml file contains all the information needed by rapidminer. If there are no errors
			-- rapid miner will produce a model file(location taken from rm_environment) and possibly a
			-- performance file(if validation is turned on) again the location is determined by rm_environment.					
		local
			l_rapid_execute_string: STRING
			l_executor: EPA_PROCESS_UTILITY
			l_bushon: STRING
		do
			create l_rapid_execute_string.make (128)
			l_rapid_execute_string.append ("cmd /C %"rapidminer.bat -f ")
			l_rapid_execute_string.append (rm_environment.rapid_miner_xml_file_path)
			l_rapid_execute_string.append ("%"")

			create l_executor
			l_bushon := l_executor.output_from_program (l_rapid_execute_string, rm_environment.rapid_miner_working_directory)
		end

	prepare_xml_file
			-- Writes the xml from the xml generator into the xml file location provided from the environment.
			-- This xml file should contain all the information required by rapidminer to run correctly.
		local
			l_file: PLAIN_TEXT_FILE
			l_rm_xml_generator: RM_XML_GENERATOR
		do
			l_rm_xml_generator := create_xml_generator
			l_rm_xml_generator.generate_xml

			create l_file.make_open_write (rm_environment.rapid_miner_xml_file_path)
			l_file.put_string (l_rm_xml_generator.xml)
			l_file.close
		end

	clean_files
			-- Deletes all the temporary files that were created.
		local
			l_file: PLAIN_TEXT_FILE
		do
			if rm_environment.should_remove_generated_files then
				create l_file.make (rm_environment.model_file_path)
				if l_file.exists then
					l_file.delete
				end

				create l_file.make (rm_environment.performance_file_path)
				if l_file.exists then
					l_file.delete
				end

				create l_file.make (rm_environment.rapid_miner_xml_file_path)
				if l_file.exists then
					l_file.delete
				end

				create l_file.make (rm_environment.rapid_miner_arff_file_path)
				if l_file.exists then
					l_file.delete
				end
			end
		end

feature {RM_BUILDER} -- creation encapsulation

	create_xml_generator: RM_XML_GENERATOR
			-- Factory method creating an RM_XML_GENERATOR
		do
			create Result.make (algorithm_name, validation_code, arff_file_path, selected_attributes, label_name)

			if algorithm_parameters /= Void then
				Result.set_algorithm_parameters (algorithm_parameters)
			end

			if validation_parameters /= Void then
				Result.set_validation_parameters (validation_parameters)
			end
		end

feature{RM_BUILDER} -- Internal data holders

	algorithm_name: STRING
			-- The name of the algorithm to be used by rapidminer.

	validation_code: INTEGER
			-- The code for validation which will be used by rapidminer.

	arff_file_path: STRING
			-- The absolute file path of the arff file which will be given to rapid miner.

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
