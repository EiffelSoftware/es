indexing
	description: "Objects that display all CDD relevant output"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_OUTPUT_TOOL

inherit

	EB_OUTPUT_TOOL
		rename
			title_for_pre as title
		redefine
			build_interface,
			title,
			widget,
			internal_recycle
		end

create
	make

feature {NONE} -- Initialization

	build_interface is
			-- Initialize widgets and subscribe as observer
		local
			l_manager: CDD_MANAGER
		do
			create widget
			widget.set_style ({EV_FRAME_CONSTANTS}.ev_frame_lowered)
			create text_area.make (develop_window)
			widget.extend (text_area.widget)
			text_area.set_read_only (True)
			internal_append_text_action := agent append_text
			internal_append_status_update_action := agent append_status_update
			internal_append_routine_update_action := agent append_routine_updates
			l_manager := develop_window.eb_debugger_manager.cdd_manager
			l_manager.output_actions.extend (internal_append_text_action)
			l_manager.status_update_actions.extend (internal_append_status_update_action)
			l_manager.test_suite.test_routine_update_actions.extend (internal_append_routine_update_action)
		end

feature -- Access

	title: STRING is "CDD Output"
			-- Title for `Current'

	widget: EV_FRAME
			-- Frame containing output window

feature {NONE} -- Implementation

	internal_append_text_action: PROCEDURE [like Current, TUPLE [STRING]]
			-- Agent for `append_text'

	internal_append_status_update_action: PROCEDURE [like Current, TUPLE [CDD_STATUS_UPDATE]]
			-- Agent for `append_status_update'

	internal_append_routine_update_action: PROCEDURE [like Current, TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]
			-- Agent for `append_routine_update_action'

feature {NONE} -- Implementation

	append_text (a_text: STRING) is
			-- Append `a_text' to `text_area'.
		require
			a_text_not_void: a_text /= Void
		do
			text_area.text_displayed.add (a_text)
			update_text_area
		end

	append_status_update (an_update: CDD_STATUS_UPDATE) is
			-- Append message for `an_update' to `text_area'.
		require
			an_update_not_void: an_update /= Void
		do
			if an_update.code = {CDD_STATUS_UPDATE}.executor_step_code then
				if develop_window.eb_debugger_manager.cdd_manager.background_executor.is_compiling then
					--text_area.clear_window
				end
			end
		end

	append_routine_updates (some_updates: DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]) is
			-- Append messages for each update in `some_updates' to `text_area'.
		require
			valid_updates: (some_updates /= Void) implies (not some_updates.has (Void))
		do
			if some_updates /= Void then
				some_updates.do_all (agent append_routine_update)
			end
		end

	append_routine_update (an_update: CDD_TEST_ROUTINE_UPDATE) is
			-- Append message for `an_update' to `text_area'.
		require
			an_update_not_void: an_update /= Void
		local
			l_last: CDD_TEST_EXECUTION_RESPONSE
			l_formatter: CLICKABLE_TEXT
		do
			if an_update.is_changed then
				l_formatter := text_area.text_displayed
				l_formatter.add ("Tested ")
				append_routine (an_update.test_routine)
				l_last := an_update.test_routine.outcomes.last
				if l_last.is_fail then
					l_formatter.add (" (FAIL)")
				elseif l_last.is_pass then
					l_formatter.add (" (PASS)")
				else
					l_formatter.add (" (UNRESOLVED)")
				end
				l_formatter.add_new_line
			end
			update_text_area
		end

	append_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Append `a_routine' to `text_area'.
		require
			a_routine_not_void: a_routine /= Void
		local
			l_formatter: CLICKABLE_TEXT
			l_class: EIFFEL_CLASS_C
			l_feature: E_FEATURE
		do
			l_formatter := text_area.text_displayed
			if a_routine.test_class.compiled_class /= Void then
				l_class := a_routine.test_class.compiled_class
				l_formatter.add_class (l_class.original_class)
				l_feature := l_class.feature_with_name (a_routine.name)
			else
				l_formatter.add (a_routine.test_class.test_class_name)
			end
			l_formatter.add (".")
			if l_feature /= Void then
				l_formatter.add_feature (l_feature, a_routine.name)
			else
				l_formatter.add (a_routine.name)
			end
		end

	update_text_area is
			-- Remove top lines in `text_area' and scroll to end.
		do
			text_area.scroll_to_end_when_ready
		end

	internal_recycle is
			-- Unsubscribe agents.
		local
			l_manager: CDD_MANAGER
		do
			l_manager := develop_window.eb_debugger_manager.cdd_manager
			l_manager.output_actions.prune (internal_append_text_action)
			l_manager.status_update_actions.prune (internal_append_status_update_action)
			l_manager.test_suite.test_routine_update_actions.prune (internal_append_routine_update_action)
			Precursor
		end


invariant
	internal_append_routine_update_action_not_void: internal_append_routine_update_action /= Void
	internal_append_status_update_action_not_void: internal_append_status_update_action /= Void
	internal_append_text_action_not_void: internal_append_text_action /= Void

end
