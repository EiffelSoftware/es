indexing
	description: "Object that does the settings fro AUTO_TEST_PROJECT.%
		%Partially generated with EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_SETTINGS_DIALOG

inherit
	AT_SETTINGS_DIALOG_IMP

	-- needed for correct output path check
	EXCEPTIONS
		rename
			raise as raise_exception
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_GRAPHICAL_ERROR_MANAGER
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_SHARED_WINDOW_MANAGER
		export
			{NONE} all
		undefine
			default_create, copy
		end
	-- end needed for correct output path check

	-- needed for ace and project path
	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		undefine
			default_create, copy
		end
	-- end needed for ace and project path

	-- needed for correct output path check
	COMMAND_EXECUTOR
		rename
			execute as launch_ebench
		export
			{NONE} all
		undefine
			default_create, copy
		end

	SYSTEM_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EIFFEL_ENV
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_FILE_DIALOG_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	ISE_DIRECTORY_UTILITIES
		rename
			raise as raise_exception,
			make_for_test as make_for_dir_test
		export
			{NONE} all
		undefine
			default_create, copy
		end
	-- end needed for correct output path check

	SHARED_AUTO_TEST_PROJECT
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make_default


feature {NONE} -- Initialization

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			set_default_push_button (button_start)
			set_default_cancel_button (button_cancel)
			button_cancel.select_actions.extend (agent destroy)
			button_add.select_actions.extend (agent add_to_test)
			button_remove.select_actions.extend (agent remove_from_test)

			set_icon_pixmap ((create {AT_SHARED_PIXMAPS}).icon_auto_test_window)

			-- initialize the class trees
			create all_classes_container.make
			create test_classes_container.make
			vb_all_classes.extend (all_classes_container)
			vb_test_classes.extend (test_classes_container)

			-- initialize the stored settings
			init_settings
		end

	make_default (a_target: EB_DEVELOPMENT_WINDOW) is
			-- Show `Current'.
		do
			target := a_target
			make_with_title ("AutoTest Settings")
		ensure
			target_is_set: target /= Void
		end


feature -- Basic Operations

	call_default is
			-- default content initialization
		do
			--initializing the content of the dialog window
			show_modal_to_window (target.window)
		end


feature {NONE} -- Comparison

	is_less_than_tree_node (one, other: EV_TREE_NODE): BOOLEAN is
			-- returns true if `one' is less than `other' in `text'
		require
			one_not_void: one /= Void
			other_not_void: other /= Void
		local
			ct_one, ct_other: EB_CLASSES_TREE_CLASS_ITEM
		do
			ct_one ?= one; ct_other ?= other
			if ct_one /= Void and then ct_other /= Void then
				Result := ct_one.data.name.is_equal (ct_other.data.name)
			else
				Result := one.text < other.text
			end
		ensure
			one_less_than_other: Result implies one.text < other.text
		end

	is_equal_tree_node (one, other: EV_TREE_NODE): BOOLEAN is
			-- returns true if `one' is equal to `other' in `text'
		require
			one_not_void: one /= Void
			other_not_void: other /= Void
		local
			ct_one, ct_other: EB_CLASSES_TREE_CLASS_ITEM
		do
			ct_one ?= one; ct_other ?= other
			if ct_one /= Void and then ct_other /= Void then
				Result := ct_one.data.name.is_equal (ct_other.data.name)
			else
				Result := one.text.is_equal (other.text)
			end
		ensure
			one_equal_to_other: Result implies one.text.is_equal (other.text)
		end


feature {NONE} -- Implementation

	store is
			-- `start' and `apply' save the changes made in the `dialog'
		local
			ace_file: PLAIN_TEXT_FILE
			ace_fn: FILE_NAME
			fn: STRING
			start_index_of_ext: INTEGER
			directory_name: DIRECTORY_NAME
			directory: DIRECTORY
			wd: EV_WARNING_DIALOG
		do
			-- set the path of the ace file
			-- IMPORTANT: it needs to have the same name as the acex or ecf file
			-- but with the extension changed to "ace"
			create fn.make_from_string (eiffel_ace.file_name)
			create ace_fn.make_from_string (fn)
			start_index_of_ext := fn.last_index_of ('.', fn.count)
			if not fn.substring (start_index_of_ext+1, fn.count).is_equal (ace_file_extension) then
				ace_fn.make_from_string (fn.substring (1, start_index_of_ext-1))
				ace_fn.add_extension (ace_file_extension)
			end
			create ace_file.make (ace_fn.string)
			if ace_file.exists then
				pref_data.set_ace_file (ace_file.name)
			else
				pref_data.set_ace_file ("File does not exist: " + ace_file.name)
			end

			-- don't `set_auto_test_version' it is already set from `init_settings'
			pref_data.set_auto_testing (not chk_disable_auto.is_selected)
			pref_data.set_classes_to_test (classes_to_store)
			-- option `define' of AutoTest has not yet been implemented
--			pref_data.set_define (a_bool: BOOLEAN)
			pref_data.set_just_test (chk_just_test.is_selected)
			pref_data.set_manual_testing (not chk_disable_manual.is_selected)
			pref_data.set_minimize (not chk_disable_minimize.is_selected)

			if not txt_output_path.text.is_empty then
				directory_name := validate_directory_name (txt_output_path.text)
				if directory_name /= Void then
					pref_data.set_output_directory (directory_name)
				end
			else
				pref_data.set_output_directory ("")
			end


			if not txt_ise_eiffel_path.text.is_empty then
				directory_name := validate_directory_name (txt_ise_eiffel_path.text)
				if directory_name /= Void then
					create directory.make (directory_name)
					if directory.exists then
						pref_data.set_ise_eiffel_path (directory_name)
					else
						create wd.make_with_text ("EiffelStudio Directory: '" + txt_ise_eiffel_path.text + "' does not exist!")
						wd.show_modal_to_window (Current)
					end
				else
					create wd.make_with_text ("EiffelStudio Directory: '" + txt_ise_eiffel_path.text + "' is not a valid directory name!")
					wd.show_modal_to_window (Current)
				end
			else
				pref_data.set_ise_eiffel_path ("")
			end

			pref_data.set_project_name (eiffel_system.name)
			pref_data.set_time_out (sb_time_out.value)
			pref_data.set_verbose (chk_verbose.is_selected)

			-- write the preferences to disk
			prefs.save_preferences
		end

	init_options is
			-- method to restore the last stored option settings
		local
			i: INTEGER
			version: STRING
			directory_name: DIRECTORY_NAME
		do
			-- is always read from the project, so no need to put it into the GUI
			-- has to be the same as eiffel_ace.file_name but with extension "ace"
--			pref_data.ace_file

			-- prepare display of `version'
			i := pref_data.auto_test_version.count
			version := project.auto_test_version
			-- store `version' only if there is none stored yet and if there was no error
			if pref_data.auto_test_version.index_of ('[', 1) = 1 and then pref_data.auto_test_version.index_of (']', i) = i then
				if version.index_of ('[', 1) /= 1 and then version.index_of (']', version.count) /= version.count then
					pref_data.set_auto_test_version (version)
				end
			end
			-- display `version' of `AutoTest'
			lbl_version.set_text ("AutoTest Version " + version)

			if not pref_data.auto_testing then
				chk_disable_auto.enable_select
			else
				chk_disable_auto.disable_select
			end

			-- | TODO: Find out how --define=<...> works and what it should store
