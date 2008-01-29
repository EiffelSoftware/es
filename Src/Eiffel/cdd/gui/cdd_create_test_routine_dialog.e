indexing
	description:
		"[
			Objects that support the user with creating a new test class
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CREATE_TEST_ROUTINE_DIALOG

inherit
	EB_DIALOG

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	SHARED_EIFFEL_PROJECT
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

	EB_VISION2_FACILITIES
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_CLUSTER_MANAGER_OBSERVER
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EV_DIALOG_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EIFFEL_LAYOUT
		export
			{NONE} all
		undefine
			default_create, copy
		end

	CONF_ACCESS
		undefine
			default_create, copy
		end

create
	make_default

feature {NONE} -- Initialization

	make_default (a_target: EB_HISTORY_OWNER; a_manager: like cdd_manager) is
		require
			a_target_not_void: a_target /= Void
			a_manager_not_void: a_manager /= Void
		local
			l_hbox: EV_HORIZONTAL_BOX
			l_widget, l_vbox: EV_VERTICAL_BOX
			l_frame: EV_FRAME
			l_label: EV_LABEL
			l_label_weight: INTEGER

			buttons_box: EV_HORIZONTAL_BOX
			cancel_b: EV_BUTTON	-- Button to discard the class
			bbox: EV_HORIZONTAL_BOX
			sz: INTEGER
			l_window: EB_DEVELOPMENT_WINDOW
			l_factory: EB_CONTEXT_MENU_FACTORY
		do
			target := a_target
			cdd_manager := a_manager

			make_with_title ("Create new test case")
			set_icon_pixmap (pixmaps.icon_pixmaps.cdd_new_test_icon)
			set_height (Layout_constants.dialog_unit_to_pixels (600))
			set_width (Layout_constants.dialog_unit_to_pixels (400))

				-- Build the widgets
			create routine_name_field.make_with_text ("test_")
			create existing_class_button.make_with_text_and_action ("Existing test class", agent select_existing_class)
			create new_class_button.make_with_text_and_action ("New test class", agent select_new_class)
			create test_class_list
			create class_name_field
			class_name_field.change_actions.extend (agent update_file_entry)
			create file_name_field
			l_window := window_manager.last_focused_development_window
			if l_window /= Void then
				l_factory := l_window.menus.context_menu_factory
			end
			create cluster_list.make_without_targets (l_factory)
			cluster_list.select_actions.extend (agent select_target_class)
			cluster_list.set_minimum_size (Cluster_list_minimum_width, Cluster_list_minimum_height)
			cluster_list.refresh
			create feature_list
			feature_list.select_actions.extend (agent select_target_feature)
			feature_list.deselect_actions.extend (agent select_target_feature)
			feature_list.change_actions.extend (agent select_target_feature)


			l_label_weight := 100
			create l_widget
			l_widget.set_padding (Layout_constants.Small_border_size)
			l_widget.set_border_width (Layout_constants.Small_border_size)

				-- Build test routine frame
			create l_frame.make_with_text ("Test routine")
			create l_label.make_with_text ("Routine name: ")
			l_label.align_text_left
			l_label.set_minimum_width (l_label_weight)
			create l_hbox
			l_hbox.extend (l_label)
			l_hbox.disable_item_expand (l_label)
			l_hbox.extend (routine_name_field)
			l_frame.extend (l_hbox)
			extend_no_expand (l_widget, l_frame)

				-- Build test class frame
			create l_frame.make_with_text ("Test class")
			create l_vbox
			l_vbox.set_border_width (Layout_constants.Small_border_size)
			extend_no_expand (l_vbox, existing_class_button)
			l_vbox.extend (test_class_list)
			extend_no_expand (l_vbox, new_class_button)
			create l_hbox
			create l_label.make_with_text ("Class name:")
			l_label.align_text_left
			l_label.set_minimum_width (l_label_weight)
			extend_no_expand (l_hbox, l_label)
			l_hbox.extend (class_name_field)
			extend_no_expand (l_vbox, l_hbox)
			create l_hbox
			create l_label.make_with_text ("File name:")
			l_label.align_text_left
			l_label.set_minimum_width (l_label_weight)
			extend_no_expand (l_hbox, l_label)
			l_hbox.extend (file_name_field)
			extend_no_expand (l_vbox, l_hbox)
			l_frame.extend (l_vbox)
			l_widget.extend (l_frame)

				-- Build target frame
			create l_frame.make_with_text ("Targets")
			create l_vbox
			l_vbox.set_border_width (Layout_constants.Small_border_size)
			create l_label.make_with_text ("Class under test")
			l_label.align_text_left
			extend_no_expand (l_vbox, l_label)
			l_vbox.extend (cluster_list)
			create l_label.make_with_text ("Feature under test")
			l_label.align_text_left
			extend_no_expand (l_vbox, l_label)
			extend_no_expand (l_vbox, feature_list)
			l_frame.extend (l_vbox)
			l_widget.extend (l_frame)

				-- Build the buttons
			create create_button.make_with_text_and_action (Interface_names.b_create, agent create_new_class)
			Layout_constants.set_default_width_for_button (create_button)
			create cancel_b.make_with_text_and_action (Interface_names.b_cancel, agent cancel)
			Layout_constants.set_default_width_for_button (cancel_b)

				-- Build the button box
			create buttons_box
			buttons_box.set_padding (Layout_constants.Small_border_size)
			buttons_box.extend (create {EV_CELL}) -- Expandable item
			extend_no_expand (buttons_box, create_button)
			extend_no_expand (buttons_box, cancel_b)

				-- Build the vertical layout
			l_widget.extend (l_frame)
			extend_no_expand (l_widget, buttons_box)

				-- Add the main container to the dialog.
			extend (l_widget)

				-- Setup the default buttons and show actions.
			set_default_cancel_button (cancel_b)
			set_default_push_button (create_button)
			show_actions.extend (agent on_show_actions)

			cancelled := False
			cluster_preset := False
		ensure
			target_set: target = a_target
			manager_set: cdd_manager = a_manager
		end

