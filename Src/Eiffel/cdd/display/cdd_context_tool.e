indexing
	description: "Objects that visualize a test suite in a grid"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CONTEXT_TOOL

inherit

	EB_CONSTANTS
		export
			{NONE} all
		end

create
	make_with_tool

feature {NONE} -- Initialization

	make_with_tool (a_window: EB_DEVELOPMENT_WINDOW; a_tool: EB_CONTEXT_TOOL) is
			-- Set 'development_window' to 'a_window' list all available
			-- test cases in the test suite if testing is enabled.
		require
			a_window_not_void: a_window /= Void
		do
			development_window := a_window
			manager := development_window.eb_debugger_manager.cdd_manager
			internal_output_agent := agent append_output
			initialize

			manager.log_actions.extend (internal_output_agent)
		end

	initialize is
			-- Initialize all widgets used in 'Current'
		do
			create widget
			create output
			widget.extend (output)
		end

feature -- Access

	development_window: EB_DEVELOPMENT_WINDOW
			-- Development window in which widget is displayed

	widget: EV_VERTICAL_BOX
			-- Widget for displaying 'Current'

	manager: CDD_MANAGER
			-- Manager for test suite operations

feature -- Status setting

	append_output (an_output: STRING) is
			-- Append 'an_output' to output box and scroll to bottom.
		require
			an_output_not_void: an_output /= Void
		do
			output.append_text (an_output)
			if output.line_count > 100 then
				output.select_lines (1, output.line_count - 100)
				output.delete_selection
			end
			output.scroll_to_line (output.line_count)
		end

	recycle is
			-- Prune 'Current' from manager and tester and remove widgets.
		do
			manager.log_actions.prune (internal_output_agent)
		end


feature {NONE} -- Action implementation

	internal_output_agent: PROCEDURE [like Current, TUPLE [STRING]]
			-- Agent called when output is read from tester

feature {NONE} -- Implementation


	output: EV_TEXT
			-- Output from external processes

invariant
	development_window_not_void: development_window /= Void
	manager_not_void: manager /= Void
	widget_not_void: widget /= Void
	output_valid: output /= Void

end -- Class CDD_TEST_SUITE_TOOL