--			pref_data.define

			if pref_data.just_test then
				chk_just_test.enable_select
			else
				chk_just_test.disable_select
			end

			if not pref_data.manual_testing then
				chk_disable_manual.enable_select
			else
				chk_disable_manual.disable_select
			end

			if not pref_data.minimize then
				chk_disable_minimize.enable_select
			else
				chk_disable_minimize.disable_select
			end

			if pref_data.output_directory.is_empty then
				create directory_name.make_from_string (eiffel_project.lace.project_path)
				directory_name.extend ("auto_test_gen")
				txt_output_path.set_text (directory_name)
			else
				txt_output_path.set_text (pref_data.output_directory)
			end

			if pref_data.ise_eiffel_path.is_empty then
				txt_ise_eiffel_path.set_text (eiffel_installation_dir_name)
				pref_data.set_ise_eiffel_path (eiffel_installation_dir_name)
			else
				txt_ise_eiffel_path.set_text (pref_data.ise_eiffel_path)
			end

			-- generated relative to output_directory.text, no display in GUI
--			pref_data.output_summary_link
			-- not displayed in GUI, not of great use
--			pref_data.project_name

			sb_time_out.set_value (pref_data.time_out)

			if pref_data.verbose then
				chk_verbose.enable_select
			else
				chk_verbose.disable_select
			end

		end


	init_settings is
			-- get the last stored settings
		do
			init_options

			create chosen_classes.make (10)

			import_classes_from_project

			expand_all_branches_rec (all_classes_container, 1)
		end

	run_auto_test is
			-- `start' closes the `dialog', saves the changes and runs Auto Test
		local
			directory_name: DIRECTORY_NAME
			l_test_classes: LINEAR [STRING]
			output_dialog: AT_OUTPUT_WINDOW
			aw: BOOLEAN
			wd: EV_WARNING_DIALOG
			i: INTEGER
			is_retried: BOOLEAN
		do
			i := project.auto_test_version.count
			dialog_answer := ""
			if project.auto_test_version.index_of ('[', 1) = 1
			and then project.auto_test_version.index_of (']', i) = i
			and then project.auto_test_version.has_substring ("not found") then
				create wd.make_with_text ("Can not run the tests, AutoTest has not been found!")
				wd.show_modal_to_window (Current)
			elseif not is_retried then
				if not project.auto_test_version.is_equal (pref_data.auto_test_version) then
					create wd.make_with_text ("The version of AutoTest has changed.%NDo you still want to run the test?")
					wd.set_buttons_and_actions (<<"Yes", "No">>, <<agent set_answer ("Yes"), agent set_answer ("No")>>)
					wd.set_default_cancel_button (wd.button ("No"))
					wd.set_default_push_button (wd.button("No"))
					wd.show_modal_to_window (Current)
					aw := dialog_answer.is_equal ("Yes")
				else
					aw := True
				end
				if aw then
					-- update version of `AutoTest' in the `config'
					pref_data.set_auto_test_version (project.auto_test_version)

					if txt_output_path.text = Void or else txt_output_path.text.is_empty then
						add_error_message (Warning_messages.w_Fill_in_location_field)
						display_error_message (Current)
					else
						create directory_name.make
						directory_name := validate_directory_name (txt_output_path.text)
						if directory_name = Void or else not directory_name.is_valid then
							add_error_message (Warning_messages.w_Invalid_directory_or_cannot_be_created (txt_output_path.text))
							display_error_message (Current)
						else
							-- create the directory
							recursive_create_directory (directory_name)

							-- save the changes
							store

							project.subscribe_line_command (agent print_string)
							project.subscribe_success (agent print_success)

							project.set_ace_file (pref_data.ace_file)
							project.set_output_directory (directory_name)
							project.set_ise_eiffel_path (txt_ise_eiffel_path.text)
							project.set_time_out (sb_time_out.value)
							project.set_verbose (chk_verbose.is_selected)
							project.set_just_test (chk_just_test.is_selected)
							project.set_manual_testing (not chk_disable_manual.is_selected)
							project.set_auto_testing (not chk_disable_auto.is_selected)
							project.set_minimize (not chk_disable_minimize.is_selected)
							project.set_project_name (pref_data.project_name)

							-- set the `classes to test'
							-- first emtpy `classes_to_test' so it does not contain any element
							project.classes_to_test.wipe_out
							-- put all `classes' to be tested
							from
--								l_test_classes := checked_classes_to_test (all_classes_container).linear_representation
								l_test_classes := chosen_classes.linear_representation
								l_test_classes.start
							until
								l_test_classes.after
							loop
								project.add_class (l_test_classes.item)
								l_test_classes.forth
							end

							hide

							create output_dialog

							-- run auto test
							project.execute

							destroy
						end
					end
				end
			end
		rescue
			is_retried := True
			create wd.make_with_text ("Output Directory: '" + txt_output_path.text + "' could not be created!")
			wd.show_modal_to_window (Current)
			retry
		end

	browse_output_path is
			-- `browse' opens menu to select output directory
		require else
			txt_output_path.text /= Void
		local
			browse: EV_DIRECTORY_DIALOG
			start_directory: STRING
		do
			create browse.make_with_title ("Select a Directory")

			start_directory := txt_output_path.text
			if not start_directory.is_empty then
				start_directory := validate_directory_name (start_directory)
				if (create {DIRECTORY}.make (start_directory)).exists then
					browse.set_start_directory (start_directory)
				end
			end

			browse.ok_actions.extend (agent retrieve_path (browse, txt_output_path))
			browse.show_modal_to_window (Current)
		end

	browse_ise_eiffel_path is
			-- `browse' opens menu to select ise eiffel directory
		require else
			txt_ise_eiffel_path.text /= Void
		local
			browse: EV_DIRECTORY_DIALOG
			start_directory: STRING
		do
			create browse.make_with_title ("Select a Directory")

			start_directory := txt_ise_eiffel_path.text
			if not start_directory.is_empty then
				start_directory := validate_directory_name (start_directory)
				if (create {DIRECTORY}.make (start_directory)).exists then
					browse.set_start_directory (start_directory)
				end
			end

			browse.ok_actions.extend (agent retrieve_path (browse, txt_ise_eiffel_path))
			browse.show_modal_to_window (Current)
		end

	retrieve_path (dialog: EV_DIRECTORY_DIALOG; dir: EV_TEXTABLE) is
			-- Get callback information from `dialog', then send it to the `dir' field.
		require
			dir_not_void: dir /= Void
		do
			dir.set_text (dialog.directory)
		end

	import_classes_from_project is
			-- gets all classes in open project into `all_classes_tree'
--		require
--			target_not_void: target /= Void
		local
--			classes_tree: EB_CHECKABLE_CLASSES_TREE
--			tree_node: EB_CLASSES_TREE_FOLDER_ITEM
--			a_stone: CLASSI_STONE
--			aclassi: CLASS_I
			classes: ARRAY [STRING]
			i: INTEGER
		do
			-- | TODO: include EB_CLASSES_TREE
			-- we need a copy of target.cluster_tool
			--create classes_tree.make
--			create tree_node.make (target.cluster_tool.widget.universe.)
--			tree_node.copy (target.cluster_tool.widget.first)
--			classes_tree.copy (target.cluster_tool.widget.first)
--			classes_tree.remove
--			classes_tree.associate_with_window (target)
--			classes_tree.refresh

			all_classes_container.refresh
			test_classes_container.wipe_out

--			from
--				chosen_classes.start
--			until
--				chosen_classes.off
--			loop
--				create aclassi
--				create a_stone.make (aclassi)
--				chosen_classes.forth
--			end


			-- move the `classes to test' first select all to move then move them
			from
				classes := pref_data.classes_to_test
				i := 1
			until
				i > classes.count
			loop
