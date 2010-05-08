note
	description: "Debugger utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DEBUGGER_UTILITY

inherit
	SHARED_EIFFEL_PROJECT

	SHARED_WORKBENCH

	EIFFEL_LAYOUT

feature -- Access

	call_stack_index (a_dm: DEBUGGER_MANAGER; a_feature_name: STRING): INTEGER
			-- 1-based Index of the call stack element which represents
			-- feature with `a_feature_name'.
			-- `a_dm' is the debugger manager
			-- 0 if no such call stack element is found.
		local
			l_stack: EIFFEL_CALL_STACK
			l_element: CALL_STACK_ELEMENT
			i: INTEGER
			l_count: INTEGER
			l_done: BOOLEAN
		do
			l_stack := a_dm.application_status.current_call_stack
			l_count := l_stack.count
			from
				i := 1
			until
				i > l_count or Result > 0
			loop
				l_element := l_stack.i_th (i)
				if l_element.routine_name ~ a_feature_name then
					Result := i
				end
				i := i + 1
			end
		end

feature -- Basic operations

	start_debugger (a_dm: DEBUGGER_MANAGER; a_arguments: STRING; a_working_directory: STRING)
			-- Start `a_dm', which is a debugger manager by launching
			-- the debuggee in `a_working_directory'.
		require
			a_dm /= Void
		local
			ctlr: DEBUGGER_CONTROLLER
			wdir: STRING
			param: DEBUGGER_EXECUTION_PARAMETERS
		do
			remove_debugger_session
			if wdir = Void or else wdir.is_empty then
				wdir := Eiffel_project.lace.directory_name
						--Execution_environment.current_working_directory
			end
			ctlr := a_dm.controller
			create param
			param.set_arguments (a_arguments)
			param.set_working_directory (a_working_directory)
			a_dm.set_execution_ignoring_breakpoints (False)
			a_dm.set_catcall_detection_in_console (False)
			a_dm.set_catcall_detection_in_debugger (False)
			ctlr.debug_application (param, {EXEC_MODES}.run)
		end

	remove_debugger_session
			-- Remove the debugger serssion file for currently loaded projects.
		local
			l_ver: STRING
			l_target_name: STRING
			l_file_name: FILE_NAME
			l_file: RAW_FILE
		do
			l_target_name := workbench.lace.target.name
			if attached (create {USER_OPTIONS_FACTORY}).mapped_uuid (workbench.lace.file_name) as l_uuid then
				l_ver := l_uuid.out
			else
				l_ver := workbench.lace.target.system.uuid.out
			end
			create l_file_name.make_from_string (eiffel_layout.session_data_path)
			l_ver.replace_substring_all ("-", "")
			l_file_name.set_file_name (l_ver + "." + l_target_name + ".dbg.ses")
			create l_file.make (l_file_name)
			if l_file.exists then
				l_file.delete
			end
		end

	remove_breakpoint (a_dm: DEBUGGER_MANAGER; a_class: CLASS_C)
			-- Remove user break points in `a_class' through debugger manager `a_dm'.
		do
			a_dm.breakpoints_manager.remove_user_breakpoints_in_class (a_class)
			a_dm.breakpoints_manager.notify_breakpoints_changes
		end

end
