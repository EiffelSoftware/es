note
	description: "Class to generate invariants using Daikon from ARFF files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_GENERATE_DAIKON_INVARIANT_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	KL_SHARED_FILE_SYSTEM

	DKN_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature -- Basic operations

	execute
			-- Execute current command
		local
			l_class_names: LINKED_LIST [STRING]
			l_class: CLASS_C
			l_dir: FILE_NAME
		do
				-- Find classes whose ARFF files need to be generated.
			if config.class_name /= Void then
				create l_class_names.make
				l_class_names.extend (config.class_name.as_upper)
			else
				l_class_names := classes_in_directory (config.input, "([A-Z]|[0-9]|_)+")
			end

				-- Iterate through all found classes and generate ARFF files for them.
			across l_class_names as l_names loop
				l_class := first_class_starts_with_name (l_names.item)
				create l_dir.make_from_string (config.input)
				l_dir.extend (l_names.item)
				generate_invariants_for_class (l_class, l_dir)
			end
		end

feature{NONE} -- Implementation

	generate_invariants_for_class (a_class: CLASS_C; a_directory: STRING)
			-- Genearte invariants for `a_class' whose ARFF files are stored in directory `a_directory'.
		local
			l_features: LINKED_LIST [STRING]
			l_finder: EPA_FILE_SEARCHER
			l_directory: FILE_NAME
		do
			create l_features.make
			if config.feature_name /= Void then
				l_features.extend (config.feature_name.as_lower)
			else
					-- Find all features in `a_directory'.
				create l_finder.make_with_pattern ("([A-Z]|[a-z]|[0-9]|_)+")
				l_finder.set_is_dir_matched (True)
				l_finder.file_found_actions.extend (
				agent (a_path: STRING; a_name: STRING; a_result: LINKED_LIST [STRING])
					do
						a_result.extend (a_name)
					end (?, ?, l_features))
				l_finder.search (a_directory)

					-- Remove features that are not considered,
					-- according to specified feature kinds in `config'.
				from
					l_features.start
				until
					l_features.after
				loop
					if is_feature_considered (a_class, l_features.item) then
						l_features.forth
					else
						l_features.remove
					end
				end
			end

				-- Iterate through all features and generate ARFF files
				-- for them one by one.
			across l_features as l_feats loop
				create l_directory.make_from_string (a_directory)
				l_directory.extend (l_feats.item)
				generate_invariants_for_feature (a_class, a_class.feature_named (l_feats.item), l_directory)
			end
		end

	generate_invariants_for_feature (a_class: CLASS_C; a_feature: FEATURE_I; a_directory: STRING)
			-- Generate invariant files for `a_feature' from `a_class'.
			-- The ARFF files for the feature is stored in `a_directory'.
		local
			l_finder: EPA_FILE_SEARCHER
			l_files: LINKED_LIST [STRING]
			l_path: FILE_NAME
			l_directory: FILE_NAME
			l_relation_loader: WEKA_ARFF_RELATION_LOADER
			l_inv_path: FILE_NAME
			l_name_part: STRING
			l_invariants: like invariants_from_arff_relation
			l_file: PLAIN_TEXT_FILE
			l_invs: DS_ARRAYED_LIST [STRING]
			l_sorter: DS_QUICK_SORTER [STRING]
		do
			create l_files.make
			create l_finder.make_with_pattern (".+\.arff$")
			l_finder.file_found_actions.extend (
				agent (a_path: STRING; a_name: STRING; a_result: LINKED_LIST [STRING])
					do
						a_result.extend (a_name)
					end (?, ?, l_files))
			l_finder.search (a_directory)

			across l_files as l_arffs loop
					-- Load Weka relation from an ARFF file.
				create l_path.make_from_string (a_directory)
				l_path.set_file_name (l_arffs.item)
				create l_relation_loader
				l_relation_loader.load_relation (l_path)

					-- Generate invariants using Daikon.
				l_invariants := invariants_from_arff_relation (l_relation_loader.last_relation)

					-- Store generated invariants in file.
				create l_directory.make_from_string (config.output)
				l_directory.extend (a_class.name_in_upper)
				l_directory.extend (a_feature.feature_name.as_lower)
				file_system.recursive_create_directory (l_directory)

				create l_inv_path.make_from_string (l_directory)
				l_name_part := l_arffs.item.twin
				l_name_part.remove_tail (5)
				l_inv_path.set_file_name (l_name_part + ".inv")

				create l_file.make_create_read_write (l_inv_path)
				from
					l_invariants.start
				until
					l_invariants.after
				loop
					fixme ("We only output preconditions for the moment. Jasonw 25.01.2011")
					if l_invariants.key_for_iteration.name.has_substring ("ppt1") then
						create l_invs.make (l_invariants.item_for_iteration.count)
						from
							l_invariants.item_for_iteration.start
						until
							l_invariants.item_for_iteration.after
						loop
							l_invs.force_last (decoded_daikon_name (l_invariants.item_for_iteration.item_for_iteration.debug_output))
							l_invariants.item_for_iteration.forth
						end
						create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (
							agent (a, b: STRING): BOOLEAN
								do
									Result := a < b
								end))
						l_sorter.sort (l_invs)
						from
							l_invs.start
						until
							l_invs.after
						loop
							l_file.put_string (l_invs.item_for_iteration)
							l_file.put_character ('%N')
							l_invs.forth
						end
					end
					l_invariants.forth
					l_file.put_string ("%N")
				end
				l_file.close
			end
		end

	invariants_from_arff_relation (a_relation: WEKA_ARFF_RELATION): DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			-- Invariants generalized from data in `a_relation'
		local
			l_daikon_gen: SEM_ARFF_TO_DAIKON_GENERATOR
			l_daikon_command: STRING
			l_decls_file: STRING
			l_trace_file: STRING
		do
			l_daikon_command := "/usr/bin/java daikon.Daikon"
			create l_daikon_gen.make
			l_daikon_gen.set_is_missing_value_included (True)
			l_daikon_gen.generate (a_relation)
			Result := invariants_from_daikon (l_daikon_command, l_daikon_gen.last_declaration, l_daikon_gen.last_trace)
		end

	is_feature_considered (a_class: CLASS_C; a_feature_name: STRING): BOOLEAN
			-- Should feature named `a_feature_name' from `a_class' be considered
			-- for ARFF generation?
		local
			l_feat_kinds: DS_HASH_SET [STRING]
			l_feat: FEATURE_I
		do
			l_feat := a_class.feature_named (a_feature_name)
			l_feat_kinds := config.feature_kinds

				-- Handle all feature kind.
			if l_feat_kinds.has ({SEM_CONFIG}.all_feature_kind) then
				Result := True
			end

				-- Handle commands.
			if not Result then
				if l_feat_kinds.has ({SEM_CONFIG}.command_feature_kind) and then not l_feat.has_return_value then
					Result := True
				end
			end

				-- Handle queries.
			if not Result then
				if l_feat_kinds.has ({SEM_CONFIG}.query_feature_kind) and then l_feat.has_return_value then
					Result := True
				end
			end

				-- Handle attributes.
			if not Result then
				if l_feat_kinds.has ({SEM_CONFIG}.attribute_feature_kind) and then l_feat.has_return_value and then l_feat.is_attribute then
					Result := True
				end
			end

				-- Handle functions.
			if not Result then
				if l_feat_kinds.has ({SEM_CONFIG}.function_feature_kind) and then l_feat.has_return_value and then l_feat.is_function then
					Result := True
				end
			end
		end

	classes_in_directory (a_directory: STRING; a_pattern: STRING): LINKED_LIST [STRING]
			-- Classes in `a_directory'
			-- `a_pattern' is the regular expression to specify the classes to be found.
		local
			l_dir: DIRECTORY
			l_finder: EPA_FILE_SEARCHER
		do
			create Result.make
			create l_finder.make_with_pattern (a_pattern)
			l_finder.set_is_dir_matched (True)
			l_finder.set_is_search_recursive (False)
			l_finder.file_found_actions.extend (
				agent (a_path: STRING; a_name: STRING; a_result: LINKED_LIST [STRING])
					do
						a_result.extend (a_name)
					end (?, ?, Result))
			l_finder.search (a_directory)
		end

end
