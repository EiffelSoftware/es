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

	CONF_ACCESS

create
	make

feature {NONE} -- Initialization

	make (a_cdd_manager: like cdd_manager) is
			-- Initialize `Current' with `a_cdd_manager'.
		require
			a_cdd_manager_not_void: a_cdd_manager /= Void
		do
			cdd_manager := a_cdd_manager
			create root_class_printer.make (cdd_manager.test_suite)
			internal_reset_agent := agent reset_system (Void)
		ensure
			cdd_manager_set: cdd_manager = a_cdd_manager
		end

feature -- Access

	cdd_manager: CDD_MANAGER
			-- CDD manager

	debugger_manager: DEBUGGER_MANAGER is
			-- Debugger manager for executing test case
		do
			Result := run_project_cmd.eb_debugger_manager
		ensure
			not_void: Result /= Void
		end

	application_running: BOOLEAN is
			-- Is `debugger_manager' currently executing an application?
		do
			Result := debugger_manager.application_initialized and then
				debugger_manager.application.is_running
		ensure
			definition: Result = (debugger_manager.application_initialized and then
				debugger_manager.application.is_running)
		end

	can_start: BOOLEAN is
			-- Can we start debugging something?
		do
			Result := not (cdd_manager.project.is_read_only or
				cdd_manager.project.is_compiling or application_running)
		ensure
			definition: Result = not (cdd_manager.project.is_read_only or
				cdd_manager.project.is_compiling or application_running)
		end

	current_test_routine: CDD_TEST_ROUTINE
			-- Test routine currently beeing debugged

	is_running: BOOLEAN
			-- Are we currently debugging a test routine?

feature -- Basic functionality

	start (a_test_routine: like current_test_routine) is
			-- Start running `a_test_routine' in debugger.
		require
			can_start: can_start
			a_test_routine_not_void: a_test_routine /= Void
		local
			l_root: CONF_ROOT
			l_dbg_data: DEBUGGER_DATA
			l_eiffel_class: EIFFEL_CLASS_C
		do
			current_test_routine := a_test_routine
			root_class_printer.print_root_class (a_test_routine)
			if root_class_printer.last_print_succeeded then
				l_root := conf_factory.new_root (Void, "CDD_ROOT_CLASS", "make", False)
				is_running := True
				set_root_class (l_root)
				cdd_manager.status_update_actions.call ([update_step])
				melt_project_cmd.execute_and_wait
				if cdd_manager.project.successful and is_running then
					debugger_manager.application_quit_actions.extend (internal_reset_agent)
					l_dbg_data := debugger_manager.debugger_data
					l_eiffel_class := a_test_routine.test_class.compiled_class
						-- Should not be void since we have just recompiled the system
					check
						test_class_not_void: l_eiffel_class /= Void
					end
					breakpoint_feature := l_eiffel_class.feature_with_name (a_test_routine.name)
						-- Should not be void because of recompilation too
					check
						breakpoint_feature_not_void: breakpoint_feature /= Void
					end
					if l_dbg_data.is_breakpoint_set (breakpoint_feature, 1) and then l_dbg_data.is_breakpoint_enabled (breakpoint_feature, 1) then
							-- Set to `Void' so breakpoint won't be disabled after debugging
						breakpoint_feature := Void
					else
						l_dbg_data.enable_breakpoint (breakpoint_feature, 1)
					end
					run_project_cmd.execute
				else
					cancel
				end
			else
				cdd_manager.status_update_actions.call ([update_step])
			end
		end

	cancel is
			-- Kill application and reset root class
		require
			debugging: is_running
		do
			if cdd_manager.project.is_compiling then
				project_cancel_cmd.execute
			elseif application_running then
				debugger_manager.application.kill
			end
			reset_system (Void)
		ensure
			not_debugging: not is_running
		end

feature {NONE} -- Implementation

	reset_system (a_dbg_manager: DEBUGGER_MANAGER) is
			-- Reset all changes made to debug and initiate compilation
		require else
			debugging: is_running
			old_root_not_void: old_root /= Void
		do
			if breakpoint_feature /= Void then
				debugger_manager.debugger_data.disable_breakpoint (breakpoint_feature, 1)
				breakpoint_feature := Void
			end
			if debugger_manager.application_quit_actions.has (internal_reset_agent) then
				debugger_manager.application_quit_actions.prune (internal_reset_agent)
			end
			set_root_class (old_root)
			current_test_routine := Void
			is_running := False
			cdd_manager.status_update_actions.call ([update_step])
			melt_project_cmd.execute
		end

	set_root_class (a_root: like old_root) is
			-- Set `new_root' as new root class and store configuration.
		require
			debugging: is_running
			a_root_not_void: a_root /= Void
		local
			l_target: CONF_TARGET
		do
			l_target := cdd_manager.project.system.universe.target
			old_root := l_target.root
			l_target.set_root (a_root)
			l_target.system.store
		ensure
			old_root_set: old_root = old cdd_manager.project.system.universe.target.root
		end

	internal_reset_agent: PROCEDURE [like Current, TUPLE]
			-- Agent called when application has terminated

	old_root: CONF_ROOT
			-- Old root class

	breakpoint_feature: E_FEATURE
			-- Feature for which a breakpoint has been set

	root_class_printer: CDD_ROOT_CLASS_PRINTER
			-- Printer for creating root class

	conf_factory: CONF_FACTORY is
			-- Factory for creating new roots
		once
			create Result
		end

	update_step: CDD_STATUS_UPDATE is
			-- Update used after each step of `Current'
		once
			create Result.make_with_code ({CDD_STATUS_UPDATE}.debugger_step_code)
		ensure
			not_void: Result /= Void
		end

invariant

	cdd_manager_not_void: cdd_manager /= Void
	root_class_printer_not_void: root_class_printer /= Void
	debugging_equals_current_test_routine_not_void: is_running = (current_test_routine /= Void)
	internal_reset_agent_not_void: internal_reset_agent /= Void
	valid_breakpoint_feature: (breakpoint_feature /= Void) implies not (
		breakpoint_feature.is_attribute or breakpoint_feature.is_constant or
		breakpoint_feature.is_unique or breakpoint_feature.is_deferred)

end
