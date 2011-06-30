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
				-- Evaluate type information given in `config'.		
			l_target_type := type_a_from_string (config.target_type, root_class_of_system)
			check attached l_target_type end

				-- Calling snippet extraction for selected features of each selected class.
			across select_classes_for_extraction as l_selected_classes loop
				across select_features_for_extraction (l_selected_classes.item) as l_feature_set_cursor loop
					process_feature (l_target_type, l_selected_classes.item, l_feature_set_cursor.item)
				end
			end
		end

feature {NONE} -- Implementation

	process_feature (a_target_type: TYPE_A; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Starts processing snippet extraction with relevant `a_target_type' on `a_class' with `a_feature'.
		local
			l_origin: STRING
			l_extractor: EXT_DEFERRED_SNIPPET_EXTRACTOR
		do
			l_origin := origin_as_string (a_target_type, a_class, a_feature)

				-- Start extraction.
			create {EXT_SNIPPET_EXTRACTOR} l_extractor.make
			l_extractor.extract_from_feature (a_target_type, a_feature, a_class, l_origin)

				-- Store snippets, if any where extracted.
			if attached l_extractor.last_snippets as l_snippets and then not l_snippets.is_empty then
				debug write_snippets_to_file (l_snippets, l_origin) end

				to_implement ("Store snippets in Object/Transition/Snippet database.")
				to_implement ("Store snippets in serialized XML format.")
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

	origin_as_string (a_target_type: TYPE_A; a_class: CLASS_C; a_feature: FEATURE_I): STRING
			-- Create a textual representation of the origin.
		do
			create Result.make_empty
			Result.append (a_target_type.name)
			Result.append ("@")
			Result.append (a_class.name)
			Result.append (".")
			Result.append (a_feature.feature_name)
		end

	write_snippets_to_file (a_snippets: LINKED_SET [EXT_SNIPPET]; a_basic_file_name: STRING)
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
					l_file_name.append (once "@targets")
					l_file_name.append (target_variable_list_as_string (l_cursor.item))

						-- Create whole path name.
					create l_file_path.make_from_string (l_path_name)
					l_file_path.set_file_name (l_file_name)

					if attached l_file_path.twin as l_bin_file_path then
						l_bin_file_path.add_extension ("BIN")

						create {EXT_BINARY_SNIPPET_WRITER} l_snippet_writer
						l_snippet_writer.write_to_file (l_cursor.item, l_bin_file_path)
					end

					if attached l_file_path.twin as l_txt_file_path then
						l_txt_file_path.add_extension ("TXT")

						create {EXT_TEXTUAL_SNIPPET_WRITER} l_snippet_writer
						l_snippet_writer.write_to_file (l_cursor.item, l_txt_file_path)
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

end
