note
	description: "Command that starts the snippet extraction process for a bunch of (compiled) classes according to configured criterias."
	date: "$Date$"
	revision: "$Revision"

class
	EXT_XML_FROM_CLASS_CMD

inherit
	EXT_AST_NODE_CONSTANTS

	REFACTORING_HELPER

	EPA_UTILITY

	EPA_FILE_UTILITY

	EXT_SHARED_LOGGER

	SHARED_EIFFEL_PROJECT

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		require
			a_config_not_void: attached a_config
		do
			config := a_config
		end

feature -- Access

	config: EXT_XML_CONFIG
			-- Configuration for snippet extraction engine.

feature -- Basic operations

	execute
			-- Execute current command.
		do
			if config.generate_schema then
					-- Generate EAST XML Schema document(s).
				generate_xsd_schema_documents
			else
					-- Calling transformation for selected classes.
				across select_classes_for_extraction as l_selected_classes loop
					process_class (l_selected_classes.item)
				end
			end
		end

feature {NONE} -- Implementation

	process_class (a_class: CLASS_C)
			-- Writes the snippets to a file if `{EXT_CONFIG}.output' path is configured.
			-- `a_file_name' is considered as a basic filename that still gets expanded by
			-- a postfix and a file extension.
		local
			l_file_name: STRING
			l_file_path: FILE_NAME
			l_ast_writer: EXT_XML_AST_WRITER
		do
			if attached config.output_path as l_path_name then
				log.put_string ("Processing: ")
				log.put_string (a_class.name_in_upper)
				log.put_string ("%N")

					-- Concatenate the file name.
				create l_file_name.make_from_string (a_class.name)
					-- Create whole path name.
				create l_file_path.make_from_string (l_path_name)
				l_file_path.set_file_name (l_file_name)

				if attached l_file_path.twin as l_xml_file_path then
					l_xml_file_path.add_extension ("XML")

					create l_ast_writer
					l_ast_writer.write_to_file (a_class.ast, l_xml_file_path)
				end
			end
		end

feature {NONE} -- Class selector

	select_classes_for_extraction: like {EPA_CLASS_SELECTOR}.last_classes
			-- Selects the classes for extraction according to `config' flags.
		local
			l_class_selector: EPA_CLASS_SELECTOR
		do
			create l_class_selector

				-- Check configuration flag and configure selector with class name filter.
			if attached config.class_name as l_class_name then
				l_class_selector.criteria.force (agent class_name_selector (?, l_class_name))
			end

				-- Set search scope depending on `group_name' and perform search.
				-- `group_name' is converted to lower case for comparison.
			if attached config.group_name as l_group_name then
				l_group_name.to_lower
				l_class_selector.select_from_group (l_group_name)
			else
				l_class_selector.select_from_target
			end

			Result := l_class_selector.last_classes
		end

	class_name_selector (a_tested_class: CLASS_C; a_class_name: STRING): BOOLEAN
			-- Select class if its name equals to `a_class_name'.	
		local
			l_class_name_in_upper: STRING
		do
			l_class_name_in_upper := a_class_name.twin
			l_class_name_in_upper.to_upper

			Result := a_tested_class.name_in_upper ~ l_class_name_in_upper
		end

feature {NONE} -- Output

	transformer: EXT_XML_FROM_AST_TRANSFORMER
			-- Transformer instance converting from AST to XML.
		once
			create Result.make
		end

	write (a_ast: AST_EIFFEL ; a_medium: IO_MEDIUM)
			-- Write `a_ast' into `a_medium'.
		local
			l_formatter: XML_FORMATTER
		do
			if attached {FILE} a_medium as l_file then

					-- Transform to XML.
				transformer.transform (a_ast)

					-- Write fo file.
				create l_formatter.make
				l_formatter.set_output_file (l_file)
				l_formatter.process_document (transformer.xml_document)

					-- Clean Up.
				transformer.reset
			end
		end

	write_to_file (a_ast: AST_EIFFEL; a_path: STRING)
			-- Write each of `a_ast' to a file whose absolute path is given by `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			write (a_ast, l_file)
			l_file.close
		end

feature {NONE} -- XML Schema Generation

	generate_xsd_schema_documents
			-- Generate EAST XML Schema document(s).
		local
			l_generator: EXT_EAST_GENERATOR
			l_record_list: SORTED_LIST [EXT_EAST_RECORD]
		do
			l_record_list := generate_xsd_record_list

			create l_generator.make
			l_generator.process (l_record_list)

			write_xml_to_file (l_generator.last_xml_document, "east-schema")
		end

	generate_xsd_record_list: SORTED_LIST [EXT_EAST_RECORD]
			-- Collect input for XML Schema generation.
		local
			l_config: EXT_EAST_CONFIG
		do
			create l_config

			create {SORTED_TWO_WAY_LIST [EXT_EAST_RECORD]} Result.make
			Result.append (l_config.record_list)
		end

	write_xml_to_file (a_document: XML_DOCUMENT; a_file_name: STRING)
			-- Extension will be added to `a_file_name'.
		local
			l_file: PLAIN_TEXT_FILE
			l_file_path: FILE_NAME
			l_formatter: XML_FORMATTER
		do
			if attached config.output_path as l_path_name then
					-- Create whole path name.
				create l_file_path.make_from_string (l_path_name)
				l_file_path.set_file_name (a_file_name)

				if attached l_file_path.twin as l_xml_file_path then
					l_xml_file_path.add_extension ("xsd")

					create l_file.make_create_read_write (l_xml_file_path.string)

						-- Write fo file.
					create l_formatter.make
					l_formatter.set_output_file (l_file)
					l_formatter.process_document (a_document)

					l_file.close
				end
			end
		end

end
