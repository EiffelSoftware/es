note
	description: "Command that starts the snippet extraction process for a bunch of (compiled) classes according to configured criterias."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_PROCESS_CLASSES_CMD

inherit
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

	config: EXT_CONFIG
			-- Configuration for snippet extraction engine.

feature -- Basic operations

	execute
			-- Execute current command.
		local
            l_target_type: TYPE_A
		do
			if config.snippet_log_file /= Void then
				create_snippet_file
			end
			across
				config.target_types as l_type_name_cursor
			loop
					-- Evaluate type information given in `config'.		
				l_target_type := type_a_from_string (l_type_name_cursor.item, root_class_of_system)
				check attached l_target_type end

					-- Calling snippet extraction for selected features of each selected class.
				across select_classes_for_extraction as l_selected_classes loop
					across select_features_for_extraction (l_selected_classes.item) as l_feature_set_cursor loop
						process_feature (l_target_type, l_selected_classes.item, l_feature_set_cursor.item)
					end
				end
			end
			if config.snippet_log_file /= Void then
				close_snippet_file
			end
		end

feature {NONE} -- Implementation


	process_feature (a_target_type: TYPE_A; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Starts processing snippet extraction with relevant `a_target_type' on `a_class' with `a_feature'.
		local
			l_basic_file_name: STRING
			l_origin: EXT_SNIPPET_ORIGIN
			l_extractor: EXT_SNIPPET_EXTRACTOR
			l_ann_extractor: EXT_PROBABILITY_ANNOTATION_EXTRACTOR
			l_normalizer: EXT_SNIPPET_VARIABLE_NAME_NORMALIZER
			l_snips: LINKED_SET [EXT_SNIPPET]
			l_fragment_extractor: EXT_FRAGMENT_EXTRACTOR
		do
			create l_normalizer
			if attached config.namespace as l_namespace then
				create l_origin.make (l_namespace, a_class.name, a_feature.feature_name)
			else
				create l_origin.make ("[unknown]", a_class.name, a_feature.feature_name)
			end

			l_basic_file_name := basic_file_name (a_target_type, l_origin)

				-- Start extraction.
			create {EXT_SNIPPET_EXTRACTOR} l_extractor.make (config)
			l_extractor.extract_from_feature (a_target_type, a_feature, a_class, l_origin)

			l_snips := l_extractor.last_snippets

				-- Store snippets, if any where extracted.
			if attached l_extractor.last_snippets as l_snippets and then not l_snippets.is_empty then
				create l_snips.make
				if config.should_normalize_variable_name then
						-- Snippet variable name normalization, if configured.
					across l_extractor.last_snippets as s loop
						l_snips.extend (l_normalizer.normalized_snippet (s.item))
					end
				else
					l_snips.append (l_extractor.last_snippets)
				end

				if config.should_extract_contract then
					extract_contracts (l_snips)
				end

				if config.should_extract_fragment then
					extract_fragments (l_snips, l_extractor)
				end
				write_snippets_to_file (l_snips, l_basic_file_name, l_origin.out_separator)
				to_implement ("Store snippets in serialized XML format.")

				if config.snippet_log_file /= Void then
					log_snippet_in_file (l_snips)
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

				-- Check configuration flag and configure selector with feature name filter.
			if attached config.feature_name as l_feature_name then
				l_class_selector.criteria.force (agent feature_name_selector (?, l_feature_name))
			end

				-- Set search scope depending on `{EXT_CONFIG}.group_name' and perform search.
				-- `{EXT_CONFIG}.group_name' is converted to lower case for comparison.
			if attached config.group_name as l_group_name then
				l_group_name.to_lower
				l_class_selector.select_from_group (l_group_name)
			else
				l_class_selector.select_from_target
			end

			Result := l_class_selector.last_classes
		end

	select_features_for_extraction (a_class: CLASS_C): LINKED_SET [FEATURE_I]
			-- Selects features from classes for extraction according to `config' flags.
		do
			create {LINKED_SET [FEATURE_I]} Result.make

				-- Selecting features for extraction.
			if attached config.feature_name as l_feature_name then
					-- Convert feature to lower case name
				l_feature_name.to_lower

				if attached a_class.feature_named (l_feature_name) as l_selected_feature then
					Result.put (l_selected_feature)
				else
					-- log. Feature with NAME does not exist in class CLASS
				end
			else
				if a_class.has_feature_table then
					Result.merge (a_class.feature_table.features)
				else
					-- log. No feature table attached to class CLASS
				end
			end

				-- Filter and remove invalid features.
				-- E.g. necessary if `{EXT_CONFIG}.feature_name}' doesn't belong to `a_class'.
				-- E.g. necessary to remove inherited features that are not directly declared in `a_class'.
			from
				Result.start
			until
				Result.after
			loop
				if a_class.class_id /= Result.item_for_iteration.written_class.class_id then
					Result.remove
				else
					Result.forth
				end
			end
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

	feature_name_selector (a_tested_class: CLASS_C; a_feature_name: STRING): BOOLEAN
			-- Select class if it has a feature named `a_feature_name'.	
		local
			l_feature_name_in_lower: STRING
		do
			l_feature_name_in_lower := a_feature_name.twin
			l_feature_name_in_lower.to_lower

			Result := a_tested_class.feature_named (l_feature_name_in_lower) /= Void
		end