feature -- Status Report

	cancelled: BOOLEAN
			-- Was `Current' closed by discarding the dialog
			-- (by clicking the Cancel button for example)?

	class_i: CLASS_I
			-- Created class

	cluster: CONF_CLUSTER
			-- Selected cluster

	path: STRING
			-- Selected subfolder path

	is_deferred: BOOLEAN
			-- Is new class deferred?

feature -- Status Settings

	set_stone_when_finished is
			-- `Current' will send a stone when its execution is over.
		do
			set_stone := True
		end

	preset_cluster (a_cluster: CONF_CLUSTER) is
			-- Assign `a_cluster' to `cluster'.
		require
			a_cluster_not_void: a_cluster /= Void
		do
			cluster := a_cluster
			path := ""
			cluster_preset := True
		ensure
			cluster_set: cluster = a_cluster
			cluster_preset_enabled: cluster_preset
		end

feature -- Basic operations

	call_default is
			-- Create a new dialog with a pre-computed class name.
		do
			load_test_classes
			if test_class_list.is_empty then
				existing_class_button.disable_sensitive
				new_class_button.enable_select
			else
				select_existing_class
			end
			show_modal_to_window (target.window)
		end

feature {NONE} -- Access

	change_cluster is
			-- Set `cluster' to selected cluster from tree.
		local
			l_folder: EB_CLASSES_TREE_FOLDER_ITEM
			clu: EB_SORTED_CLUSTER
		do
			cluster := Void
			aok := True
			if cluster_list.selected_item /= Void then
				l_folder ?= cluster_list.selected_item
				if l_folder /= Void then
					clu := l_folder.data
				else
					l_folder ?= cluster_list.selected_item.parent
					if l_folder /= Void then
						clu := l_folder.data
					end
				end
				if clu /= Void then
					aok := True
					cluster := clu.actual_cluster
					path := l_folder.path
				end
			end
		end

feature {NONE} -- Implementation

	class_name: STRING is
			-- Name of the class entered by the user.
		do
			Result := class_name_field.text.as_upper
		ensure
			class_name_not_void: class_name /= Void
		end

	file_name: FILE_NAME is
			-- File name of the class chosen by the user.
		local
			str: STRING
			dotpos: INTEGER
		do
			str := file_name_field.text
			str.right_adjust
			str.left_adjust
				-- str.count < 3 means there no extension to the file name.
			if str.is_empty or else str.count < 3 then
				update_file_entry
				create Result.make_from_string (file_name_field.text)
			else
				if
					str @ (str.count) /= 'e' or else
					str @ (str.count - 1) /= '.'
				then
					dotpos := str.last_index_of ('.', str.count) - 1
					if dotpos > 0 then
						str.keep_head (dotpos)
					end
					create Result.make_from_string (str)
					Result.add_extension ("e")
				else
					create Result.make_from_string (str)
				end
			end
		end

	aok: BOOLEAN

	could_not_load_file: BOOLEAN
			-- Was there an error when attempting to create the class file?

	cluster_preset: BOOLEAN
			-- Was a target cluster set by `preset_cluster'?

	set_stone: BOOLEAN
			-- Should `Current' send a stone when its execution is over?

	target: EB_HISTORY_OWNER
			-- Associated target.

	cdd_manager: CDD_MANAGER
			-- Manager for which new test class shall be created

	create_new_class is
			-- Create a new class
		local
			l_new_class_path: STRING
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_cluster: CONF_CLUSTER
			l_universe: UNIVERSE_I
			l_list: LIST [CLASS_I]
			l_test_class: EIFFEL_CLASS_C
			l_loc: CONF_DIRECTORY_LOCATION
			l_target: CONF_TARGET
			l_name: STRING
			f_name: FILE_NAME
			file: RAW_FILE -- Windows specific
			base_name: STRING
			wd: EB_WARNING_DIALOG
			retried: BOOLEAN
		do
			if not retried then
					-- Write to existing test class
				aok := False
				l_universe := cdd_manager.project.universe
				if existing_class_button.is_selected then
					l_list := l_universe.classes_with_name (test_class_list.selected_item.text)
					if not l_list.is_empty and then not l_list.first.is_read_only then
						aok := True
						class_i := l_list.first
					else
						create wd.make_with_text ("Can not write to selected test class")
						wd.show_modal_to_window (Current)
					end
				else
						-- Create new test class

					change_cluster
					if aok then
						check_valid_class_name
					end
					if aok then
						create l_new_class_path.make_empty
						if cluster /= Void then
							from
								l_cluster := cluster
							until
								l_cluster = Void
							loop
								l_new_class_path := "/" + l_cluster.name + l_new_class_path
								l_cluster := l_cluster.parent
							end
						end
						l_loc := cdd_manager.testing_directory
						create l_output_file.make (l_loc.build_path (l_new_class_path, file_name))
						if l_output_file.exists then
							create wd.make_with_text ("There exists a file with this name")
							wd.show_modal_to_window (Current)
						else
							aok := True
						end
					end

					if aok then
						l_output_file.recursive_open_write
						if not l_output_file.is_open_write then
							create wd.make_with_text ("Could not create test class file")
							wd.show_modal_to_window (Current)
							aok := False
						end
					end

					if aok then
						l_target := cdd_manager.test_suite.target
						l_name := l_target.name + "_tests"
						l_cluster := l_universe.cluster_of_name (l_name)
						if l_cluster = Void then
								-- Need to create cdd tests cluster first
							l_cluster := conf_factory.new_cdd_cluster (l_name, l_loc, l_target)
							l_cluster.set_recursive (True)
							l_cluster.set_classes (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))
							l_cluster.set_classes_by_filename (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))

							l_target.add_cluster (l_cluster)
							cdd_manager.project.system.system.set_config_changed (True)
							manager.refresh
						end
						load_default_class_text (l_output_file)
						l_output_file.close
						if could_not_load_file then
							create wd.make_with_text ("An error occurred writing the new class file")
							wd.show_modal_to_window (Current)
							aok := False
						else
							manager.add_class_to_cluster (file_name, l_cluster, l_new_class_path)
							class_i := manager.last_added_class
						end
					end
				end

					-- TODO: write new routine into class_i!
				if aok then
					append_test_routine
					destroy
				end
			end
		rescue
			retried := True
			retry
		end

	load_default_class_text (an_output: KL_TEXT_OUTPUT_FILE) is
			-- Loads the default class text.
		require
			an_output_not_void: an_output /= Void
			an_output_open_write: an_output.is_open_write
		local
			input: RAW_FILE
			in_buf: STRING
			wd: EB_WARNING_DIALOG
			retried: BOOLEAN
			clf: FILE_NAME
		do
			if not retried then
				create clf.make_from_string (eiffel_layout.Templates_path)
				clf.set_file_name ("manual_test_class")
				clf.add_extension ("cls")
				create input.make (clf)
				if input.exists and then input.is_readable then
					input.open_read
					input.read_stream (input.count)
					in_buf := input.last_string
					in_buf.replace_substring_all ("$classname", class_name)

						--| In case we crash later, to know where we were.
					if not in_buf.is_empty then
						in_buf.prune_all ('%R')
						if preferences.misc_data.text_mode_is_windows then
							in_buf.replace_substring_all ("%N", "%R%N")
							an_output.put_string (in_buf)
						else
							an_output.put_string (in_buf)
							if in_buf.item (in_buf.count) /= '%N' then
									-- Add a carriage return like `vi' if there's none at the end
								an_output.put_new_line
							end
						end
					end
					could_not_load_file := False
				else
					create wd.make_with_text (Warning_messages.w_cannot_read_file (input.name))
					wd.show_modal_to_window (target.window)
					could_not_load_file := True
				end
			else
				create wd.make_with_text (Warning_messages.w_cannot_read_file (input.name))
				wd.show_modal_to_window (target.window)
			end
		rescue
			retried := True
			retry
		end

	append_test_routine is
			-- Append test routine in `class_i'.
		require
			class_i_not_void: class_i /= Void
		local
			l_modifier: CLASS_TEXT_MODIFIER
			l_class_item: EB_CLASSES_TREE_CLASS_ITEM
			l_class: CLASS_I
			l_routine, l_fut, l_code: STRING
		do
			l_class_item ?= cluster_list.selected_item
			if l_class_item /= Void then
				l_class := l_class_item.data
			end
			l_fut := feature_list.text
			l_routine := routine_name_field.text

			create l_modifier.make (class_i)
			l_modifier.prepare_for_modification
			if l_modifier.valid_syntax then
				l_modifier.set_position_by_feature_clause ("", "Tests for {" + l_class.name + "}." + l_fut)
				create l_code.make (100)
				l_code.append_character ('%T')
				l_code.append (l_routine)
				l_code.append (" is%N")
				l_code.append ("%T%T%T-- Manual test routine")
				if l_class /= Void then
					l_code.append (" for class ")
					l_code.append (l_class.name)
				else
					l_code.append ("%T%T%T-- Manual test routine%N")
				end
				l_code.append ("%N%T%Tindexing%N%T%T%Ttag: %"your.own.tags%"%N")
				if l_class /= Void then
					l_code.append ("%T%T%Ttag: %"covers.")
					l_code.append (l_class.name)
					if not l_fut.is_empty then
						l_code.append_character ('.')
						l_code.append (l_fut)
					end
					l_code.append ("%"%N")
				end
				l_code.append ("%T%Tdo%N%T%T%T%N%T%Tend%N%N")
				l_modifier.insert_code (l_code)
				if l_modifier.valid_syntax then
					l_modifier.commit_modification
				else
					aok := False
				end
			else
				aok := False
			end
		end

	on_show_actions is
			-- The dialog has just been shown, set it up.
		local
			curr_selected_item: EV_TREE_NODE
		do
				--| Make sure the currently selected item is visible
			curr_selected_item := cluster_list.selected_item
			if curr_selected_item /= Void then
				cluster_list.ensure_item_visible (curr_selected_item)
			end

				--| Make sure the text in the routine entry is entirely visible
				--| and is selected.
			routine_name_field.set_focus
			routine_name_field.set_caret_position (1)
			routine_name_field.select_all
		end

	check_class_not_exists is
			-- Check that class with name `class_name' does not exist in the universe.
		require
			current_state_is_valid: aok
		local
			wd: EB_WARNING_DIALOG
			l_classes: HASH_TABLE [CONF_CLASS, STRING]
		do
			l_classes := cluster.classes
			if l_classes.has_key (class_name) and then l_classes.found_item.is_valid then
				aok := False
				create wd.make_with_text (Warning_messages.w_class_already_exists (class_name))
				wd.show_modal_to_window (Current)
			end
		end

	check_valid_class_name is
			-- Check that name `class_name' is a valid class name.
		require
			current_state_is_valid: aok
		local
			cn: STRING
			wd: EB_WARNING_DIALOG
		do
			cn := class_name
			aok := (create {EIFFEL_SYNTAX_CHECKER}).is_valid_class_name (cn)
			if not aok then
				create wd.make_with_text (Warning_messages.w_invalid_class_name (cn))
				wd.show_modal_to_window (Current)
			end
		end

	update_file_entry is
			-- Update the file name according to the class name.
		local
			str: STRING
		do
			str := class_name_field.text
			str.right_adjust
			str.left_adjust
			if str.is_empty then
				file_name_field.remove_text
			else
				str.to_lower
				str.append (".e")
				file_name_field.set_text (str)
			end
		end

	cancel is
			-- User pressed `cancel_b'.
		do
			cancelled := True
			destroy
		ensure
			cancelled_set: cancelled
		end

	on_focus_in is
			-- When the parents list has the focus, we disable the default push button.
		do
			if default_push_button /= Void then
				remove_default_push_button
			end
		end

	on_focus_out is
			-- When the parents list loses the focus, we enable the default push button.
		do
				-- Need to check that the dialog is not destroyed as sometimes
				-- we get called while destroying the dialog.
			if not is_destroyed then
				set_default_push_button (create_button)
			end
		end

	compute_group: CONF_GROUP is
			-- Compute group.
		do
			change_cluster
			Result := cluster
		end

