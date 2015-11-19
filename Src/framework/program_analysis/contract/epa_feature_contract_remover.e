note
	description: "Summary description for {EPA_FEATURE_CONTRACT_REMOVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CONTRACT_REMOVER

inherit
	AST_ITERATOR
		redefine
			process_check_as
		end

	SHARED_SERVER

	EPA_UTILITY

feature -- Basic operation

	remove_contracts_of_features (a_features: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN])
		local
			l_class_texts: DS_HASH_TABLE [STRING, STRING]
		do
			reset
			initialize_features_with_declarations (a_features)
			l_class_texts := class_texts_with_feature_contracts_removed
			save_class_texts (l_class_texts)
		end

	undo_last_removal
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
			l_file: PLAIN_TEXT_FILE
		do
			if last_generated_new_class_paths /= Void and then not last_generated_new_class_paths.is_empty then
				from
					l_cursor := last_generated_new_class_paths.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					create l_file.make_with_path (l_cursor.item)
					if l_file.exists then
						l_file.delete
					end
					l_cursor.forth
				end

				last_generated_new_class_paths := Void
			end
		end

feature -- Status report

	is_last_removal_successful: BOOLEAN
			-- Is last removal successful?

feature{NONE} -- Access

	last_generated_new_class_paths: DS_ARRAYED_LIST [PATH]

	features_with_declarations: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN], CLASS_C]
			-- Features whose contracts are to be removed.
			--
			-- Key: class
			-- Sub-key: True for precondition and False for postcondition
			-- Val: set of features whose contracts to be removed
		do
			if features_with_declarations_cache = Void then
				create features_with_declarations_cache.make_equal (10)
			end
			Result := features_with_declarations_cache
		end