--D				io.put_string ("Class from storage: " + classes.item (i) + "%N")
				check_tree_item (classes.item (i), all_classes_container, all_classes_container)
				i := i + 1
			end
			move_checked_from_tree_to_tree (all_classes_container, test_classes_container)


		end

	import_classes_from_project_fake_content is
			-- gets all classes in open project into `all_classes_tree'
		local
			cluster_1, class_1, class_2: EV_TREE_ITEM
			class_pixmap, cluster_pixmap: EV_PIXMAP
--			eb_shared_pixmaps: EB_SHARED_PIXMAPS  -- ES
			i: INTEGER
			s: STRING
			-- | TODO: include EB_CLASSES_TREE
		do
--			cluster_pixmap := (create {EB_SHARED_PIXMAPS}).Icon_dialog_window
--			class_pixmap := (create {EB_SHARED_PIXMAPS}).Icon_dialog_window

--			create eb_shared_pixmaps
--			cluster_pixmap := eb_shared_pixmaps.Icon_cluster_symbol
--			class_pixmap := eb_shared_pixmaps.Icon_class_symbol

			cluster_pixmap := pixmaps.icon_cluster_symbol
			class_pixmap := pixmaps.icon_class_symbol

			from
				i := 0
			until
				i > 10
			loop
				-- generating two classes
				if i*2+1 < 10 then s := "0" else s := "" end
				create class_1.make_with_text ("class" + s + (i*2+1).out)
				if i*2+2 < 10 then s := "0" else s := "" end
				create class_2.make_with_text ("class" + s + (i*2+2).out)
				class_1.set_pixmap (class_pixmap)
				class_2.set_pixmap (class_pixmap)

				-- adding the classes to the cluster
				if i+1 < 10 then s := "0" else s := "" end
				create cluster_1.make_with_text ("cluster" + s + (i+1).out)
				if cluster_pixmap /= Void then cluster_1.set_pixmap (cluster_pixmap) end
				cluster_1.extend (class_1)
				if i /= 3 then cluster_1.extend (class_2) end
				if i = 1 then
					if i*2+2 < 10 then s := "0" else s := "" end
					create class_2.make_with_text ("class" + s + (i*2+2).out + "_1")
					class_2.set_pixmap (class_pixmap)
					cluster_1.extend (class_2)

					if i*2+2 < 10 then s := "0" else s := "" end
					create class_2.make_with_text ("class" + s + (i*2+2).out  + "_2")
					class_2.set_pixmap (class_pixmap)
					cluster_1.extend (class_2)
				end

				--- appending the cluster to the clusters tree
				all_classes_container.extend (cluster_1)

				i := i + 1
			end
		end

	target: EB_DEVELOPMENT_WINDOW
			-- Associated target  `development window'.

	dialog_answer: STRING
			-- Answer form `dialogs'

	set_answer (a_string: STRING) is
			-- sets `dialog_answer' to `a_string'
		require
			a_string_not_void: a_string /= Void
		do
			dialog_answer := a_string
		ensure
			dialog_answer_set: dialog_answer.is_equal (a_string)
		end

	all_classes_container: EB_CHECKABLE_CLASSES_TREE
			-- contains the tree with remaining classes not selected for testing

	test_classes_container: EB_CHECKABLE_CLASSES_TREE
			-- contains the tree with the classes selected for testing

