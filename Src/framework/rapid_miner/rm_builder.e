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

	init (a_algorithm_code: INTEGER; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- `a_selected_attributes' is the attributes to be selected by RapidMiner
			-- `a_label_name' is the target attribute name.
			-- Initialize some attributes.
		local
			rm_const: RM_CONSTANTS
		do
			algorithm_code := a_algorithm_code
			validation_code := a_validation_code
			arff_file_path := a_arff_file_path
			selected_attributes := a_selected_attributes
			label_name := a_label_name
			create rm_const
		end

	init_with_relation (a_algorithm_code: INTEGER; a_relation: WEKA_ARFF_RELATION; a_selected_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_label_attribute: WEKA_ARFF_ATTRIBUTE)
			-- Initialize current with ARFF relation `a_relation'.
			-- `a_selected_attributes' is a subset of attributes in `a_relation', which will be used for the tree learning.
			-- `a_label_attribute' is the goal attribute whose values are to be classified by the learnt tree.
			-- Use default decision tree algorithm, and default validation criterion.
		require
			a_selection_attributes_valid: a_selected_attributes.is_subset (a_relation.attribute_set)
			a_label_attribute_valid: a_selected_attributes.has (a_label_attribute)
		local
			l_arff_file: PLAIN_TEXT_FILE
			l_attr_list: LINKED_LIST[STRING]
		do
			create l_arff_file.make_create_read_write (rm_environment.rapid_miner_arff_file_path)
			a_relation.to_medium (l_arff_file)
			l_arff_file.close

			create l_attr_list.make
			from a_selected_attributes.start until a_selected_attributes.after loop
				l_attr_list.force (a_selected_attributes.item_for_iteration.name)
				a_selected_attributes.forth
			end

			init (a_algorithm_code, no_validation, rm_environment.rapid_miner_arff_file_path, l_attr_list, a_label_attribute.name)
		end

feature -- Interface

	build
			-- Builds the tree with the help of rapidminer. Implements the template method pattern.
		do
			prepare_xml_file

			run_rapidminer

			parse_model

			parse_performance

--			clean_files
		end

feature -- Setters

	set_algorithm_parameters(a_alg_params: HASH_TABLE [STRING, STRING])
			-- Sets the algorithm parameters.
		do
			algorithm_parameters := a_alg_params
		end

	set_validation_parameters(a_val_param: HASH_TABLE [STRING, STRING])
			-- Sets the validation parameters.
		do
			validation_parameters := a_val_param
		end

	set_validation_type( a_validation_code: INTEGER)
			-- Set `validation_code' with `a_validation_code'.
		require
			valid_type: is_valid_validation_code (a_validation_code)
		do
			validation_code := a_validation_code
		ensure
			validation_code = a_validation_code
		end

	set_algorithm_type( a_algorithm_code: INTEGER)
			-- Set `algorithm_code' with `a_algorithm_code'.
		require
			valid_algorithm: is_valid_algorithm_code (a_algorithm_code)
		do
			algorithm_code := a_algorithm_code
		ensure
			algorithm_code = a_algorithm_code
		end


feature{RM_BUILDER} -- Implementation


	parse_model
			-- Parses the model file.
		deferred
		end

	parse_performance
			-- Parses the performance file.
		deferred
		end

	run_rapidminer
			-- Executes rapidminer with the appropriate xml file stored in rm_environment.						
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
			-- Writes the xml from the seed generator into the xml file provided from the environment.
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
			create l_file.make_create_read_write (rm_environment.model_file_path)
			if l_file.exists then
				l_file.delete
			end

			create l_file.make_create_read_write (rm_environment.performance_file_path)
			if l_file.exists then
				l_file.delete
			end

			create l_file.make_create_read_write (rm_environment.rapid_miner_xml_file_path)
			if l_file.exists then
				l_file.delete
			end

			create l_file.make_create_read_write (rm_environment.rapid_miner_arff_file_path)
			if l_file.exists then
				l_file.delete
			end
		end

feature {RM_BUILDER} -- creation encapsulation

	create_xml_generator: RM_XML_GENERATOR
			-- Factory method creating an RM_XML_GENERATOR
		do
			create Result.make (algorithm_code, validation_code, arff_file_path, selected_attributes, label_name)

			if algorithm_parameters /= Void then
				Result.set_algorithm_parameters (algorithm_parameters)
			end

			if validation_parameters /= Void then
				Result.set_validation_parameters (validation_parameters)
			end
		end

feature{RM_BUILDER} -- Internal data holders

	algorithm_code: INTEGER

	validation_code: INTEGER

	arff_file_path: STRING

	selected_attributes: LIST[STRING]

	label_name: STRING

	algorithm_parameters: detachable HASH_TABLE[STRING, STRING]

	validation_parameters: detachable HASH_TABLE[STRING, STRING]
end
