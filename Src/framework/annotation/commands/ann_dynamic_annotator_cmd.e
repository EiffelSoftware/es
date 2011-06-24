note
	description: "Command to collect annotations through dynamic means"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_DYNAMIC_ANNOTATOR_CMD

inherit
	ANN_COMMAND

	EPA_DEBUGGER_UTILITY

	SHARED_WORKBENCH

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current command.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Basic operations

	execute
			-- Execute Current command
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_expressions: DS_HASH_SET [EPA_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_exp: EPA_AST_EXPRESSION
		do
				-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, config.root_class)

				-- Setup the expressions to evaluate.
			l_class := config.locations.first.context_class
			l_feature := config.locations.first.feature_
			create l_exp.make_with_text (l_class, l_feature, "i + 5", l_class)

			create l_expressions.make (2)
			l_expressions.set_equality_tester (expression_equality_tester)
			l_expressions.force_last (l_exp)

				-- Register expression evaluation to break points.
			create l_bp_mgr.make (l_class, l_feature)
			l_bp_mgr.set_breakpoint_with_expression_and_action (3, l_expressions, agent on_expression_evalauted)
			l_bp_mgr.toggle_breakpoints (True)

				-- Start program execution in debugger.
			start_debugger (debugger_manager, "", config.working_directory, {EXEC_MODES}.run, False)

				-- Remove the last debugging session.
			remove_debugger_session
		end

feature{NONE} -- Implementation

	on_expression_evalauted (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when expressions are evaluated at breakpoint `a_bp'.
			-- `a_state' is a set of expression evaluations.
		do
			io.put_string ("------------------------%N")
			io.put_string (a_state.debug_output)
			io.put_string ("%N"
			)
		end

end