feature {NONE} -- Access (Buttons)

	create_button: EV_BUTTON
			-- Button to create the class

	cluster_list: EB_CLASSES_TREE
			-- List of all available clusters.

feature {NONE} -- Access (Widgets)

	routine_name_field: EV_TEXT_FIELD
			-- Text field for new routine name

	existing_class_button: EV_RADIO_BUTTON
			-- Radio button for choosing existing test class

	new_class_button: EV_RADIO_BUTTON
			-- Radio button for creating new test class

	test_class_list: EV_LIST
			-- List displaying existing test classes

	class_name_field: EV_TEXT_FIELD
			-- Text field in which the user will type the name of the class

	file_name_field: EV_TEXT_FIELD
			-- Text field in which the user may type the file name of the class.

	feature_list: EV_COMBO_BOX
			-- List of all exported features for a selected class

feature {NONE} -- Implementation (Test class)

	load_test_classes is
			-- Load all test classes found in test suite
			-- into `test_class_list' sorted by their name.
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_CLASS]
			l_names: DS_ARRAYED_LIST [STRING]
			l_class: EIFFEL_CLASS_C
			l_item: EV_LIST_ITEM
		do
			l_cursor := cdd_manager.test_suite.test_classes.new_cursor
			create l_names.make (cdd_manager.test_suite.test_classes.count)
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_names.force_last (l_cursor.item.test_class_name)
				l_cursor.forth
			end
			l_names.sort (create {DS_QUICK_SORTER [STRING]}.make (
				create {KL_COMPARABLE_COMPARATOR [STRING]}.make))
			from
				l_names.start
			until
				l_names.after
			loop
				create l_item.make_with_text (l_names.item_for_iteration)
				l_item.set_pixmap (pixmaps.icon_pixmaps.class_normal_icon)
				test_class_list.force (l_item)
				l_names.forth
			end
		end

	select_existing_class is
			-- Enable `test_class_list' and disable
			-- fields for new class
		do
			test_class_list.enable_sensitive
			class_name_field.parent.disable_sensitive
			file_name_field.parent.disable_sensitive
		end

	select_new_class is
			-- Disable `test_class_list' and enable
			-- fields for new class
		do
			test_class_list.disable_sensitive
			class_name_field.parent.enable_sensitive
			file_name_field.parent.enable_sensitive
		end

feature {NONE} -- Implementation (Target)

	select_target_class is
			-- Adopt `feature_list' to selected class in
			-- `cluster_list' if class is selected.
		local
			l_item: EB_CLASSES_TREE_CLASS_ITEM
			l_class: CLASS_C
			l_ft: FEATURE_TABLE
			l_feature: FEATURE_I
			l_cs: CURSOR
			l_list_item: EV_LIST_ITEM
		do
			feature_list.wipe_out
			feature_list.set_text ("")
			l_item ?= cluster_list.selected_item
			if l_item /= Void and then l_item.data.is_compiled and then l_item.data.compiled_class.has_feature_table then
				l_ft := l_item.data.compiled_class.feature_table
				from
					l_cs := l_ft.cursor
					l_ft.start
				until
					l_ft.after
				loop
					l_feature := l_ft.item_for_iteration
					if 	l_feature.written_class = l_item.data.compiled_class and
						l_feature.is_routine and not l_feature.has_arguments then
						create l_list_item.make_with_text (l_feature.feature_name)
						l_list_item.set_pixmap (pixmaps.icon_pixmaps.feature_routine_icon)
						feature_list.force (l_list_item)
					end
					l_ft.forth
				end
				l_ft.go_to (l_cs)
			end
			if l_item /= Void then
				class_name_field.set_text (l_item.data.name.as_upper + "_TESTS")
			end
		end

	select_target_feature is
			-- Modify `routine_name_field' to current selected
			-- feature in `feature_list'.
		do
			routine_name_field.set_text ("test_" + feature_list.text)
		end


feature {NONE} -- Constants

	Cluster_list_minimum_width: INTEGER is
			-- Minimum width for the cluster list.
		do
			Result := Layout_constants.Dialog_unit_to_pixels (250)
		end

	Cluster_list_minimum_height: INTEGER is
			-- Minimum height for the cluster list.
		do
			Result := Layout_constants.Dialog_unit_to_pixels (100)
		end

	conf_factory: CONF_COMP_FACTORY is
			-- Factory for creating CONF_LOCATION
		once
			create Result
		end


invariant
	create_button_valid: create_button /= Void and then not create_button.is_destroyed
	cluster_list_valid: cluster_list /= Void and then not cluster_list.is_destroyed
	class_entry_valid: class_name_field /= Void and then not class_name_field.is_destroyed
	file_entry_valid: file_name_field /= Void and then not file_name_field.is_destroyed
	target_not_void: target /= Void
	cluster_implies_path: cluster /= Void implies path /= Void

end
