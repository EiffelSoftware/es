note
	description: "[
		Command to remove the contracts of a feature.

		By generating new class files for classes that (re)define the feature.
		All contracts in the original (re)definitions of the feature are replaced with `True'.
		The new class files are put in the override cluster.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_CONTRACT_REMOVER

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

	changed_classes: DS_ARRAYED_LIST [CLASS_C]

feature -- Command

	remove_contracts (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Remove the contracts from `a_class'.`a_feature'.
		require
			class_attached: a_class /= Void
			feature_attached: a_feature /= Void
		local
		do
			context_class := a_class
			subject_feature := a_feature
			is_last_removal_successful := True

			remove_contracts_internal
		end

	remove_contracts_by_name (a_class_name, a_feature_name: STRING)
			-- Remove the contracts from the feature with the name `a_class_name'.`a_feature_name'.
		require
			class_name_not_empty: a_class_name /= Void and then not a_class_name.is_empty
			feature_name_not_empty: a_feature_name /= Void and then not a_feature_name.is_empty
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := first_class_starts_with_name (a_class_name.as_upper)
			if l_class /= Void then
				l_feature := l_class.feature_named (a_feature_name)
			end

			if l_feature /= Void then
				remove_contracts (l_class, l_feature)
			else
				is_last_removal_successful := False
			end
		end

	recover_previous_contracts
			-- Recover the previously removed contracts by deleting the new class files.
		local
			l_path: PATH
			l_class_cursor: DS_ARRAYED_LIST_CURSOR [CLASS_C]
			l_class: CLASS_C
			l_changed_class_path: PATH
			l_changed_class_file: PLAIN_TEXT_FILE
		do
			l_path := system.eiffel_project.project_directory.path.extended ("override")
			if changed_classes /= Void and then not changed_classes.is_empty then
				from
					l_class_cursor := changed_classes.new_cursor
					l_class_cursor.start
				until
					l_class_cursor.after
				loop
					l_class := l_class_cursor.item
					l_changed_class_path := l_path.extended (l_class.name.as_lower + ".e")
					create l_changed_class_file.make_with_path (l_changed_class_path)
					if l_changed_class_file.exists then
						l_changed_class_file.delete
						l_class_cursor.remove
					else
						l_class_cursor.forth
					end
				end
			end
		end

feature{NONE} -- Access

	context_class: CLASS_C
			-- Context class of the feature to operate on.

	subject_feature: FEATURE_I
			-- Feature to remove contracts from.

	remove_contracts_internal
			-- Remove contracts from `subject_feature'.
		local
			l_classes: ARRAYED_LIST [CLASS_C]
			l_precursors: DS_ARRAYED_LIST [FEATURE_I]
			l_class: CLASS_C
			l_feature: FEATURE_I

			l_asts_to_set_true: DS_HASH_TABLE [DS_ARRAYED_LIST[AST_EIFFEL], CLASS_C]
					-- List of AST nodes to be set True to remove the contracts.
					-- Key: classes to set
					-- Val: list of AST nodes to set in the key class
			l_ast_list: DS_ARRAYED_LIST[AST_EIFFEL]
		do
				-- All super classes of `context_class' that has redefined `subject_feature'.
			create l_classes.make (10)
			if attached subject_feature.e_feature.precursors as lt_supers then
				l_classes.append (lt_supers)
			end
			l_classes.extend (subject_feature.written_class)

				-- Classes that are affected by contract removal
			create changed_classes.make_equal (l_classes.count + 1)

				-- All (re)definitions of `subject_feature'.
			create l_precursors.make (l_classes.count + 1)
			across l_classes as lt_class_cursor loop
				if attached lt_class_cursor.item.feature_of_rout_id_set (subject_feature.rout_id_set) as lt_feat then
					l_precursors.force_last (lt_feat)
				end
			end

				-- All AST nodes from (re)definitions that need to be set True
			from
				create l_asts_to_set_true.make_equal (20)
				l_precursors.start
			until
				l_precursors.after
			loop
				l_feature := l_precursors.item_for_iteration

				l_asts_to_set_true.force (contract_asts_from_feature (l_feature), l_feature.written_class)

				l_precursors.forth
			end

				-- Set the contracts to True and generate OVERRIDE classes
			from
				l_asts_to_set_true.start
			until
				l_asts_to_set_true.after
			loop
				l_class := l_asts_to_set_true.key_for_iteration
				l_ast_list := l_asts_to_set_true.item_for_iteration

				generate_override_class (l_class, l_ast_list)

				l_asts_to_set_true.forth
			end
		end

	generate_override_class (a_class: CLASS_C; a_ast_list: DS_ARRAYED_LIST[AST_EIFFEL])
			-- Generate a class into the override cluster of the working project.
			-- The new class file is the same as the old one, except all ast nodes in `a_ast_list' are replaced with `True'.
		require
		local
			l_match_list: LEAF_AS_LIST
			l_class_text: STRING
			l_path: PATH
			l_dir: DIRECTORY
			l_class_file_path: PATH
			l_class_file: PLAIN_TEXT_FILE
		do
				-- Generate text for the new class.
			l_match_list := Match_list_server.item (a_class.class_id)
			from a_ast_list.start
			until a_ast_list.after
			loop
				a_ast_list.item_for_iteration.replace_text ("True", l_match_list)
				a_ast_list.forth
			end
			l_class_text := a_class.ast.text (l_match_list).twin

				-- Store the new class file into OVERRIDE cluster.
			l_path := system.eiffel_project.project_directory.path.extended ("override")
			create l_dir.make_with_path (l_path)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end
			l_class_file_path := l_path.extended (a_class.name.as_lower + ".e")
			create l_class_file.make_with_path (l_class_file_path)
			l_class_file.open_write
			l_class_file.put_string (l_class_text)
			l_class_file.close

			changed_classes.force_last (a_class)
		end

	contract_asts_from_feature (a_feature: FEATURE_I): DS_ARRAYED_LIST [AST_EIFFEL]
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
				if l_rout.precondition /= Void and then l_rout.precondition.assertions /= Void then
					Result.force_last (l_rout.precondition.assertions)
				end
				if l_rout.postcondition /= Void and then l_rout.postcondition.assertions /= Void then
					Result.force_last (l_rout.postcondition.assertions)
				end
				collect_checks_from_feature (a_feature)
				Result.append_last (check_lists)
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

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