feature {NONE} -- handle classes to test

	classes_to_test: ARRAY [STRING] is
			-- the `classes' which should be tested by `AutoTest' put into an array
		local
			counter: INTEGER
		do
			refresh_chosen_classes
			create Result.make (1, chosen_classes.count)
			from
				chosen_classes.start
				counter := 1
			until
				chosen_classes.after
			loop
				Result.put (chosen_classes.item_for_iteration, counter)
				chosen_classes.forth
				counter := counter + 1
			end
		end

--	checked_classes_to_test (widget: EV_CHECKABLE_TREE): ARRAY [STRING] is
--			-- the `classes' which should be tested by `AutoTest' put into an array
--		local
----			node: EV_TREE_NODE
----			src: EV_TREE_NODE_LIST
--			q: LINKED_LIST [STRING]
--			i: INTEGER
--			l: LIST [EV_TREE_NODE]
--			conv_class: EB_CLASSES_TREE_CLASS_ITEM
--		do
--			from
--				create q.make
--				l := widget.checked_items
--				l.start
--			until
--				l.after
--			loop
--				conv_class ?= l.item
--				if conv_class /= Void then
--					io.put_string ( conv_class.data.path + " " + conv_class.data.name + " " +
--									conv_class.data.config_class.group.name + " " + conv_class.data.file_name + "%N")
----					q.extend (conv_class.text)
--					q.extend (class_name_from_tree_node (l.item))
--				end
--				l.forth
--			end
--
--			from
--				create Result.make (1, q.count)
--				q.start
--				i := 1
--			until
--				i > q.count or else	q.after
--			loop
--				Result.put (q.item, i)
--				i := i + 1
--				q.forth
--			end
--		end

	classes_to_store: ARRAY [STRING] is
			-- stores the class paths of the classes to be tested
		local
			counter: INTEGER
		do
			refresh_chosen_classes
			create Result.make (1, chosen_classes.count)
			from
				chosen_classes.start
				counter := 1
			until
				chosen_classes.after
			loop
				Result.put (chosen_classes.key_for_iteration, counter)
				chosen_classes.forth
				counter := counter + 1
			end
		end

	add_to_test is
			-- adds classes to the `classes to test'
		do
			move_checked_from_tree_to_tree (all_classes_container, test_classes_container)
		end

	remove_from_test is
			-- removes classes from the `test classes tree'
		do
			move_checked_from_tree_to_tree (test_classes_container, all_classes_container)
		end

	move_checked_from_tree_to_tree (src, dst: EV_CHECKABLE_TREE) is
			-- adds classes to the `classes to test'
		require
			source_ckeckable_tree_not_void: src /= Void
			destination_ckeckable_tree_not_void: src /= Void
		local
			l_node: DYNAMIC_LIST [EV_TREE_NODE]
		do
			-- notify `refresh_chosen_classes' that there might have been some changes
			scope_has_changed := True
			l_node := src.checked_items
			from
				l_node.start
			until
				l_node.after
			loop
				if src.has (l_node.item) then
					move_chk_cluster_from_tree_to_tree (src, dst, l_node.item)
				elseif tree_has_node_recursively(src, l_node.item) then
					move_chk_class_from_tree_to_tree (src, dst, l_node.item)
				end
				l_node.forth
			end
		ensure
			-- | TODO: implement those pseudocode postconditions in Eiffel
			--			l_node is a list of nodes