feature{NONE} -- Implementation

	reset
			-- Reset the remover.
		do
			features_with_declarations_cache := Void
		end

	initialize_features_with_declarations (a_features: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN])
		local
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
			l_change_type: BOOLEAN
			l_features: DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS]
			l_features_with_declarations: like features_with_declarations
			l_feature_cursor: DS_HASH_SET_CURSOR [EPA_FEATURE_WITH_CONTEXT_CLASS]
			l_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_classes_with_feature_declarations: DS_ARRAYED_LIST [CLASS_C]
			l_precursors: DS_HASH_SET [FEATURE_I]
			l_class_cursor: DS_ARRAYED_LIST_CURSOR [CLASS_C]
			l_class: CLASS_C
			l_features_by_change_type: DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN]
		do
			l_features_with_declarations := features_with_declarations

			from
				l_table_cursor := a_features.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_change_type := l_table_cursor.key
				l_features := l_table_cursor.item

				from
					l_feature_cursor := l_features.new_cursor
					l_feature_cursor.start
				until
					l_feature_cursor.after
				loop
					l_feature := l_feature_cursor.item
						-- All classes where `l_feature' is (re)defined.
					create l_classes_with_feature_declarations.make_equal (10)
					if attached l_feature.feature_.e_feature.precursors as lt_supers then
						lt_supers.do_all (agent l_classes_with_feature_declarations.force_last)
					end
					l_classes_with_feature_declarations.force_last (l_feature.written_class)

						-- All (re)definitions of `l_feature'.
					from
						l_class_cursor := l_classes_with_feature_declarations.new_cursor
						l_class_cursor.start
					until
						l_class_cursor.after
					loop
						l_class := l_class_cursor.item
						create l_precursors.make_equal (l_classes_with_feature_declarations.count + 1)
						if attached l_class.feature_of_rout_id_set (l_feature.feature_.rout_id_set) as lt_feat then
							l_precursors.force (lt_feat)
						end

						if not l_precursors.is_empty then
							if l_features_with_declarations.has (l_class) then
								if l_features_with_declarations.item (l_class).has (l_change_type) then
									l_features_with_declarations.item (l_class).item (l_change_type).merge (l_precursors)
								else
									l_features_with_declarations.item (l_class).force (l_precursors, l_change_type)
								end
							else
								create l_features_by_change_type.make_equal (2)
								l_features_by_change_type.force (l_precursors, l_change_type)
								l_features_with_declarations.force (l_features_by_change_type, l_class)
							end
						end
						l_class_cursor.forth
					end

					l_feature_cursor.forth
				end

				l_table_cursor.forth
			end

		end

	class_texts_with_feature_contracts_removed: DS_HASH_TABLE [STRING, STRING]
			--
		local
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN], CLASS_C]
			l_change_type: BOOLEAN
			l_table_for_class: DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN]
			l_table_for_class_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [FEATURE_I], BOOLEAN]

			l_class: CLASS_C
			l_class_file_name, l_class_text: STRING
			l_features: DS_HASH_SET [FEATURE_I]
			l_feature_cursor: DS_HASH_SET_CURSOR [FEATURE_I]
			l_feature: FEATURE_I
			l_asts_to_set_true: DS_ARRAYED_LIST [TAGGED_AS]
			l_ast_cursor: DS_ARRAYED_LIST_CURSOR [TAGGED_AS]
			l_match_list: LEAF_AS_LIST
		do
			create Result.make_equal (10)
			from
				l_table_cursor := features_with_declarations.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_class := l_table_cursor.key
				l_class_file_name := l_class.name_in_upper.as_lower
				l_table_for_class := l_table_cursor.item

				create l_class_text.make (4096)
				create l_asts_to_set_true.make_equal (10)

				from
					l_table_for_class_cursor := l_table_for_class.new_cursor
					l_table_for_class_cursor.start
				until
					l_table_for_class_cursor.after
				loop
					l_change_type := l_table_for_class_cursor.key
					l_features := l_table_for_class_cursor.item

						-- All asts to set true in `l_class'.
					from
						l_feature_cursor := l_features.new_cursor
						l_feature_cursor.start
					until
						l_feature_cursor.after
					loop
						l_feature := l_feature_cursor.item
						l_asts_to_set_true.append_last (contract_asts_from_feature (l_feature, l_change_type))

						l_feature_cursor.forth
					end

					l_table_for_class_cursor.forth
				end

				l_match_list := Match_list_server.item (l_class.class_id)
				from
					l_ast_cursor := l_asts_to_set_true.new_cursor
					l_ast_cursor.start
				until
					l_ast_cursor.after
				loop
					l_ast_cursor.item.replace_text ("True", l_match_list)
					l_ast_cursor.forth
				end
				Result.force (l_class.ast.text (l_match_list).twin, l_class_file_name)
				l_match_list.remove_modifications

				l_table_cursor.forth
			end
		end

	add_all_tagged_as (a_eiffel_list: EIFFEL_LIST [TAGGED_AS]; a_list_of_as: DS_ARRAYED_LIST [TAGGED_AS])
			--
		local
			l_cursor: INDEXABLE_ITERATION_CURSOR [TAGGED_AS]
		do
			from
				l_cursor := a_eiffel_list.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				a_list_of_as.force_last (l_cursor.item)
				l_cursor.forth
			end
		end

	contract_asts_from_feature (a_feature: FEATURE_I; a_change_type: BOOLEAN): DS_ARRAYED_LIST [TAGGED_AS]
			-- List of AST nodes from the text of `a_feature' that are contract clauses.
			--
			-- At most one node for "require/require else", one node for "ensure/ensure then",
			--		and one node for each check instruction.
		require
			feature_attached: a_feature /= Void
		local
		do
			create Result.make (4)
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if a_change_type and then l_rout.precondition /= Void and then l_rout.precondition.assertions /= Void then
					add_all_tagged_as (l_rout.precondition.assertions, Result)
				end
				if not a_change_type and then l_rout.postcondition /= Void and then l_rout.postcondition.assertions /= Void then
					add_all_tagged_as (l_rout.postcondition.assertions, Result)
				end
				collect_checks_from_feature (a_feature)
				Result.append_last (check_lists)
			end
		end

	save_class_texts (a_class_texts: DS_HASH_TABLE [STRING, STRING])
			--
		local
			l_path: PATH
			l_dir: DIRECTORY
			l_table_cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			l_class_file_name, l_class_text: STRING
			l_class_file_path: PATH
			l_class_file: PLAIN_TEXT_FILE
		do
			create last_generated_new_class_paths.make_equal (a_class_texts.count + 1)

				-- Store the new class file into OVERRIDE cluster.
			l_path := system.eiffel_project.project_directory.path.extended ("override")
			create l_dir.make_with_path (l_path)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end

			from
				l_table_cursor := a_class_texts.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_class_file_name := l_table_cursor.key
				l_class_text := l_table_cursor.item

				l_class_file_path := l_path.extended (l_class_file_name + ".e")
				last_generated_new_class_paths.force_last (l_class_file_path)
				create l_class_file.make_with_path (l_class_file_path)
				l_class_file.open_write
				l_class_file.put_string (l_class_text)
				l_class_file.close

				l_table_cursor.forth
			end
		end

feature{NONE} -- Collect check assertions

	check_lists: DS_ARRAYED_LIST [TAGGED_AS]

	collect_checks_from_feature (a_feature: FEATURE_I)
			-- Collect assertion clauses in CHECK instructions from `a_feature'.
			-- Make result available in `check_lists'.
		require
			feature_attached: a_feature /= Void
		local
		do
			create check_lists.make (10)
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				l_rout.process (Current)
			end
		end

	process_check_as (l_as: CHECK_AS)
			-- <Precursor>
		do
			add_all_tagged_as (l_as.check_list, check_lists)
		end

feature{NONE} -- Cache

	features_with_declarations_cache: like features_with_declarations

end
