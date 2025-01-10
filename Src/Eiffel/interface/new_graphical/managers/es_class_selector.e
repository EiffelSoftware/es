note
	description: "Location to enter the name of a class and the name of a feature.%
				  % Manage the history of the parent as well."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"
	see_also: "{EB_ADDRESS_MANAGER}"

class
	ES_CLASS_SELECTOR

inherit
	EB_CONSTANTS
		export
			{NONE} all
		end

	EB_RECYCLABLE
		redefine
			internal_detach_entities
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	EB_SHARED_WINDOW_MANAGER
		export
			{NONE} all
		end

	EB_SHARED_PREFERENCES

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		end

	EV_UTILITIES
		export
			{NONE} all
		end

	EV_SHARED_APPLICATION
		export
			{NONE} all
		end

	EB_CONTEXT_MENU_HANDLER

	ES_SHARED_PROMPT_PROVIDER
		export
			{NONE} all
		end

	SHARED_LOCALE

	SHARED_ENCODING_CONVERTER

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature {NONE} -- Initialization

	make (a_parent: EV_WIDGET; a_stone_i_cb: PROCEDURE [STONE])
			-- Initialize the widget and set up the activate actions.
		do
			parent := a_parent

			stone_callback := a_stone_i_cb

			create change_actions

				-- Set up the parent.
			set_mode (False)
			enable_accept_general_group

				-- Create the widget.
			build_interface

			create label_changed_actions
		end

	build_interface
			-- Build Vision2 architecture.
		local
			hbox: like widget
			vb: EV_VERTICAL_BOX
			label: EV_LABEL
--			l_item: SD_TOOL_BAR_ITEM
			l_hbox: EV_HORIZONTAL_BOX
			l_font: EV_FONT
		do
			l_font := Default_font

--			create tool_bar_items.make (10)

			create hbox
			hbox.set_padding (Layout_constants.Small_border_size)

			if mode then
					-- Cluster label.
				create label.make_with_text (interface_names.l_cluster)
				label.set_font (l_font)
				hbox.extend (label)
				hbox.disable_item_expand (label)

					-- Cluster selector.
				create cluster_address
				cluster_address.set_font (l_font)
				cluster_address.set_minimum_width (Layout_constants.Dialog_unit_to_pixels (130))
				hbox.extend (cluster_address)
			end

				-- Class label.
			create label.make_with_text (interface_names.l_class)
			label.set_font (l_font)

			if mode then
				hbox.extend (label)
				hbox.disable_item_expand (label)
			else
				create l_hbox
				l_hbox.set_border_width (Layout_constants.Small_border_size)
				l_hbox.extend (label)

--				create {SD_TOOL_BAR_WIDGET_ITEM} l_item.make (l_hbox)
--				l_item.set_description (interface_names.l_class_label)

--				l_item.set_name ("class label")

--				tool_bar_items.extend (l_item)
			end

				-- Class selector.
			create class_address
			class_address.set_font (l_font)
			class_address.set_minimum_width (Layout_constants.Dialog_unit_to_pixels (200))
			class_address.set_default_key_processing_handler (agent (k: EV_KEY): BOOLEAN
					do
						inspect k.code
						when {EV_KEY_CONSTANTS}.key_up, {EV_KEY_CONSTANTS}.key_down then
							Result := False
						when {EV_KEY_CONSTANTS}.key_enter then
							Result := False
						else
							Result := True
						end
					end)

			if not mode then
				hbox.extend (class_address)
			else
				-- Then we build a `class_addre
--				create {SD_TOOL_BAR_RESIZABLE_ITEM} l_item.make (class_address)
--				l_item.set_description (interface_names.l_class_address)
--				l_item.set_name ("class address combo")

--				tool_bar_items.extend (l_item)
			end

			if not mode then
					-- View label
				create label.make_with_text (interface_names.l_view)
				label.set_font (l_font)

				create l_hbox
				l_hbox.set_border_width (Layout_constants.Small_border_size)
				l_hbox.extend (label)

--				create {SD_TOOL_BAR_WIDGET_ITEM} l_item.make (l_hbox)

--				l_item.set_description (interface_names.l_view_label)
--				l_item.set_name ("view label")

--				tool_bar_items.extend (l_item)
			end

				-- Setup the widget.
			if not mode then
				widget := hbox
			else
				create vb
				vb.extend (hbox)
				vb.disable_item_expand (hbox)
				create output_line
				output_line.align_text_right
				vb.extend (output_line)
				create address_dialog
				address_dialog.enable_border
				address_dialog.close_request_actions.extend (agent hide_address_dialog)
				address_dialog.extend (vb)
				generate_header_info

				cluster_address.key_release_actions.extend (agent cluster_key_up)
				cluster_address.key_press_actions.extend (agent cluster_key_down)
				cluster_address.change_actions.extend (agent type_cluster)
				cluster_address.select_actions.extend (agent change_hist_to_cluster)

				cluster_address.focus_out_actions.extend (agent one_lost_focus)
				class_address.focus_out_actions.extend (agent one_lost_focus)
			end

			class_address.key_release_actions.extend (agent class_key_up)
			class_address.key_press_actions.extend (agent class_key_down)
			class_address.change_actions.extend (agent type_class)
			class_address.select_actions.extend (agent change_hist_to_class)

			lost_focus_action_enabled := True
		end

feature -- Access

	parent: EV_WIDGET
			-- Parent for Current.

	stone_callback: PROCEDURE [STONE]

	change_actions: EV_NOTIFY_ACTION_SEQUENCE

	widget: detachable EV_HORIZONTAL_BOX
			-- Vision2 widget representing the control.

	context_target: detachable CONF_TARGET assign set_context_target

	header_info: EV_HORIZONTAL_BOX
			-- Container for Cluser, Class and Feature selector.

	cluster_label_text: STRING
			-- Name of the class as it appears in the cluster label.
		do
			if cluster_label /= Void and then not cluster_label.text.same_string (default_cluster_name) then
				Result := cluster_label.text
			end
		end

	class_label_text: STRING
			-- Name of the class as it appears in the class label.
		do
			if class_label /= Void and then not class_label.text.same_string (default_class_name) then
				Result := class_label.text
			end
		end

	class_name: STRING
			-- Name of the class as it appears in the combo box.
			-- Void if none.

	parent_widget: EB_DEVELOPMENT_WINDOW
			-- Development window.
		require
			not_context_mode: not mode
		do
			Result := {EB_DEVELOPMENT_WINDOW} / parent
		ensure
			result_not_void: Result /= Void
		end

	label_changed_actions: EV_NOTIFY_ACTION_SEQUENCE
		-- Label text change actions.

feature -- Status report

	is_general_group_acceptable: BOOLEAN
			-- Is general group acceptable in address bar?

feature -- Element change

	set_context_target (t: like context_target)
		do
			context_target := t
		end

	set_context_group (g: CONF_GROUP)
		do
			if g /= Void then
				set_context_target (g.target)
			end
		end

	reset
			-- Reset the address manager.
		do
			class_name := Void
			class_i := Void
			class_address.remove_text
		end

	set_focus
			-- Give the focus to the class combo box.
		do
			if class_address.is_sensitive then
				if not class_address.has_focus then
					class_address.set_focus
				elseif class_address.text_length > 0 then
					-- Class address already has focus. We select all texts in it instead of doing nothing.
					-- This behavior is same as Firefox's `Ctrl + L' shortcut.
					class_address.select_all
				end
			end
		end

	disable_sensitive
		do
			if attached widget as w then
				w.disable_sensitive
			elseif attached header_info as w then
				w.disable_sensitive
			end
		end

	set_output_line (t: EV_LABEL)
			-- Set the textable in which messages will be displayed.
			-- `t' may be Void, this means that there will be no output.
		require
			t_not_void: t /= Void
		do
			output_line := t
		ensure
			output_line_not_void: output_line /= Void
		end

	enable_accept_general_group
			-- Enable that general group is acceptable.
		do
			is_general_group_acceptable := True
		ensure
			general_group_acceptable: is_general_group_acceptable
		end

	disable_accept_general_group
			-- Disable the acceptability of general group.
		do
			is_general_group_acceptable := False
		ensure
			general_group_not_acceptable: not is_general_group_acceptable
		end

feature -- Class text helpers

	class_text: detachable STRING_32
		do
			if attached class_address as t then
				Result := t.text
			else
				Result := class_name
			end
		end

	set_class_text (s: detachable READABLE_STRING_GENERAL)
		do
			if attached class_address as t then
				if s = Void then
					t.remove_text
				else
					t.set_text (s)
				end
			end
		end

feature -- Memory management

	internal_recycle
			-- Recycle `Current' and leave it in an unstable state,
			-- so that we know whether we're not referenced any longer.
		do
			if attached widget as w then
				w.destroy
				widget := Void
			end
			parent := Void
		end

	internal_detach_entities
			-- <Precursor>
		do
			address_dialog := Void
			choice := Void
			class_address := Void
			class_i := Void
			class_label := Void
			class_list := Void
			class_name := Void
			cluster_address := Void
			cluster_label := Void
			context_menu_factory := Void
			current_group := Void
			group_list := Void
			header_info := Void
			internal_recycle_actions := Void
			internal_recycle_pool := Void
			label_changed_actions := Void
			output_line := Void
			parent := Void
			recycler := Void
			widget := Void
			Precursor
		end