--			all_elements_in_dst: dst.has_elements (l_node)
--			all_elemenst_not_in_src: not src.has_elements (l_node)
		end

	move_item_from_tree_to_tree (tree_item: EV_TREE_NODE; src, dst: EV_TREE) is
			-- moves `tree_item' from `src' to `dst' and keeps the path to it (position in tree)
		local
			parent_dst: EV_TREE_NODE
			parent_src: EV_TREE_NODE
		do
			parent_src ?= tree_item.parent
			if parent_src /= Void then
				parent_dst := copy_tree_structure_recursively (parent_src, dst)
				tree_item.parent.prune (tree_item)
				parent_dst.extend (tree_item)
			end
		end

--	move_selected_from_tree_to_tree (src, dst: EV_TREE) is
--			-- adds classes to the `classes to test'
--		require
--			source_ckeckable_tree_not_void: src /= Void
--			destination_ckeckable_tree_not_void: src /= Void
--		local
--			l_node: EV_TREE_NODE
----			l_node: EV_TREE_NODE_IMP
--		do
----			create l_node.make (src.selected_item)
----			l_node.copy (src.selected_item)
--			l_node := src.selected_item
----			if src.has (l_node) then
----				move_cluster_from_tree_to_tree (src, dst, l_node)
--				src.prune_all (l_node)
--				dst.extend (l_node)
----			elseif tree_has_node_recursively(src, l_node) then
----				move_class_from_tree_to_tree (src, dst, l_node)
----				dst.extend (l_node)
----			end
--		ensure
--			-- | TODO: implement those pseudocode postconditions in Eiffel
--			--			l_node is a list of nodes
----			all_elements_in_dst: dst.has_elements (l_node)
----			all_elemenst_not_in_src: not src.has_elements (l_node)
--		end

	move_chk_cluster_from_tree_to_tree (src, dst: EV_CHECKABLE_TREE; tree_item: EV_TREE_NODE) is
			-- moves `tree_item' (a whole cluster, or it's remaining classes) from `src' to `dst' tree
			-- move the tree, with respect to already existing ones
			-- needs to uncheck all checked sub items prior to moving
		require
			source_ckeckable_tree_not_void: src /= Void
			destination_ckeckable_tree_not_void: src /= Void
			tree_item_not_void: tree_item /= Void
		local
			l_tree_node: EV_TREE_NODE_LIST
			cur: EV_TREE_NODE
			dst_cluster: EV_TREE_NODE
			is_put: BOOLEAN
		do
			uncheck_element_and_children_recursively (tree_item, src)

			dst_cluster := find_node_in_tree (tree_item, dst)
			if dst_cluster /= Void then
				-- copy the whole list of sub items (classes)
				l_tree_node := tree_item
--				src.uncheck_item (tree_item)
				src.prune (tree_item)

				-- put subnodes at correct position
				from
					l_tree_node.start
					dst_cluster.start
				until
					dst_cluster.after or l_tree_node.after
				loop
					cur := l_tree_node.item
					if is_less_than_tree_node (cur, dst_cluster.item) then
						l_tree_node.prune (cur)
						dst_cluster.put_left (cur)

						l_tree_node.forth
					end
					if not dst_cluster.after then dst_cluster.forth end
				end
				-- do the remaining ones
				from
					dst_cluster.start
				until
					l_tree_node.after
				loop
					cur := l_tree_node.item
					l_tree_node.prune (cur)
					dst_cluster.extend(cur)

					l_tree_node.forth
				end

			else
--				src.uncheck_item (tree_item)
				uncheck_element_and_children_recursively (tree_item, src)
				src.prune (tree_item)

				-- put at the correct position
				from
					dst.start
				until
					dst.after or else is_put
				loop
					if is_less_than_tree_node (tree_item, dst.item) then
						dst.put_left (tree_item)
						is_put := True
					end
					if not dst.after then dst.forth end
				end

				-- if the item is larger than all the others, put it at the end
				if not is_put then
					dst.extend (tree_item)
				end

			end
		ensure
			src_lacks_item: not tree_has_node (src, tree_item)
			dst_has_item: tree_has_node (dst, tree_item)
		end

	move_chk_class_from_tree_to_tree (src, dst: EV_CHECKABLE_TREE; tree_item: EV_TREE_NODE) is
			-- moves `tree_item' (a class) from `src' to `dst' tree
			-- needs to check whether the cluster is already in the dest tree
			-- insert then the class at the right position

			-- | TODO: improve for `init_settings': first test if the class fits at the end of the list
			--	only helps, if there exists a direct reference to the last element in the according branch
		require
			source_ckeckable_tree_not_void: src /= Void
			destination_ckeckable_tree_not_void: src /= Void
			tree_item_not_void: tree_item /= Void
		local
			dst_cluster, src_cluster: EV_TREE_NODE
--			new_dest_cl: EV_TREE_ITEM
			is_put: BOOLEAN
		do
			src_cluster ?= tree_item.parent
			dst_cluster := find_node_in_tree (src_cluster, dst)
			check
				src_cluster_not_void: src_cluster /= Void
				src_cluster_has_item: src_cluster.has (tree_item)
			end
			if dst_cluster /= Void then
				src_cluster.prune (tree_item)
				if src_cluster.count = 0 then
					src_cluster.parent_tree.prune (src_cluster)
				end
				-- put at the correct position
				from
					dst_cluster.start
				until
					dst_cluster.after or else is_put
				loop
					if is_less_than_tree_node (tree_item, dst_cluster.item) then
						dst_cluster.put_left (tree_item)
						is_put := True
					end
					if not dst_cluster.after then dst_cluster.forth end
				end

				-- if the item is larger than all the others, put it at the end
				if not is_put then
					dst_cluster.extend (tree_item)
				end
				-- end positioning

--				dst.uncheck_item (tree_item)
				uncheck_element_and_children_recursively (tree_item, dst)
				tree_item.set_text (tree_item.text)
			else
				dst_cluster := copy_tree_structure_recursively (src_cluster, dst)

				-- remove item from `src_tree'
				check
					src_cluster.has (tree_item)
				end
				src_cluster.prune (tree_item)
				check
					not src_cluster.has (tree_item)
				end

				-- remove an empty parent node
				-- | TODO: remove empty parent nodes recursively
				if src_cluster.count = 0 then
					-- use this if you are really moving classes
					src_cluster.parent.prune (src_cluster)

					-- use this if you are moving clusters
					if src_cluster.parent_tree /= Void then
						src_cluster.parent_tree.prune (src_cluster)
					end
				end

				dst_cluster.extend (tree_item)