feature {NONE} -- Output

	basic_file_name (a_target_type: TYPE_A; a_origin: EXT_SNIPPET_ORIGIN): STRING
			-- Create a basic file name based on a snippet's origin and it's type.
		local
			l_target_name: STRING
		do
				-- Remove all whitespaces.
			l_target_name := a_target_type.name.twin
			l_target_name.replace_substring_all (" ", "")

			create Result.make_empty
			Result.append (a_origin.out)
			Result.append (a_origin.out_separator)
			Result.append (l_target_name)
		end

	write_snippets_to_file (a_snippets: LINKED_SET [EXT_SNIPPET]; a_basic_file_name: STRING; a_separator: STRING)
			-- Writes the snippets to a file if `{EXT_CONFIG}.output' path is configured.
			-- `a_file_name' is considered as a basic filename that still gets expanded by
			-- a postfix and a file extension.
		local
			l_file_name: STRING
			l_file_path: FILE_NAME
			l_snippet_writer: EXT_SNIPPET_WRITER
		do
			if attached config.output as l_path_name then
				across
					a_snippets as l_cursor
				loop
						-- Concatenate the file name.
					create l_file_name.make_from_string (a_basic_file_name)
					l_file_name.append (a_separator)
					l_file_name.append (once "targets")
					l_file_name.append (target_variable_list_as_string (l_cursor.item))
					snippet_id := snippet_id + 1
					l_file_name.append ("_" + snippet_id.out)

						-- Create whole path name.
					create l_file_path.make_from_string (l_path_name)
					l_file_path.set_file_name (l_file_name)

					if attached l_file_path.twin as l_bin_file_path then
						l_bin_file_path.add_extension ("BIN")

						create {EXT_BINARY_SNIPPET_WRITER} l_snippet_writer
						l_snippet_writer.write_to_file (l_cursor.item, l_bin_file_path)
					end

					debug
						if attached l_file_path.twin as l_txt_file_path then
							l_txt_file_path.add_extension ("TXT")

							create {EXT_TEXTUAL_SNIPPET_WRITER} l_snippet_writer
							l_snippet_writer.write_to_file (l_cursor.item, l_txt_file_path)
						end
					end
				end
			end
		end

	target_variable_list_as_string (a_snippet: EXT_SNIPPET): STRING
			-- Create a string representation of all target variable names.
			-- `Result' looks like "[var_1_name,var_2_name,...,var_n_name]"
		local
			l_variable_list: LINKED_LIST [STRING]
		do
			create Result.make_empty
			Result.append ("[")

			if attached a_snippet.variable_context.target_variables as l_variable_table then
				create l_variable_list.make
				l_variable_list.fill (l_variable_table.current_keys)

				from
					l_variable_list.start
				until
					l_variable_list.after
				loop
					Result.append (l_variable_list.item)
					if not l_variable_list.islast then
						Result.append (",")
					end
					l_variable_list.forth
				end
			end

			Result.append ("]")
		end

feature{NONE} -- Implementation

	snippet_file: PLAIN_TEXT_FILE
			-- File used to log snippets

	log_snippet_in_file (a_snippets: LINKED_LIST [EXT_SNIPPET])
			-- Log `a_snippets' in specified file.
		local
			l_cursor: DS_HASH_TABLE [STRING, STRING]
			l_output: STRING
			l_printer: EXT_SNIPPET_ANNOTATION_PRINTER
			i: INTEGER
			c: INTEGER
		do
			create l_printer
			create l_output.make (2048)
			across a_snippets as l_snippet loop
				snippet_file.put_string ("%N---------------------------------------------------------------------------%N")
				across l_snippet.item.operands as l_opds loop
					l_output.append (l_opds.key)
					l_output.append_character (':')
					l_output.append_character (' ')
					l_output.append (output_type_name (l_opds.item))
					l_output.append_character ('%N')
				end
				l_output.append_character ('%N')
				l_printer.print_snippet (l_snippet.item)
				l_output.append (l_printer.last_output)
				l_output.append_character ('%N')
				c := l_snippet.item.fragments.count
				if c > 0 then
					i := 1
					across l_snippet.item.fragments as l_frags loop
						if i > 1 then
							l_output.append_character (',')
							l_output.append_character (' ')
						end
						l_output.append (l_frags.item.debug_output)
						i := i + 1
					end
				end
				snippet_file.put_string (l_output)
				snippet_file.flush
				l_output.wipe_out
			end
		end

	create_snippet_file
			-- Create `snippet_file'.
		do
			if snippet_file = Void then
				create snippet_file.make_create_read_write (config.snippet_log_file)
			end
		end

	close_snippet_file
			-- Close `snippet_file'.
		do
			if snippet_file /= Void and then snippet_file.is_open_write then
				snippet_file.close
			end
		end

	extract_contracts (a_snippets: LINKED_LIST [EXT_SNIPPET])
			-- Extract contracts of callees in `a_snippets' as annotations,
			-- and add those annotations into `a_snippets'.
		local
			l_contract_extractor: EXT_CONTRACT_ANNOTATION_EXTRACTOR
		do
			create l_contract_extractor
			across a_snippets as l_snips loop
				l_contract_extractor.extract_from_snippet (l_snips.item)
				l_contract_extractor.last_annotations.do_all (agent (l_snips.item.annotations).extend)
			end
		end

	extract_fragments (a_snippets: LINKED_LIST [EXT_SNIPPET]; a_extractor: EXT_SNIPPET_EXTRACTOR)
			-- Extract fragments in `a_snippets',
			-- and add those fragments into `a_snippets'.
		local
			l_extractor: EXT_FRAGMENT_EXTRACTOR
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_extractor
				across a_snippets as l_snips loop
					l_extractor.extract (l_snips.item)
					l_snips.item.fragments.append (l_extractor.last_fragments)
				end
			end
		rescue
			if not a_snippets.is_empty then
				log.put_string ("Fragment extraction crash: " + a_snippets.first.source.out + "%N")
			end
			l_retried := True
			retry
		end

	snippet_id: INTEGER
			-- Next snippet id

end
