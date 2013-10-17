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

feature -- Status report

	is_last_removal_successful: BOOLEAN
			-- Is last removal successful?

	remove_contracts_of_features (a_features: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN])
		local
			l_class_texts: DS_HASH_TABLE [STRING, STRING]
		do
			reset
			initialize_features_with_declarations (a_features)
			l_class_texts := class_texts_with_feature_contracts_removed
			save_class_texts (l_class_texts)
		end

feature -- Access

	features_with_declarations: DS_HASH_TABLE [DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN], CLASS_C]
		do
			if features_with_declarations_cache = Void then
				create features_with_declarations_cache.make_equal (10)
			end
			Result := features_with_declarations_cache
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
				create l_class_file.make_with_path (l_class_file_path)
				l_class_file.open_write
				l_class_file.put_string (l_class_text)
				l_class_file.close

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
			l_asts_to_set_true: DS_ARRAYED_LIST [AST_EIFFEL]
			l_ast_cursor: DS_ARRAYED_LIST_CURSOR [AST_EIFFEL]
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

--	class_text_with_feature_contracts_set_true (a_class: CLASS_C; a_ast_list: DS_ARRAYED_LIST[AST_EIFFEL]): STRING
--			--
--		require
--		local
--			l_match_list: LEAF_AS_LIST
--			l_class_text: STRING
--			l_path: PATH
--			l_dir: DIRECTORY
--			l_class_file_path: PATH
--			l_class_file: PLAIN_TEXT_FILE
--		do
--				-- Generate text for the new class.

--			from a_ast_list.start
--			until a_ast_list.after
--			loop
--				a_ast_list.item_for_iteration.replace_text ("True", l_match_list)
--				a_ast_list.forth
--			end
--			l_class_text := a_class.ast.text (l_match_list).twin
--		end


	contract_asts_from_feature (a_feature: FEATURE_I; a_change_type: BOOLEAN): DS_ARRAYED_LIST [AST_EIFFEL]
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
					Result.force_last (l_rout.precondition.assertions)
				end
				if not a_change_type and then l_rout.postcondition /= Void and then l_rout.postcondition.assertions /= Void then
					Result.force_last (l_rout.postcondition.assertions)
				end
				collect_checks_from_feature (a_feature)
				Result.extend_last (check_lists)
			end
		end

feature -- Collect check assertions

	check_lists: DS_ARRAYED_LIST [EIFFEL_LIST [TAGGED_AS]]

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
			check_lists.force_last (l_as.check_list)
		end

	reset
			--
		do
			features_with_declarations_cache := Void
		end

	features_with_declarations_cache: like features_with_declarations

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
--							l_precursors.force (create {EPA_FEATURE_WITH_CONTEXT_CLASS}.make (lt_feat, l_class))
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

feature -- Command

--feature -- Command

--	remove_contracts (a_class: CLASS_C; a_feature: FEATURE_I)
--			-- Remove the contracts from `a_class'.`a_feature'.
--		require
--			class_attached: a_class /= Void
--			feature_attached: a_feature /= Void
--		local
--		do
--			context_class := a_class
--			subject_feature := a_feature
--			is_last_removal_successful := True

--			remove_contracts_internal
--		end

--	remove_contracts_by_name (a_class_name, a_feature_name: STRING)
--			-- Remove the contracts from the feature with the name `a_class_name'.`a_feature_name'.
--		require
--			class_name_not_empty: a_class_name /= Void and then not a_class_name.is_empty
--			feature_name_not_empty: a_feature_name /= Void and then not a_feature_name.is_empty
--		local
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--		do
--			l_class := first_class_starts_with_name (a_class_name.as_upper)
--			if l_class /= Void then
--				l_feature := l_class.feature_named (a_feature_name)
--			end

--			if l_feature /= Void then
--				remove_contracts (l_class, l_feature)
--			else
--				is_last_removal_successful := False
--			end
--		end

--feature{NONE} -- Access

--	context_class: CLASS_C
--			-- Context class of the feature to operate on.

--	subject_feature: FEATURE_I
--			-- Feature to remove contracts from.

--	remove_contracts_internal
--			-- Remove contracts from `subject_feature'.
--		local
--			l_classes: ARRAYED_LIST [CLASS_C]
--			l_precursors: DS_ARRAYED_LIST [FEATURE_I]
--			l_class: CLASS_C
--			l_feature: FEATURE_I

--			l_asts_to_set_true: DS_HASH_TABLE [DS_ARRAYED_LIST[AST_EIFFEL], CLASS_C]
--					-- List of AST nodes to be set True to remove the contracts.
--					-- Key: classes to set
--					-- Val: list of AST nodes to set in the key class
--			l_ast_list: DS_ARRAYED_LIST[AST_EIFFEL]
--		do
--				-- All classes of `context_class' that has redefined `subject_feature'.
--			create l_classes.make (10)
--			if attached subject_feature.e_feature.precursors as lt_supers then
--				l_classes.append (lt_supers)
--			end
--			l_classes.extend (subject_feature.written_class)