--				dst.uncheck_item (tree_item)
				uncheck_element_and_children_recursively (tree_item, dst)
				tree_item.set_text (tree_item.text)
			end
--			src_cluster := Void
--			dst_cluster := Void
		ensure
			dst_has_item: dst.has_recursively (tree_item)
			-- use this postcondition, the one below does not work
			src_lacks_item: not tree_has_node_recursively (src, tree_item)

			-- | TODO: why this postcondition is violated even if all works well
			--src_lacks_item: not src.has_recursively (tree_item)
		end

	tree_has_node (dst: EV_TREE_NODE_LIST; node: EV_TREE_NODE): BOOLEAN is
			-- checks if `dst' has a `node' named `node.text'
		require
			dst_not_void: dst /= Void
			node_not_void: node /= Void
		do
			from
				dst.start
			until
				dst.after or else Result
			loop
				Result := is_equal_tree_node(dst.item, node)
				if not Result then dst.forth end
			end
		end

	tree_has_node_recursively (dst: EV_TREE_NODE_LIST; node: EV_TREE_NODE): BOOLEAN is
			-- checks if `dst' has recursively a `node' named `node.text'
		require
			dst_not_void: dst /= Void
			node_not_void: node /= Void
		local
--			conv_class: EB_CLASSES_TREE_CLASS_ITEM
			conv_cluster: EB_CLASSES_TREE_FOLDER_ITEM
		do
			from
				dst.start
			until
				dst.after or else Result
			loop
				if is_equal_tree_node(dst.item, node) then
					Result := True
				else
					conv_cluster ?= dst.item
					if conv_cluster /= Void or dst.item.count > 0 then
						Result := tree_has_node_recursively (dst.item, node)
					else
						Result := False
					end
				end
				if not Result then dst.forth end
			end
		end


	find_node_in_tree (node: EV_TREE_NODE; dst: EV_TREE_NODE_LIST): like node is
			-- checks if `dst' has a `sub_node' whose `text' is equal to `node.text'
		require
			dst_not_void: dst /= Void
			node_not_void: node /= Void
		do
			from
				dst.start
			until
				dst.after or else Result /= Void
			loop
				if is_equal_tree_node(dst.item, node) then
					Result := dst.item
				end
				dst.forth
			end
		ensure
			if_found_not_void: tree_has_node(dst, node) implies Result /= Void
		end

	find_node_in_tree_recursively (node: EV_TREE_NODE; dst: EV_TREE_NODE_LIST): like node is
			-- checks if `dst' has a `sub_node' whose `text' is equal to `node.text'
		require
			dst_not_void: dst /= Void
			node_not_void: node /= Void
		do
			from
				dst.start
			until
				dst.after or else Result /= Void
			loop
				if is_equal_tree_node(dst.item, node) then
					Result := dst.item
				elseif dst.item.count > 0 then
					Result := find_node_in_tree_recursively (node, dst.item)
				end
				dst.forth
			end
		ensure
			if_found_not_void: tree_has_node(dst, node) implies Result /= Void
		end

---------- actually not needed -- maybe we need it later
--	find_element_by_name (name: STRING; src_tree: EV_TREE_NODE_LIST): EV_TREE_NODE is
--			-- finds a `tree_node' by `name' in the `src_tree'
--		require
--			name_not_void: name /= Void
--			name_not_noting: name.count > 0
--			src_tree_not_void: src_tree /= Void
--		local
--			l: EV_TREE_NODE_LIST
--		do
--			from
--				l := src_tree.linear_representation
--				l.start
--			until
--				l.after or else Result /= Void
--			loop
--				if l.item.text.out.is_equal (name) then
--					Result := l.item
--				end
--				l.forth
--			end
--		end

