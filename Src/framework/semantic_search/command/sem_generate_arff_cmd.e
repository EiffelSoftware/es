note
	description: "Class to generate ARFF files from ssql files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_GENERATE_ARFF_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	KL_SHARED_FILE_SYSTEM

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
				generate_arff_for_class (l_class, l_dir)
			end
		end

feature{NONE} -- Implementation

	generate_arff_for_class (a_class: CLASS_C; a_directory: STRING)
			-- Genearte ARFF files for `a_class' whose ARFF files are stored in directory `a_directory'.
		local
			l_features: LINKED_LIST [STRING]
			l_finder: EPA_FILE_SEARCHER
			l_directory: FILE_NAME
		do
			io.put_string ("Generate for " + a_class.name_in_upper + "%N")
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
				io.put_string ("%T" + l_feats.item + "%N")
				create l_directory.make_from_string (a_directory)
				l_directory.extend (l_feats.item)
				generate_arff_for_feature (a_class, a_class.feature_named (l_feats.item), l_directory)
			end
		end

	generate_arff_for_feature (a_class: CLASS_C; a_feature: FEATURE_I; a_directory: STRING)
			-- Generate ARFF files for `a_feature' from `a_class'.
			-- The ssql files for the feature is stored in `a_directory'.
		local
			l_finder: EPA_FILE_SEARCHER
			l_files: LINKED_LIST [STRING]
			l_arff_gen: SEM_ARFF_GENERATOR
			l_ssql_loader: SEMQ_QUERYABLE_LOADER
			l_path: FILE_NAME
			l_directory: FILE_NAME
		do
			create l_files.make
			create l_finder.make_with_pattern ("tran.+\.ssql$")
			l_finder.file_found_actions.extend (
				agent (a_path: STRING; a_name: STRING; a_result: LINKED_LIST [STRING])
					do
						a_result.extend (a_name)
					end (?, ?, l_files))
			l_finder.search (a_directory)

			create l_arff_gen.make_for_feature_transition
			across l_files as l_ssqls loop
				io.put_string ("%T" + l_ssqls.item + "%N")
				create l_path.make_from_string (a_directory)
				l_path.set_file_name (l_ssqls.item)
				create l_ssql_loader
				l_ssql_loader.load (l_path)
					-- If the file is corrupted, we ignore it.
				if l_ssql_loader.last_queryable /= Void then
					l_arff_gen.extend_queryable (l_ssql_loader.last_queryable, l_ssql_loader.last_meta)
				end
			end

				-- Generate ARFF files for `a_feature'.
			create l_directory.make_from_string (config.output)
			l_directory.extend (a_class.name_in_upper)
			l_directory.extend (a_feature.feature_name.as_lower)
			file_system.recursive_create_directory (l_directory)
			l_arff_gen.generate_files (a_class.name_in_upper + "__" + a_feature.feature_name.as_lower, l_directory)
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
