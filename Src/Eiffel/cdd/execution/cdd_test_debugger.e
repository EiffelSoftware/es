indexing
	description: "Objects that execute test routines in some debugger"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_DEBUGGER

inherit

	EB_SHARED_GRAPHICAL_COMMANDS
                export
                        {NONE} all
                end
create
	make

feature {NONE} -- Initialization

	make (a_project: like project) is
			--
		require
			a_project_not_void: a_project /= Void
		do
			project := a_project
			internal_run_agent := agent run_application
			internal_reset_agent := agent reset_root_class_and_recompile
		ensure
			project_set: project /= Void
		end

feature -- Access

	project: E_PROJECT
			-- Project beeing tested

	can_start: BOOLEAN is
			-- Can we start debugging something?
		do
			Result := not (project.is_read_only or
				project.is_compiling or
				run_project_cmd.eb_debugger_manager.application.is_running)
		ensure
			definition: Result = not (project.is_read_only or
				project.is_compiling or
				run_project_cmd.eb_debugger_manager.application.is_running)
		end

	current_test_routine: CDD_TEST_ROUTINE
			-- Test routine currently beeing debugged

	is_debugging: BOOLEAN
			-- Are we currently debugging a test routine?

feature -- Basic functionality

	start (a_test_routine: like current_test_routine) is
			--
		do

		end

	cancel is
			-- Kill application and reset root class
		require
			not_compiling: not project.is_compiling
			debugging: is_debugging
		do

			if run_project_cmd.eb_debugger_manager.application.is_running then
				run_project_cmd.eb_debugger_manager.application.kill
			end
		end

feature {NONE} -- Implementation

	run_application is
			-- If compiling has been successful, run application in debugger
		require
			debugging: is_debugging
			not_compiling: not project.is_compiling
			debugger_not_running: not run_project_cmd.eb_debugger_manager.application.is_running
		do
			if project.successful then
				run_project_cmd.execute
			else
				-- TODO: write back old root class and save config
			end
		end

	reset_root_class_and_recompile is
			--
		require
			debugging: is_debugging
			not_compiling: not project.is_compiling
			debugger_not_running: not run_project_cmd.eb_debugger_manager.application.is_running
		do

		end

	internal_run_agent: PROCEDURE [ANY, TUPLE]
			-- Agent beeing called when compiling is over

	internal_reset_agent: PROCEDURE [ANY, TUPLE]
			-- Agent beeing called when debugging is over

invariant

	project_not_void: project /= Void
	debugging_equals_current_test_routine_not_void: is_debugging = (current_test_routine /= Void)
	internal_run_agent_not_void: internal_run_agent /= Void
	internal_reset_agent: internal_reset_agent /= Void

end