--	find_element_by_name_recursively (name: STRING; src_tree: EV_TREE_NODE_LIST): EV_TREE_NODE is
--			-- finds recursively a `tree_node' by `name' in the `src_tree'
--		require
--			name_not_void: name /= Void
--			name_not_noting: name.count > 0
--			src_tree_not_void: src_tree /= Void
--		local
--			l: EV_TREE_NODE_LIST
--			conv_class: EB_CLASSES_TREE_CLASS_ITEM
--			conv_cluster: EB_CLASSES_TREE_FOLDER_ITEM
--		do
--			from
--				l := src_tree
--				l.start
--			until
--				l.after or else Result /= Void
--			loop
--				conv_class ?= l.item
--				if conv_class /= Void then
--					if conv_class.data.name.is_equal (name) then
--						Result := l.item
--					end
--				else
--					conv_cluster ?= l.item
--					if conv_cluster /= Void then
--						Result := find_element_by_name_recursively (name, l.item)
--					end
--				end
--				l.forth
--			end
--		ensure
--			report_found: Result /= Void implies tree_has_node_recursively (src_tree, Result)
--		end

	find_class_by_name_recursively (name: STRING; src_tree: EV_TREE_NODE_LIST): EV_TREE_NODE is
			-- finds recursively a `tree_node' by `name' in the `src_tree'
		require
			name_not_void: name /= Void
			name_not_noting: name.count > 0
			src_tree_not_void: src_tree /= Void
		local
			l: EV_TREE_NODE_LIST
			conv_class: EB_CLASSES_TREE_CLASS_ITEM
			conv_cluster: EB_CLASSES_TREE_FOLDER_ITEM
--			textable: EV_TEXT_COMPONENT
		do
			from
				l := src_tree
				l.start
			until
				l.after or else Result /= Void
			loop
				conv_class ?= l.item
				if conv_class /= Void then
--D					io.put_string ("cur: " + l.item.text + conv_class.data.name + conv_class.stone.file_name + conv_class.tooltip + "%N")
					if conv_class.data.name.is_equal (name) then
						Result := l.item
					end
				else
					conv_cluster ?= l.item
--					io.put_string ("conv_class was void in find_class_by_name%N")
					if conv_cluster /= Void or l.item.count > 0 then
--D						io.put_string ("entering " + l.item.text + "%N")
						Result := find_class_by_name_recursively (name, l.item)
--D						io.put_string ("leaving " + l.item.text + "%N")
					else
--						io.put_string ("conv_cluster was Void in find_class_by_name%N")
					end
				end
				l.forth
			end
		ensure
			report_found: Result /= Void implies tree_has_node_recursively (src_tree, Result)
		end

	copy_tree_structure_recursively (a_item: EV_TREE_NODE; dst: EV_TREE): EV_TREE_NODE is
			-- create the structure of the parent tree of `a_item' in the `dst' tree
			-- returns the copy `a_item' in `dst'
		require
			a_item /= Void
			dst /= Void
		local
			l_item: EV_TREE_NODE
			new_dest_cl: EV_TREE_ITEM
			is_put: BOOLEAN
--			a_cluster: EB_SORTED_CLUSTER
		do
			l_item := find_node_in_tree_recursively (a_item.parent_tree.item, dst)
			if l_item = Void and then not a_item.is_equal (a_item.parent_tree.item) then
				l_item := copy_tree_structure_recursively (a_item.parent_tree.item, dst)
			end

			create new_dest_cl.make_with_text (a_item.text.twin)
			if a_item.pixmap /= Void then
				-- | FIXME possible DEFECT: seems not to assign the correct `pixmap'
				new_dest_cl.set_pixmap (a_item.pixmap)
				new_dest_cl.pixmap.copy (a_item.implementation.pixmap)
			end
			Current.refresh_now
			if l_item /= Void then
				-- put new element at right position
				from
					l_item.start
				until
					l_item.after or else is_put
				loop
					if is_less_than_tree_node (new_dest_cl, l_item.item) then
						l_item.put_left (new_dest_cl)
						is_put := True
					end
					if not l_item.after then l_item.forth end
				end
				-- if the item is larger than all the others, put it at the end
				if not is_put then
					l_item.extend (new_dest_cl)
				end
			else
				-- put new element at right position
				from
					dst.start
				until
					dst.after or else is_put
				loop
					if is_less_than_tree_node (new_dest_cl, dst.item) then
						dst.put_left (new_dest_cl)
						is_put := True
					end
					if not dst.after then dst.forth end
				end
				-- if the item is larger than all the others, put it at the end
				if not is_put then
					dst.extend (new_dest_cl)
				end
			end
			Result := new_dest_cl
		ensure
			tree_has_node_recursively (dst, a_item)
		end

	uncheck_element_and_children_recursively (an_item: EV_TREE_NODE; a_container: EV_CHECKABLE_TREE) is
			-- unchecks `a_item' and all it's sub elements in `a_container'
		require
			an_item_not_void: an_item /= Void
			a_container_not_void: a_container /= Void
			a_container_contains_an_item: a_container.has_recursively (an_item)
		do
			-- first uncheck all children
			if an_item.count > 0 then
				from
					an_item.start
				until
					an_item.after
				loop
					uncheck_element_and_children_recursively (an_item.item, a_container)
					an_item.forth
				end
			end
			-- uncheck element itself
			a_container.uncheck_item (an_item)
		end


	path_name_from_tree_node (tree_node: EV_TREE_NODE): STRING is
			-- `Result' is a path name representing `tree_node' in the
			-- form "base.kernel.COMPARABLE".
			-- feature copied from EB_CLASSES_TREE
		require
			tree_node_not_void: tree_node /= Void
		local
			l_parent: EV_TREE_NODE
		do
			from
				l_parent ?= tree_node.parent
				Result := tree_node.text
			until
				l_parent = Void
			loop
				Result.prepend_character ('.')
				Result.prepend (l_parent.text)
				l_parent ?= l_parent.parent
			end
		ensure
			Result_not_void: Result /= Void
		end

	class_name_from_tree_node (tree_node: EV_TREE_NODE): STRING is
			-- `Result' is the class name of `tree_node' in the form
			-- "ROOT_CLASS".
		require
			tree_node_not_void: tree_node /= Void
		do
			Result := tree_node.text
		end

	check_tree_item (full_path: STRING; tree_item: EV_TREE_NODE_LIST; dst: EV_CHECKABLE_TREE) is
			-- Expand item of `tree_item', whose data matches `full_path'.
		require
			full_path_not_void: full_path /= Void
			tree_item_not_void: tree_item /= Void
		local
			key: STRING
			item_key: STRING
			dot_index: INTEGER
		do
			key := full_path
			dot_index := key.index_of ('.', 1)
			item_key := key.substring (1, dot_index - 1)
			from
				tree_item.start
			until
				tree_item.off
			loop
				if tree_item.item.text.is_equal (item_key) or tree_item.item.text.is_equal (key) then
					if dot_index /= 0 then
						if tree_item.item.is_expandable and then not tree_item.item.is_expanded then
							tree_item.item.expand
						end
						check_tree_item (full_path.substring (dot_index + 1, full_path.count), tree_item.item, dst)
					else
						if tree_item.item.is_expandable and then not tree_item.item.is_expanded then
							tree_item.item.expand
						else
							dst.check_item (tree_item.item)
						end
					end
				end
				tree_item.forth
			end
		end


	sort_tree (tree: EV_TREE_NODE_LIST) is
			-- sorts the `tree' and al `subtrees'
			-- not needed at the moment
			-- inefficient to sort always the whole tree recursively -> better: insert at the right position
			-- at least under the assumption of rearly insertions
		obsolete
			"is not needed and will be removed soon -> not as efficient as insert at correct position"
