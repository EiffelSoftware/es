note
	description: "Represents a clasifier bulder class."
	author: "Nikolay Kazmin"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RM_BUILDER


feature{RM_BUILDER} -- Initializaiton

	init(a_algorithm_code: INTEGER; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST[STRING]; a_label_name: STRING)
		local
			rm_const: RM_CONSTANTS
		do
			algorithm_code := a_algorithm_code
			validation_code := a_validation_code
			arff_file_path := a_arff_file_path
			selected_attributes := a_selected_attributes
			label_name := a_label_name
			create rm_const
			rm_env := rm_const.rm_environment
		end

feature -- Interface

	build
			-- builds the tree with the help of rapidminer(template method pattern)
		do
			prepare_xml_file

			run_rapidminer

			parse_model

			parse_performance

--			clean_files
		end

	set_algorithm_parameters(a_alg_params: HASH_TABLE[STRING, STRING])
			-- sets the algorithm parameters
		do
			algorithm_parameters := a_alg_params
		end

	set_validation_parameters(a_val_param: HASH_TABLE[STRING, STRING])
			-- sets the validation parameters
		do
			validation_parameters := a_val_param
		end


feature{RM_BUILDER} -- implementation


	parse_model
			-- parses the model file
		deferred
		end

	parse_performance
			-- parses the performance file
		deferred
		end

	run_rapidminer
			-- executes rapidminer with the appropriate xml file stored in rm_env
		local
			l_rapid_execute_string: STRING
			l_executor: EPA_PROCESS_UTILITY
			l_bushon: STRING
		do
			l_rapid_execute_string := "cmd /C %"rapidminer.bat -f "
			l_rapid_execute_string.append (rm_env.rapid_miner_xml_file_path)
			l_rapid_execute_string.append ("%"")

			create l_executor
			l_bushon := l_executor.output_from_program (l_rapid_execute_string, rm_env.rapid_miner_working_directory)
		end

	prepare_xml_file
			-- writes the xml from the seed generator into the xml file provided from the environment
		local
			l_file: PLAIN_TEXT_FILE
		do
			create_xml_generator
			rm_xml_generator.generate_xml

			create l_file.make_open_write (rm_env.rapid_miner_xml_file_path)
			l_file.put_string (rm_xml_generator.xml)
			l_file.close
		end

	clean_files
			-- deletes all the temporary files that were created
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (rm_env.model_file_path)
			if l_file.exists then
				l_file.delete
			end

			create l_file.make_create_read_write (rm_env.performance_file_path)
			if l_file.exists then
				l_file.delete
			end

			create l_file.make_create_read_write (rm_env.rapid_miner_xml_file_path)
			if l_file.exists then
				l_file.delete
			end
		end


feature{RM_BUILDER} -- internal data holders

	create_xml_generator
		do
			create rm_xml_generator.make (algorithm_code, validation_code, arff_file_path, selected_attributes, label_name)

			if algorithm_parameters /= Void then
				rm_xml_generator.set_algorithm_parameters (algorithm_parameters)
			end

			if validation_parameters /= Void then
				rm_xml_generator.set_validation_parameters (validation_parameters)
			end
		end

	rm_xml_generator: RM_XML_GENERATOR

	rm_env: RM_ENVIRONMENT

	algorithm_code: INTEGER

	validation_code: INTEGER

	arff_file_path: STRING

	selected_attributes: LIST[STRING]

	label_name: STRING

	algorithm_parameters: detachable HASH_TABLE[STRING, STRING]

	validation_parameters: detachable HASH_TABLE[STRING, STRING]
end