feature {EB_DEVELOPMENT_WINDOW, EB_DEVELOPMENT_WINDOW_DIRECTOR, EB_DEVELOPMENT_WINDOW_MAIN_BUILDER} -- Vision2 Controls

	cluster_address: EV_COMBO_BOX
			-- Cluster part of the address.

	class_address: EV_COMBO_BOX
			-- Class part of the address.

feature -- Updating

	refresh
			-- Update the text in the widgets according to parent's stone.
		do
			update_combos
			update_colors
		end

	update_colors
			-- Update the colors for the address manager labels
		do
			if mode then
				cluster_label.set_foreground_color (preferences.editor_data.cluster_text_color)
				class_label.set_foreground_color (preferences.editor_data.class_text_color)

				set_background_color_if_needed (cluster_label, preferences.editor_data.cluster_background_color)
				set_background_color_if_needed (class_label, preferences.editor_data.class_background_color)
			end
		end

	set_background_color_if_needed (lab: EV_LABEL; bg: EV_COLOR)
			-- Set background color `bg` to `lab`,
			-- but only if `bg` and `lab.background_color` really differs
			-- note: this is mostly to support dark theme.
		local
			r,g,b: REAL_64
			c1: EV_COLOR
		do
			c1 := lab.background_color
			r := (c1.red_16_bit - bg.red_16_bit).abs / {EV_COLOR}.max_16_bit
			g := (c1.green_16_bit - bg.green_16_bit).abs / {EV_COLOR}.max_16_bit
			b := (c1.blue_16_bit - bg.blue_16_bit).abs / {EV_COLOR}.max_16_bit
			if (r + g + b) / 3 > 0.5 then
				lab.set_background_color (bg)
			end
		end

	on_project_created
			-- A new project has been loaded. Enable all controls.
		do
			if cluster_address /= Void then
				cluster_address.enable_sensitive
				class_label.enable_sensitive
				cluster_label.enable_sensitive
			end
			class_address.enable_sensitive
		end

	on_project_unloaded
			-- Current project has been closed. Disable all controls.
		do
			if mode then
				cluster_address.disable_sensitive
				class_label.disable_sensitive
				cluster_label.disable_sensitive
			end
			class_address.disable_sensitive
		end

	pop_up_address_bar_at_position (a_x, a_y: INTEGER; a_focus: INTEGER)
			-- Display current address manager at position (`a_x', `a_y').
			-- `a_focus' indicates which combo box will have focus by default:
			-- 	 	1 cluster combo box
			--		2 class combo box
			--		other: Focus is unset
		require
	   		for_context_tool: mode
  		local
			l_helper: EVS_HELPERS
			window: EV_WINDOW
			l_pos: TUPLE [x, y: INTEGER]
		do
			window := parent_window (header_info)
			if address_dialog.is_show_requested then
				hide_address_dialog
			end
			address_dialog.set_width (header_info.width)
			create l_helper
			if window /= Void then
				l_pos := l_helper.suggest_pop_up_widget_location_with_size (window, a_x, a_y, address_dialog.width, address_dialog.height)
			else
				l_pos := [a_x, a_y]
			end
		   	address_dialog.set_position (l_pos.x, l_pos.y)
			address_dialog.show
			remove_error_message
			inspect
				a_focus
			when 1 then
				cluster_address.set_focus
			when 2 then
				class_address.set_focus
			else
			end
		end

	hide_address_bar
			-- Hide address bar dialog.
		do
			if attached address_dialog as dlg then
				dlg.hide
			end
		end

	hide_address_dialog
		do
			if attached address_dialog as dlg and then dlg.is_displayed then
				dlg.hide
			end
		end

feature {EB_DEVELOPMENT_WINDOW, EB_DEVELOPMENT_WINDOW_DIRECTOR} -- Execution

	execute_with_cluster
			-- The user just entered a new cluster name, process it.
		do
			extract_cluster_from_user_entry
		end

	execute_with_class
			-- The user just entered a new class name, process it.
		do
			process_user_entry
		end

feature {NONE} -- Execution

	process_cluster_callback (pos: INTEGER)
			-- The choice `pos' has been selected, process the choice.
		require
			looking_for_a_cluster: group_list /= Void
		do
			if pos /= 0 then
				current_group := group_list.i_th (pos)
				cluster_address.set_text (current_group.name.twin)
			end
			group_list := Void
			process_cluster
		end

	process_class_callback (pos: INTEGER)
			-- The choice `pos' has been selected, process the choice.
		require
			looking_for_a_class: class_list /= Void
		do
			if pos /= 0 then
				class_i := class_list.i_th (pos)
				class_address.set_text (class_i.name)
			end
			class_list := Void
			process_class
		end

	process_cluster
			-- Finish processing the cluster after the user chose it.
		do
			if current_group = Void then
				display_error_message (Warning_messages.w_No_cluster_matches)
				if cluster_address.is_displayed then
					cluster_address.set_focus
					if not cluster_address.text.is_empty then
						cluster_address.select_all
					end
				end
			else
				remove_error_message
				set_active_stone (create {CLUSTER_STONE}.make (current_group))
			end
		end

	process_class
			-- Finish processing the class after the user chose it.
		local
			ctxt: READABLE_STRING_32
			l_classc: CLASS_C
		do
			remove_error_message
			if class_i = Void then
				ctxt := class_address.text
				if
					not ctxt.is_empty and then
					not ctxt.has ('*') and then
					not ctxt.has ('?') and then
					workbench.is_in_stable_state
				then
--					if (create {EIFFEL_SYNTAX_CHECKER}).is_valid_class_name (ctxt) then
--						create new_class_win.make_default (parent, False)
--						new_class_win.set_stone_when_finished
--						new_class_win.call (class_address.text)
--					else
						prompts.show_error_prompt (Warning_messages.w_Invalid_class_name (ctxt), {EB_VISION2_FACILITIES}.parent_window_from (parent), Void)
--					end
				else
					display_error_message (Warning_messages.w_No_class_matches)
					if class_address.is_displayed then
						class_address.set_focus
						if not class_address.text.is_empty then
							class_address.select_all
						end
					end
				end
			else
				l_classc := class_i.compiled_representation
				set_active_stone (create {CLASSI_STONE}.make (class_i))
			end
		end

feature -- Assertions

	mode: BOOLEAN
			-- If `mode' then the display is for the context tool (`window', `header_info' are generated),
			-- otherwise it is for a development window (`widget' is generated).

feature {NONE} -- Implementation

	class_i: CLASS_I
			-- Current selected class.

	current_group: CONF_GROUP
			-- Current selected group.

	must_show_choice: BOOLEAN
			-- Does the user have to perform a choice?

	class_list: LIST [CLASS_I]
			-- List of classes displayed in `choice'.

	group_list: LIST [CONF_GROUP]
			-- List of groups displayed in `choice'.

	choice: EB_CHOICE_DIALOG
			-- Dialog that gives the user the choice between possible classes, groups or features.
			-- It may be Void, destroyed, anything, so use with care.

	drop_class (cst: CLASSI_STONE)
			-- Attempt to drop a class into the address bar.
		do
			set_active_stone (cst)
		end

	drop_cluster (cst: CLUSTER_STONE)
			-- Attempt to drop a class into the address bar.
		do
			set_active_stone (cst)
		end

	set_active_stone (st: STONE)
		do
			if attached {EB_STONABLE} parent as w then
				w.set_stone (st)
			else
				active_stone := st
				stone_callback (st)
				on_update
			end
			change_actions.call (Void)
		end

	on_update
		do
			class_address.select_actions.block
			class_address.change_actions.block
			class_address.wipe_out

			if mode then
				cluster_address.select_actions.block
				cluster_address.change_actions.block
				cluster_address.wipe_out
			end

			update_combos
			if mode then
				update_labels
				hide_address_bar
				cluster_address.select_actions.resume
				cluster_address.change_actions.resume
			end
			class_address.select_actions.resume
			class_address.change_actions.resume
		end

	display_cluster_choice
				-- Display cluster names from `group_list' to `choice'.
		require
			group_list_not_void: group_list /= Void
		local
			cluster_names: ARRAYED_LIST [STRING_32]
			cluster_pixmaps: ARRAYED_LIST [EV_PIXMAP]
			clusteri: CONF_GROUP
		do
			create cluster_names.make (group_list.count)
			create cluster_pixmaps.make (group_list.count)
			from
				group_list.start
			until
				group_list.after
			loop
				clusteri := group_list.item
				cluster_names.extend (clusteri.name.twin)
				cluster_pixmaps.extend (pixmap_from_group (clusteri))
				group_list.forth
			end
			if not cluster_names.is_empty then
				remove_error_message
				if cluster_names.count = 1 then
					process_cluster_callback (1)
				else
					create choice.make_default (address_dialog, agent process_cluster_callback (?))
					choice.destroy_actions.extend (agent one_lost_focus)
					choice.set_title (Interface_names.t_Select_cluster)
					choice.set_list (cluster_names, cluster_pixmaps)
					position_choice_window (choice, cluster_address)
					must_show_choice := True
				end
			else
				display_error_message (Warning_messages.w_No_cluster_matches)
				process_cluster
			end
		end

	display_class_choice
				-- Display class names from `class_list' to `choice'.
		require
			class_list_not_void: class_list /= Void
		local
			class_names: ARRAYED_LIST [STRING_32]
			class_pixmaps: ARRAYED_LIST [EV_PIXMAP]
			classi, last_class: CLASS_I
			cname, last_name: STRING_32
			first_ambiguous: BOOLEAN
		do
				-- First remove all overriden classes if any before display the choice.
			from
				class_list.start
			until
				class_list.after
			loop
				if class_list.item.config_class.is_overriden then
					class_list.remove
				else
					class_list.forth
				end
			end

				-- Fill the choice list
			create class_names.make (class_list.count)
			create class_pixmaps.make (class_list.count)
			from class_list.start until class_list.after loop
				classi := class_list.item
				create cname.make_from_string_general (classi.name)
				if
					last_class /= Void and then
					last_class.name.same_string_general (cname)
				then
					if not first_ambiguous then
						first_ambiguous := True
						last_name := class_names.last
						last_name.extend ('@')
						last_name.append (last_class.group.name)
					end
					cname.extend ('@')
					cname.append (classi.group.name)
				else
					first_ambiguous := False
				end
				class_names.extend (cname)
				class_pixmaps.extend (pixmap_from_class_i (classi))
				last_class := classi
				class_list.forth
			end
			if not class_names.is_empty then
				remove_error_message
				if class_names.count = 1 then
					process_class_callback (1)
				else
					create choice.make_default (address_dialog, agent process_class_callback (?))
					choice.destroy_actions.extend (agent one_lost_focus)
					choice.set_title (Interface_names.t_Select_class)
					choice.set_list (class_names, class_pixmaps)
					position_choice_window (choice, class_address)
					must_show_choice := True
				end
			else
				display_error_message (Warning_messages.w_No_class_matches)
				process_class
			end
		end

feature {NONE} -- open new class

	extract_cluster_from_user_entry
			-- Process the user entry in `cluster_address' to generate `current_group'.
		local
			fname: STRING_32
			cl: ARRAYED_LIST [CONF_GROUP]
			matcher: KMP_WILD
			matching: SORTED_TWO_WAY_LIST [CONF_GROUP]
		do
			if workbench.is_universe_ready then
				current_group := Void
				fname := cluster_address.text
				if fname /= Void then
					string_general_left_adjust (fname)
					string_general_right_adjust (fname)
				end
				if fname = Void or else fname.is_empty then
					process_cluster
				else
					fname := fname.as_lower
					create matcher.make_empty
						--|FIXME: Unicode handling. Not sure matcher accept UTF8
					matcher.set_pattern (encoding_converter.utf32_to_utf8 (fname))
					if not matcher.has_wild_cards then
						if is_general_group_acceptable then
							current_group := universe.group_of_name (fname)
						else
							current_group := Universe.cluster_of_name (fname)
						end
						process_cluster
					elseif Universe.target /= Void then
						from
							if is_general_group_acceptable then
								cl := Universe.groups
							else
								cl := Universe.target.clusters.linear_representation
							end
							cl.start
							create matching.make
						until
							cl.after
						loop
							matcher.set_text (cl.item.name)
							if matcher.pattern_matches then
								matching.extend (cl.item)
							end
							cl.forth
						end
						matching.sort
						group_list := matching
						display_cluster_choice
					end
				end
			else
				hide_address_dialog
			end
		end

	process_user_entry
			-- process the user entry
		local
			cname: STRING_32
			sorted_classes: SORTED_TWO_WAY_LIST [CLASS_I]
			at_pos: INTEGER
			cluster: CLUSTER_I
			cluster_name: STRING
			matcher: KMP_WILD
			l_classes: ITERABLE [CLASS_I]
			l_classes_list: ARRAYED_LIST [CLASS_I]
		do
			if workbench.is_universe_ready then
				class_i := Void
				cname := class_address.text
				if cname /= Void then
					string_general_left_adjust (cname)
					string_general_right_adjust (cname)
				end
				if cname = Void or else cname.is_empty then
					process_class
				else
					cname := cname.as_upper
					create matcher.make_empty
					matcher.set_pattern (encoding_converter.utf32_to_utf8 (cname))
					if not matcher.has_wild_cards then
						at_pos := cname.index_of ('@', 1)
						if at_pos = cname.count then
							cname.keep_head (cname.count - 1)
							class_address.set_text (cname)
							at_pos := 0
						end
						if at_pos = 0 then
							if universe.target = Void then
								class_list := Void
							else
								if attached context_target as g then
									create {ARRAYED_LIST [CLASS_I]} class_list.make (0)
									if attached g.class_by_name (cname, True) as lst then
										across
											lst as ic
										loop
											if attached {EIFFEL_CLASS_I} ic.item as ecl then
												class_list.force (ecl)
											end
										end
									end
								else
									class_list := Universe.classes_with_name (cname)
								end
							end
							if class_list = Void or else class_list.is_empty then
								class_list := Void
								process_class
							elseif class_list.count = 1 then
								class_i := class_list.first
								process_class
							else
								display_class_choice
							end
						else
							cluster_name := cname.substring (at_pos + 1, cname.count)
							if at_pos > 1 then
								cname := cname.substring (1, at_pos - 1)
							else
								cname := ""
							end
							cluster := Universe.cluster_of_name (cluster_name)
							if cluster = Void then
								prompts.show_error_prompt (Warning_messages.w_Cannot_find_cluster (cluster_name), {EB_VISION2_FACILITIES}.parent_window_from (parent), Void)
								if class_address.is_displayed then
									class_address.set_focus
									class_address.select_region (at_pos + 1, class_address.text_length)
								end
							else
								class_i := {CLASS_I} / cluster.classes.item (cname)
								process_class
							end
						end
					else
						create sorted_classes.make
						if attached context_target as g then
							if attached g.accessible_classes as tb then
								create l_classes_list.make (tb.count)
								across
									tb as tb_ic
								loop
									if attached {EIFFEL_CLASS_I} tb_ic.item as ecl then
										l_classes_list.force (ecl)
									end
								end
								l_classes := l_classes_list
							else
								l_classes := Void
							end
						else
							l_classes := universe.all_classes
						end
						if l_classes /= Void then
							across
								l_classes as cl_ic
							loop
								matcher.set_text (cl_ic.item.name)
								if matcher.pattern_matches then
									sorted_classes.put_front (cl_ic.item)
								end
							end
						end
						sorted_classes.sort
						class_list := sorted_classes
						display_class_choice
					end
				end
			else
				hide_address_dialog
			end
		end

	change_hist_to_class
			-- Center the history manager on a different stone.
		do
			if
				attached class_address.selected_item as item and then
				attached {INTEGER_REF} item.data as conv_int
			then
--				parent.history_manager.go_i_th (conv_int.item)
			end
		end

	change_hist_to_cluster
			-- Center the history manager on a different stone.
		do
			if
				attached cluster_address.selected_item as item and then
				attached {INTEGER_REF} item.data as conv_int
			then
--				parent.history_manager.go_i_th (conv_int.item)
			end
		end

	cluster_key_up (k: EV_KEY)
			-- A key was released in the cluster address.
			-- If it is return, call execute_with_cluster.
		do
			if k /= Void then
				if k.code = {EV_KEY_CONSTANTS}.key_enter then
					if must_show_choice and choice /= Void and then not choice.is_destroyed then
						lost_focus_action_enabled := False
						choice.show
						lost_focus_action_enabled := True
					end
				elseif k.code = {EV_KEY_CONSTANTS}.Key_escape then
					if mode then
						hide_address_dialog
					end
				end
			end
		end

	class_key_up (k: EV_KEY)
			-- A key was released in the class address.
			-- If it is return, call execute_with_class.
		local
			s: STRING_32
		do
			if k /= Void then
				inspect k.code
				when {EV_KEY_CONSTANTS}.key_enter then
					type_class_offset := 0
					if must_show_choice and choice /= Void and then not choice.is_destroyed then
						lost_focus_action_enabled := False
						choice.show
						lost_focus_action_enabled := True
					end
				when {EV_KEY_CONSTANTS}.Key_escape then
					type_class_offset := 0
					if mode then
						hide_address_dialog
					end
				when {EV_KEY_CONSTANTS}.key_space then
					if
						ev_application.ctrl_pressed and
						not ev_application.alt_pressed and
						not ev_application.shift_pressed and
						must_show_choice and
						choice /= Void and then
						not choice.is_destroyed
					then
						lost_focus_action_enabled := False
						choice.show
						lost_focus_action_enabled := True
					end
				when {EV_KEY_CONSTANTS}.Key_up, {EV_KEY_CONSTANTS}.Key_down then
					s := class_address.text
					if s.count > 1 and class_address.has_selection then
						if k.code = {EV_KEY_CONSTANTS}.Key_down then
							type_class_offset := type_class_offset - 1
						else
							type_class_offset := type_class_offset + 1
						end
						remove_selection_silently (class_address)
						class_address.change_actions.call (Void)
					else
						type_class_offset := 0
					end
				else
					type_class_offset := 0
				end
			end
		end


	class_key_down (k: EV_KEY)
			-- A key was pressed in the class address.
			-- If it is return, call execute_with_class.
		local
			s: STRING_32
		do
			if k /= Void then
				last_key_was_delete := False
				last_key_was_backspace := False
				inspect k.code
				when {EV_KEY_CONSTANTS}.key_enter then
					execute_with_class
					if class_address.text_length > 0 then
						class_address.select_all
					end
				when {EV_KEY_CONSTANTS}.Key_space then
					if
						ev_application.ctrl_pressed and then
						not ev_application.alt_pressed and
						not ev_application.shift_pressed
					then
						remove_selection_silently (class_address)
						class_address.change_actions.block
						s := class_address.text
						s.right_adjust
						s.extend ('*')
						class_address.set_text (s)
						class_address.change_actions.resume
						execute_with_class
					end
				when {EV_KEY_CONSTANTS}.Key_delete then
					last_key_was_delete := True
				when {EV_KEY_CONSTANTS}.Key_back_space then
					last_key_was_backspace := True
					if class_address.has_selection then
						had_selection := True
					else
						had_selection := False
					end
				else
				end
			end
		end

	cluster_key_down (k: EV_KEY)
			-- A key was pressed in the cluster address.
			-- If it is return, call execute_with_cluster.
		do
			if k /= Void then
				last_key_was_delete := False
				last_key_was_backspace := False
				if k.code = {EV_KEY_CONSTANTS}.key_enter then
					execute_with_cluster
					if cluster_address.text_length > 0 then
						cluster_address.select_all
					end
				elseif k.code = {EV_KEY_CONSTANTS}.Key_delete then
					last_key_was_delete := True
				elseif k.code = {EV_KEY_CONSTANTS}.Key_back_space then
					last_key_was_backspace := True
					if cluster_address.has_selection then
						cluster_had_selection := True
					else
						cluster_had_selection := False
					end
				end
			end
		end

	last_key_was_delete: BOOLEAN
			-- Was the last pressed key `delete'?

	last_key_was_backspace: BOOLEAN
			-- Was the last pressed key `back_space'?

	type_class_offset: INTEGER
			-- Offset to use in the list of class choices.

	cluster_had_selection: BOOLEAN
			-- Did the cluster address had a selection when the user hit the key?
			-- Only meaningful if `last_key_was_backspace'.

	had_selection: BOOLEAN
			-- Did the class address had a selection when the user hit the key?
			-- Only meaningful if `last_key_was_backspace'.

	type_class
			-- Try to complete the class name.
		local
			str: STRING_32
			nb: INTEGER
			index, j: INTEGER
			list: CLASS_C_SERVER
			current_found: STRING_32
			l_suggestions: ARRAYED_LIST [TUPLE [entry: STRING_32; depth: INTEGER]]
			cname: STRING_32
			array_count: INTEGER
			do_not_complete: BOOLEAN
			same_st: BOOLEAN
			last_caret_position: INTEGER
			str_area, other_area: SPECIAL [CHARACTER_32]
			truncated: BOOLEAN
		do
				-- The text in `class_address' has changed => we don't know what's inside.
			str := class_address.text
			if not str.is_empty and then (str [str.count] /= ' ') then
				last_caret_position := class_address.caret_position
				class_address.change_actions.block
					-- Remove white space from classname
				str.left_adjust
				str.right_adjust
					-- Convert classname input to uppercase for classes
				str.to_upper
					-- Replace spaces with underscores for classes
				str.replace_substring_all (" ", "_")
					-- Replace dashes with underscores for classes
				str.replace_substring_all ("-", "_")
				nb := str.count
				do_not_complete :=	last_key_was_delete or
									not enable_complete or
									last_caret_position /= nb + 1 or
									not Workbench.is_universe_ready
				if nb > 0 and not do_not_complete and last_key_was_backspace and had_selection then
					str.keep_head (nb - 1)
					nb := nb - 1
					truncated := True
				end

				if not do_not_complete and nb > 1 then
					str_area := str.area
					if attached context_target as g then
						if attached g.accessible_classes as l_accessible_classes then
							across
								l_accessible_classes as ic
							loop
								if attached {EIFFEL_CLASS_I} ic.item as ecl then
									cname := ecl.name
									other_area := cname.area
										-- We first check that other_area and str_area have the same start.
									if other_area.count >= nb then
										from
											j := 0
											same_st := True
										until
											j = nb or not same_st
										loop
											same_st := str_area [j] = other_area [j]
											j := j + 1
										end
										if same_st then
											if l_suggestions = Void then
												create l_suggestions.make (1)
											end
											l_suggestions.force ([cname, j])
										end
									end
								end
							end
						end
					else
						list := System.classes
						array_count := system.class_counter.count
						from
							index := 1
						until
							index > array_count
						loop
							if attached list [index] as l_class then
								cname := l_class.name
								other_area := cname.area
									-- We first check that other_area and str_area have the same start.
								if other_area.count >= nb then
									from
										j := 0
										same_st := True
									until
										j = nb or not same_st
									loop
										same_st := str_area [j] = other_area [j]
										j := j + 1
									end
									if same_st then
										if l_suggestions = Void then
											create l_suggestions.make (1)
										end
										l_suggestions.force ([cname, j])
									end
								end
							end
							index := index + 1
						end
					end
					if l_suggestions /= Void and then not l_suggestions.is_empty then
						sort_suggestions (l_suggestions)
						if type_class_offset < 0 then
							type_class_offset := l_suggestions.count + type_class_offset
						end
						type_class_offset := type_class_offset \\ l_suggestions.count
						if l_suggestions.valid_index (1 + type_class_offset) then
							current_found := l_suggestions [1 + type_class_offset].entry
						end
					else
						current_found := Void
					end
					if current_found /= Void then
						if not last_key_was_backspace then
							current_found := current_found.as_upper
							class_address.set_text (current_found)
							if nb < current_found.count then
								class_address.select_region (nb + 1, current_found.count)
							else
								class_address.set_caret_position (current_found.count + 1)
							end
						end
					elseif not (last_key_was_backspace and had_selection) then
						str.to_upper
						class_address.set_text (str)
						class_address.set_caret_position (str.count + 1)
					end
				else
					str.to_upper
					class_address.set_text (str)
					if not truncated then
						class_address.set_caret_position (last_caret_position.min (str.count + 1))
					else
						class_address.set_caret_position (nb + 1)
					end
				end
			end
			class_address.change_actions.resume
		end

	type_cluster
			-- Try to complete the cluster name.
		local
			str: STRING_32
			nb: INTEGER
			j: INTEGER
			list: ARRAYED_LIST [CONF_GROUP]
			l_suggestions: ARRAYED_LIST [TUPLE [entry: STRING_32; depth: INTEGER]]
			current_found: STRING_32
			cname: STRING_32
			do_not_complete: BOOLEAN
			last_caret_position: INTEGER
			same_st: BOOLEAN
			str_area, other_area: SPECIAL [CHARACTER_32]
			truncated: BOOLEAN
		do
			cluster_address.change_actions.block
			last_caret_position := cluster_address.caret_position
			str := cluster_address.text
			if workbench.universe_defined and then universe.target /= Void and then not str.is_empty and then (str [str.count] /= ' ') then
				str.left_adjust
				str.right_adjust
				str.to_lower
				nb := str.count
				do_not_complete :=	last_key_was_delete or
									not enable_cluster_complete or
									last_caret_position /= str.count + 1
				if nb > 0 and not do_not_complete and last_key_was_backspace and cluster_had_selection then
					str.keep_head (nb - 1)
					nb := nb - 1
					truncated := True
				end

				if not do_not_complete and nb > 0 then
					if is_general_group_acceptable then
						list := universe.groups
					else
						list := universe.target.clusters.linear_representation
					end
					from
						str_area := str.area
						list.start
					until
						list.after
					loop
						cname := list.item.name
						other_area := cname.area
							-- We first check that other_area and str_area have the same start.
						if other_area.count >= nb then
							from
								j := 0
								same_st := True
							until
								j = nb or not same_st
							loop
								same_st := str_area [j] = other_area [j]
								j := j + 1
							end
							if same_st then
								if l_suggestions = Void then
									create l_suggestions.make (1)
								end
								l_suggestions.force ([cname, j])
							end
						end
						list.forth
					end
					if l_suggestions /= Void and then not l_suggestions.is_empty then
						sort_suggestions (l_suggestions)
						current_found := l_suggestions.first.entry
					else
						current_found := Void
					end
					if current_found /= Void then
						if not last_key_was_backspace then
							cluster_address.set_text (current_found)
							if nb < current_found.count then
								cluster_address.select_region (nb + 1, current_found.count)
							else
								cluster_address.set_caret_position (current_found.count + 1)
							end
						end
					elseif not (last_key_was_backspace and cluster_had_selection) then
						cluster_address.set_text (str)
						cluster_address.set_caret_position (str.count + 1)
					end
				else
					cluster_address.set_text (str)
					if not truncated then
						cluster_address.set_caret_position (last_caret_position)
					else
						cluster_address.set_caret_position (nb + 1)
					end
				end
			end
			cluster_address.change_actions.resume
		end

	current_class: CLASS_C
			-- Currently examined class_c.
			-- Either what the user typed in `class_address' or manager's stone.
		do
			if class_i /= Void then
				Result := class_i.compiled_representation
			end
		end

	launch_cluster
			-- Send a stone representing `current_group' to `parent'.
		require
			cluster_selected: current_group /= Void
		do
			if current_group /= Void then
				set_active_stone (create {CLUSTER_STONE}.make (current_group))
			end
		end

	launch_class
			-- Send a stone representing `current_class' or `class_i' to `parent'.
		require
			class_selected: class_i /= Void
		local
			st: STONE
		do
			if current_class /= Void then
				create {CLASSC_STONE} st.make (current_class)
			else
				create {CLASSI_STONE} st.make (class_i)
			end

			set_active_stone (st)
		end

feature {NONE} -- Selection removal

	remove_selection_silently (cb: EV_COMBO_BOX)
		local
			s: STRING_32
		do
			if cb.has_selection then
				s := cb.text
				cb.change_actions.block
				s.remove_tail (cb.selected_text.count)
				cb.set_text (s)
				cb.set_caret_position (s.count + 1)
				cb.change_actions.resume
			end
		end

feature {NONE} -- Sorting

	sort_suggestions (a_suggestions: LIST [TUPLE [entry: STRING_32; depth: INTEGER]])
		local
			l_suggestion_sorter: QUICK_SORTER [TUPLE [entry: STRING_32; depth: INTEGER]]
		do
			create l_suggestion_sorter.make (create {AGENT_EQUALITY_TESTER [TUPLE [entry: STRING_32; depth: INTEGER]]}.make (agent (t1,t2: TUPLE [entry: STRING_32; depth: INTEGER]): BOOLEAN
				local
					minc: INTEGER
					l_index: INTEGER
					dif: BOOLEAN
					t1_area, t2_area: SPECIAL [CHARACTER_32]
				do
					t1_area := t1.entry.area
					t2_area := t2.entry.area
					from
						l_index := t1.depth
						minc := t2_area.count.min (t1_area.count)
						dif := False
					until
						dif or l_index = minc
					loop
						if t1_area [l_index] /= t2_area [l_index] then
							dif := True
							Result := t1_area [l_index] < t2_area [l_index]
						end
						l_index := l_index + 1
					end
					if not dif then
							-- t2 and t1 have the same characters.
							-- shorter one is less than.
						Result := t1_area.count < t2_area.count
					end
				end))
			l_suggestion_sorter.sort (a_suggestions)
		end


feature {NONE} -- Implementation of the clickable labels for `header_info'

	lost_focus_action_enabled: BOOLEAN
			-- Should `one_lost_focus' do something?

	cluster_label: EV_LABEL
	class_label: EV_LABEL
			-- Labels displayed in the header_info.

	output_line: EV_LABEL
			-- Textable in which warnings are displayed.
			-- May be Void, warnings are then not displayed.

	address_dialog: EV_POPUP_WINDOW
			-- Window that pops up in the context tool to change the stone centering.

	active_stone: detachable STONE

	set_mode (for_tool: BOOLEAN)
			-- Define `Current's execution mode (generated parent_windows are different).
		do
			mode := for_tool
		end

	generate_header_info
			-- Create all parent_windows used in `header_info'.
		local
			hb: EV_HORIZONTAL_BOX
		do
			create header_info
			create cluster_label
			create class_label

			create hb

			update_colors

			cluster_label.pointer_enter_actions.extend (agent highlight_label (cluster_label))
			cluster_label.pointer_leave_actions.extend (agent unhighlight_label (cluster_label))
			class_label.pointer_enter_actions.extend (agent highlight_label (class_label))
			class_label.pointer_leave_actions.extend (agent unhighlight_label (class_label))

			cluster_label.pointer_button_press_actions.extend (agent button_action (cluster_label, cluster_address, ?, ?, ?, ?, ?, ?, ?, ?))
			class_label.pointer_button_press_actions.extend (agent button_action (class_label, class_address, ?, ?, ?, ?, ?, ?, ?, ?))

			cluster_label.set_pebble_function (agent associated_stone (cluster_label))
			class_label.set_pebble_function (agent associated_stone (class_label))

			class_label.drop_actions.extend (agent drop_class)
			cluster_label.drop_actions.extend (agent drop_cluster)

			cluster_label.enable_sensitive
			class_label.enable_sensitive

			cluster_label.set_accept_cursor (Cursors.cur_Cluster)
			class_label.set_accept_cursor (Cursors.cur_Class)
			cluster_label.set_deny_cursor (Cursors.cur_X_Cluster)
			class_label.set_deny_cursor (Cursors.cur_X_Class)

			cluster_label.set_text (default_cluster_name)
			highlight_label (cluster_label)
			unhighlight_label (cluster_label)

			class_label.set_text (default_class_name)
			highlight_label (class_label)
			unhighlight_label (class_label)

			cluster_label.set_configurable_target_menu_mode
			class_label.set_configurable_target_menu_mode

			cluster_label.set_configurable_target_menu_handler (agent context_menu_handler)
			class_label.set_configurable_target_menu_handler (agent context_menu_handler)

			hb.set_padding (2)
			hb.extend (cluster_label)
			hb.extend (class_label)
			hb.disable_item_expand (cluster_label)
			hb.disable_item_expand (class_label)
			header_info.extend (hb)
		end

	context_menu_handler (a_menu: EV_MENU; a_target_list: ARRAYED_LIST [EV_PND_TARGET_DATA]; a_source: EV_PICK_AND_DROPABLE; a_pebble: ANY)
			-- Context menu handler
		do
			if context_menu_factory /= Void then
				context_menu_factory.standard_compiler_item_menu (a_menu, a_target_list, a_source, a_pebble)
			end
		end

	update_labels
			-- Refresh the text of the labels according to the active stone.
		require
			for_context_tool: mode
		local
			l_stone: STONE
			l_class_c: CLASS_C
		do
				-- Reset data
			cluster_label.set_data (Void)
			class_label.set_data (Void)

			l_stone := active_stone
			if attached {CLUSTER_STONE} l_stone as l_conv_clus then
				cluster_label.set_text (l_conv_clus.group.name)
				cluster_label.set_data (l_conv_clus)
				class_label.set_text (default_class_name)
			elseif attached {CLASSI_STONE} l_stone as l_conv_class then
				cluster_label.set_text (l_conv_class.group.name)
				cluster_label.set_data (create {CLUSTER_STONE}.make (l_conv_class.group))
				class_label.set_text (l_conv_class.class_i.name)
				l_class_c := l_conv_class.class_i.compiled_representation
				if l_class_c /= Void then
					class_label.set_data (create {CLASSC_STONE}.make (l_class_c))
				else
					class_label.set_data (create {CLASSI_STONE}.make (l_conv_class.class_i))
				end
			else
				cluster_label.set_text (default_cluster_name)
				class_label.set_text (default_class_name)
			end
				-- Adapt the size of labels with new text.
			cluster_label.set_minimum_width (maximum_label_width (cluster_label.text))
			class_label.set_minimum_width (maximum_label_width (class_label.text))

			label_changed_actions.call (Void)
		end

	update_combos
			-- Refresh the text in the combo boxes in order to display the current stone.
		local
			c_stone: STONE
		do
			c_stone := active_stone
			if attached {CLUSTER_STONE} c_stone as conv_clus then
				if mode then
					cluster_address.set_text (conv_clus.group.name)
				end
				class_address.remove_text
			else
				if not mode then
					if attached {CLASSI_STONE} c_stone as conv_class then
						class_address.set_text (conv_class.class_i.name)
					else
						class_address.remove_text
					end
				else
					if attached {CLASSI_STONE} c_stone as conv_class then
						cluster_address.set_text (conv_class.group.name)
						class_address.set_text (conv_class.class_i.name)
					else
						cluster_address.remove_text
						class_address.remove_text
					end
				end
			end
		end

	pop_up_address_bar
			-- Display a window containing an address bar to change the stone.
		require
	   		for_context_tool: mode
		do
			pop_up_address_bar_at_position ((header_info.screen_x + header_info.width // 2) - address_dialog.width // 2, header_info.screen_y, 0)
		end

	button_action (a_label: EV_LABEL; combo: EV_COMBO_BOX; x, y, b: INTEGER; d1, d2, d3: DOUBLE; ax, ay: INTEGER)
			-- Action performed when one of the labels is clicked.
			-- Pop up `address_dialog' and give focus to `combo'.
		require
			for_context_tool: mode
			a_label_attached: a_label /= Void
			combo_attached: combo /= Void
		do
			if b = {EV_POINTER_CONSTANTS}.left then
				lost_focus_action_enabled := False
				pop_up_address_bar
				if combo.is_displayed then
					combo.set_focus
				end
				lost_focus_action_enabled := True
			elseif b = {EV_POINTER_CONSTANTS}.right and then ev_application.ctrl_pressed then
				if attached {STONE} a_label.data as l_stone and then l_stone.is_valid then
					(create {EB_CONTROL_PICK_HANDLER}).launch_stone (l_stone)
				end
			end
		end

	one_lost_focus
			-- One of the widgets displayed in `address_dialog' has lost the focus.
			-- If none now has the focus, hide `address_dialog'.
		do
			if
				mode and then
					-- Now it's for context tool, `address_dialog' exists.
				lost_focus_action_enabled and then
				(class_address = Void or else not class_address.has_focus) and then
				(cluster_address = Void or else not cluster_address.has_focus) and then
				(address_dialog = Void or else not address_dialog.has_focus) and then
				(choice = Void or else (choice.is_destroyed or else not choice.is_show_requested))
			then
				hide_address_dialog
			end
		end

	Big_font: EV_FONT
			-- Font used to highlight labels.
		do
			Result := Default_font
			Result.set_weight ({EV_FONT_CONSTANTS}.Weight_black)
		end

	Default_font: EV_FONT
			-- Font used to display labels.
			-- FIXIT: We should use once routine instead of creating a EV_FONT every time? Because this is GDI object limitations on Windows.
		do
				-- TODO: After class EV_STOCK_FONTS added, we should use that instead of SD_SHARED.
			Result := (create {SD_SHARED}).tool_bar_font.twin
		end

	highlight_label (lab: EV_LABEL)
			-- Display `lab' with a bold font.
		do
			lab.set_minimum_width (maximum_label_width (lab.text))
			lab.set_font (big_font)
		end

	maximum_label_width (a_text: STRING_GENERAL): INTEGER
			-- Maximum width of a label when set with text `a_text'
		require
			a_text_not_void: a_text /= Void
		local
			l_string_size_default, l_string_size_big: TUPLE [width, height, left_offset, right_offset: INTEGER]
			l_width_default, l_width_big: INTEGER
		do
			l_string_size_default := Default_font.string_size (a_text)
			l_string_size_big := big_font.string_size (a_text)

			l_width_default := l_string_size_default.width - l_string_size_default.left_offset + l_string_size_default.right_offset
			l_width_big := l_string_size_big.width - l_string_size_big.left_offset + l_string_size_big.right_offset

			Result := l_width_default.max (l_width_big) + (2 * layout_constants.small_border_size)
		end

	unhighlight_label (lab: EV_LABEL)
			-- Display `lab' with a bold font.
		do
			lab.set_font (Default_font)
		end

	display_error_message (a_message: STRING_GENERAL)
			-- Display error message `a_message'.
		require
			a_message_not_void: a_message /= Void
		do
			if output_line /= Void then
				output_line.set_foreground_color (preferences.editor_data.error_text_color)
				output_line.set_text (a_message)
				output_line.refresh_now
			else
				-- FIXME: how do we warn the user?
			end
		end

	remove_error_message
			-- Remove any message from `output_line'.
		do
			if output_line /= Void then
				output_line.remove_text
			end
		end

	enable_complete: BOOLEAN
			-- Does the user want class names to be completed?
		do
			Result := preferences.development_window_data.class_completion --, True
		end

	enable_cluster_complete: BOOLEAN
			-- Does the user want cluster names to be completed?
		do
			Result := preferences.development_window_data.class_completion --, True
		end

	default_class_name: STRING_GENERAL
			-- Default name for class
		do
			Result := interface_names.l_no_class_bra
		end


	default_cluster_name: STRING_GENERAL
			-- Default name for cluster		
		do
			Result := interface_names.l_no_cluster_bra
		end

	l_Space: STRING = " "

	l_From: STRING = " from "

	associated_stone (a_label: EV_LABEL): detachable STONE
			-- Associated stone which is `a_stone' for normal pick and drop and Ctrl+Right click.
		require
			a_label_attached: a_label /= Void
		do
			if not ev_application.ctrl_pressed then
				Result := {STONE} / a_label.data
			end
		end

feature {NONE} -- Choice Positioning

	border_size: INTEGER = 20
			-- Size in pixels that the pop up window can go to (virtual border)

	position_choice_window (a_choice: like choice; a_positioned: EV_POSITIONED)
			-- Position `a_choice' at a proper place around `a_positioned'
		require
			a_choice_not_void: a_choice /= Void
			a_positioned_not_void: a_positioned /= Void
		do
			a_choice.set_width (a_positioned.width)
			a_choice.set_position (calculate_completion_list_x_position (a_positioned),
									calculate_completion_list_y_position (a_positioned))
			a_choice.set_height (calculate_completion_list_height (a_positioned))
		end

	calculate_completion_list_x_position (a_positioned: EV_POSITIONED): INTEGER
			-- Determine the x position to display the popup dialog.
		require
			a_positioned_not_void: a_positioned /= Void
		local
			screen: EV_SCREEN
			right_space,
			list_width: INTEGER
		do
			create screen

			Result := a_positioned.screen_x
				-- Determine how much room there is free on the right of the screen from the cursor position
			right_space := screen.virtual_right - Result

			list_width := calculate_completion_list_width (a_positioned)

			if right_space < list_width then
					-- Shift x pos back so it fits on the screen
				Result := Result - (list_width - right_space)
			end
			Result := Result.max (screen.virtual_left)
		end

	calculate_completion_list_y_position (a_positioned: EV_POSITIONED): INTEGER
			-- Determine the y position to display the popup dialog.
		require
			a_positioned_not_void: a_positioned /= Void
		local
			screen: EV_SCREEN
		do
				-- Get y pos of cursor
			create screen
			Result := a_positioned.screen_y
			if Result < ((screen.virtual_height / 3) * 2) then
					-- Cursor in upper two thirds of screen.
				Result := Result + a_positioned.height
			else
					-- Cursor in lower third of screen.
				Result := Result - calculate_completion_list_height (a_positioned)
			end
			Result := Result.max (screen.virtual_top)
		end

	calculate_completion_list_height (a_positioned: EV_POSITIONED): INTEGER
			-- Determine the height the popup dialog should have
		require
			a_positioned_not_void: a_positioned /= Void
		local
			y_pos: INTEGER
			screen: EV_SCREEN
		do
				-- Get y pos of cursor
			create screen
			y_pos := a_positioned.screen_y
			if y_pos < (screen.virtual_height / 3) * 2 then
					-- Cursor in upper two thirds of screen.
				Result := screen.virtual_bottom - y_pos - a_positioned.height - border_size
			else
					-- Cursor in lower third of screen.
				Result := y_pos - border_size
			end
			Result := Result.min (choice.required_height)
		end

	calculate_completion_list_width (a_positioned: EV_POSITIONED): INTEGER
			-- Determine the width the popup dialog should have
		require
			a_positioned_not_void: a_positioned /= Void
		do
			Result := (create {EV_SCREEN}).width.min (a_positioned.width)
		end

note
	copyright:	"Copyright (c) 1984-2025, Eiffel Software"
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