--		local
--			kl_comp: KL_PART_COMPARATOR [EV_TREE_NODE]
		do

--			sort_with_comparator (tree,)
		end


feature {NONE} -- Store Settings

	chosen_classes: HASH_TABLE [STRING, STRING]
			-- storage for the classes to be tested

	scope_has_changed: BOOLEAN
			-- if true then `chosen_classes' has to be updated

	refresh_chosen_classes is
			-- refreshs the list of the classes chosen to be tested
		do
			if scope_has_changed then
				chosen_classes.wipe_out
				recursive_store (test_classes_container)
				scope_has_changed := False
			end
		end


	recursive_store (tree_list: EV_TREE_NODE_LIST) is
			-- puts the `classes' inside `tree_node' into `chosen_classes'
		local
			a_classi: CLASS_I
			tree_node: EV_TREE_NODE
			was_collapsed: BOOLEAN
		do
			from
				tree_list.start
			until
				tree_list.off
			loop
				tree_node := tree_list.item
				a_classi ?= tree_node.data
				if a_classi /= Void then
					chosen_classes.put (a_classi.name, path_name_from_tree_node (tree_node))
--					io.put_string ("Put class: " + a_classi.name + " at path: " + path_name_from_tree_node (tree_node) + "%N")
				end
				if tree_node.is_expandable then
					if not tree_node.is_expanded and then tree_node.first.text.is_equal ("ANY") then
--						io.put_string ("Node text of a child of a never expanded parent: " + tree_node.first.text + "%N")
						tree_node.expand
						was_collapsed := True
					end
					recursive_store (tree_node)
					if was_collapsed then
						tree_node.collapse
					end
				end
				tree_list.forth
			end
		end


	prefs: PREFERENCES is
			-- `prefs' load and save the preferences
		require
			a_project_is_open: eiffel_project.lace /= Void
		local
			storage: PREFERENCES_STORAGE_XML
			config_file: FILE_NAME
		once
			-- create the path of the `config' file
			create config_file.make_from_string (eiffel_project.lace.project_path)
			config_file.extend ("at_config.xml")
			-- create the `storage' with the `config_file'
			create storage.make_with_location (config_file.out)
			-- create the `prefs' with the `storage'
			create Result.make_with_storage (storage)
		ensure
			prefs_are_created: prefs /= Void
		end

	pref_data: AT_CONFIG_DATA is
			-- is the data to be stored with `prefs'
		once
			create Result.make (prefs)
		end


feature -- DEBUG Testing -- output features

	print_string (s: STRING) is
		do
--D			io.put_string("###%N" + s)
--D			io.new_line
		end

	print_success (b: BOOLEAN) is
		do
--D			if b then
--D				io.put_string("%N###################%NAuto Test succeeded%N")
--D			else
--D				io.put_string("Auto Test failed")
--D			end
			finished := True

		end

	finished: BOOLEAN

	expand_all_branches_rec (widget: EV_TREE_NODE_LIST; i: INTEGER) is
			-- expands and closes all branches of a tree
		do
--			from
--				widget.start
--			until
--				widget.after
--			loop
--				if widget.item.is_usable then
--					widget.item.enable_select
--				end
--				if widget.item.is_expandable and then not widget.item.is_expanded then
--					widget.item.expand
--				end
--				if widget.item.count > 0 and i < 2 then
--					expand_all_branches_rec (widget.item, i + 1)
--				end
--				widget.forth
--			end
		end


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_SETTINGS_DIALOG