--				-- All (re)definitions of `subject_feature'.
--			create l_precursors.make (l_classes.count + 1)
--			across l_classes as lt_class_cursor loop
--				if attached lt_class_cursor.item.feature_of_rout_id_set (subject_feature.rout_id_set) as lt_feat then
--					l_precursors.force_last (lt_feat)
--				end
--			end

--				-- All AST nodes from (re)definitions that need to be set True
--			from
--				create l_asts_to_set_true.make_equal (20)
--				l_precursors.start
--			until
--				l_precursors.after
--			loop
--				l_feature := l_precursors.item_for_iteration

--				l_asts_to_set_true.force (contract_asts_from_feature (l_feature), l_feature.written_class)

--				l_precursors.forth
--			end

--				-- Set the contracts to True and generate OVERRIDE classes
--			from
--				l_asts_to_set_true.start
--			until
--				l_asts_to_set_true.after
--			loop
--				l_class := l_asts_to_set_true.key_for_iteration
--				l_ast_list := l_asts_to_set_true.item_for_iteration

--				generate_override_class (l_class, l_ast_list)

--				l_asts_to_set_true.forth
--			end
--		end

--	generate_override_class (a_class: CLASS_C; a_ast_list: DS_ARRAYED_LIST[AST_EIFFEL])
--			-- Generate a class into the override cluster of the working project.
--			-- The new class file is the same as the old one, except all ast nodes in `a_ast_list' are replaced with `True'.
--		require
--		local
--			l_match_list: LEAF_AS_LIST
--			l_class_text: STRING
--			l_path: PATH
--			l_dir: DIRECTORY
--			l_class_file_path: PATH
--			l_class_file: PLAIN_TEXT_FILE
--		do
--				-- Generate text for the new class.
--			l_match_list := Match_list_server.item (a_class.class_id)
--			from a_ast_list.start
--			until a_ast_list.after
--			loop
--				a_ast_list.item_for_iteration.replace_text ("True", l_match_list)
--				a_ast_list.forth
--			end
--			l_class_text := a_class.ast.text (l_match_list).twin

--				-- Store the new class file into OVERRIDE cluster.
--			l_path := system.eiffel_project.project_directory.path.extended ("override")
--			create l_dir.make_with_path (l_path)
--			if not l_dir.exists then
--				l_dir.recursive_create_dir
--			end
--			l_class_file_path := l_path.extended (a_class.name.as_lower + ".e")
--			create l_class_file.make_with_path (l_class_file_path)
--			l_class_file.open_write
--			l_class_file.put_string (l_class_text)
--			l_class_file.close
--		end

--	contract_asts_from_feature (a_feature: FEATURE_I): DS_ARRAYED_LIST [AST_EIFFEL]
--			-- List of AST nodes from the text of `a_feature' that are contract clauses.
--			--
--			-- At most one node for "require/require else", one node for "ensure/ensure then",
--			--		and one node for each check instruction.
--		require
--			feature_attached: a_feature /= Void
--		local
--		do
--			create Result.make (4)
--			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
--				if l_rout.precondition /= Void and then l_rout.precondition.assertions /= Void then
--					Result.force_last (l_rout.precondition.assertions)
--				end
--				if l_rout.postcondition /= Void and then l_rout.postcondition.assertions /= Void then
--					Result.force_last (l_rout.postcondition.assertions)
--				end
--				collect_checks_from_feature (a_feature)
--				Result.extend_last (check_lists)
--			end
--		end

--feature -- Collect check assertions

--	check_lists: DS_ARRAYED_LIST [EIFFEL_LIST [TAGGED_AS]]

--	collect_checks_from_feature (a_feature: FEATURE_I)
--			-- Collect assertion clauses in CHECK instructions from `a_feature'.
--			-- Make result available in `check_lists'.
--		require
--			feature_attached: a_feature /= Void
--		local
--		do
--			create check_lists.make (10)
--			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
--				l_rout.process (Current)
--			end
--		end

--	process_check_as (l_as: CHECK_AS)
--			-- <Precursor>
--		do
--			check_lists.force_last (l_as.check_list)
--		end

end
