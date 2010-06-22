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

	SHARED_DEBUGGER_MANAGER

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

	start_debugger (a_dm: DEBUGGER_MANAGER; a_arguments: STRING; a_working_directory: STRING; a_ignore_breakpont: BOOLEAN)
			-- Start `a_dm', which is a debugger manager by launching
			-- the debuggee in `a_working_directory'.
			-- `a_ignore_breakpoint' indicates if break points should be ignored.
		require
			a_dm /= Void
		local
			ctlr: DEBUGGER_CONTROLLER
			wdir: STRING
			param: DEBUGGER_EXECUTION_RESOLVED_PROFILE
			prof: DEBUGGER_EXECUTION_PROFILE
		do
			remove_debugger_session
			if wdir = Void or else wdir.is_empty then
				wdir := Eiffel_project.lace.directory_name
					--Execution_environment.current_working_directory
			end
			ctlr := a_dm.controller

			create prof.make
			prof.set_arguments (a_arguments)
			prof.set_working_directory (wdir)
			a_dm.set_execution_ignoring_breakpoints (a_ignore_breakpont)
			a_dm.set_catcall_detection_in_console (False)
			a_dm.set_catcall_detection_in_debugger (False)
			create param.make_from_profile (prof)
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

feature -- Evaluation

	evaluated_value_from_debugger (a_dm: DEBUGGER_MANAGER; a_expression: EPA_EXPRESSION): EPA_EXPRESSION_VALUE
			-- Value of `a_expression' evaluated through debugger
		do
			Result := evaluated_string_from_debugger (a_dm, a_expression.text)
		end

	evaluated_string_from_debugger (a_dm: DEBUGGER_MANAGER; a_expression: STRING): EPA_EXPRESSION_VALUE
			-- Value of `a_expression' evaluated through debugger
		do
			Result := expression_value_from_dump (a_dm.expression_evaluation_with_assertion_checking (a_expression, True), a_expression)
		end

	expression_value_from_dump (a_dump_value: detachable DUMP_VALUE; a_expression_text: STRING): EPA_EXPRESSION_VALUE
			-- Expression value from `a_dump_value'
		local
			l_address: DBG_ADDRESS
			l_dtype: CLASS_C
			l_dtype_id: INTEGER
			l_system: SYSTEM_I
		do
			if a_dump_value = Void or else a_dump_value.is_invalid_value then
				create {EPA_NONSENSICAL_VALUE} Result

			elseif a_dump_value.is_type_boolean then
				create {EPA_BOOLEAN_VALUE} Result.make (a_dump_value.output_for_debugger.to_boolean)

			elseif a_dump_value.is_type_integer_32 then
				create {EPA_INTEGER_VALUE} Result.make (a_dump_value.output_for_debugger.to_integer)

			elseif a_dump_value.is_void then
				create {EPA_VOID_VALUE} Result.make

			elseif a_dump_value.is_type_object then
				l_dtype := a_dump_value.dynamic_class

				if l_dtype /= Void then
					l_dtype_id := l_dtype.class_id
					l_system := system
					if l_dtype_id = l_system.string_32_id or else l_dtype_id = l_system.string_8_id then
						l_address := a_dump_value.address
						create {EPA_STRING_VALUE} Result.make (l_address.physical_addr (l_address).as_string, a_dump_value.string_representation)

					elseif l_dtype_id = l_system.boolean_class.compiled_representation.class_id then
						create {EPA_BOOLEAN_VALUE} Result.make (debugger_manager.expression_evaluation (a_expression_text + once ".out").output_for_debugger.to_boolean)

					elseif
						l_dtype_id = l_system.integer_32_class.compiled_representation.class_id or else
						l_dtype_id = l_system.integer_8_class.compiled_representation.class_id or else
						l_dtype_id = l_system.integer_16_class.compiled_representation.class_id or else
						l_dtype_id = l_system.integer_64_class.compiled_representation.class_id or else
						l_dtype_id = l_system.natural_32_class.compiled_representation.class_id or else
						l_dtype_id = l_system.natural_8_class.compiled_representation.class_id or else
						l_dtype_id = l_system.natural_16_class.compiled_representation.class_id or else
						l_dtype_id = l_system.natural_64_class.compiled_representation.class_id then
						create {EPA_INTEGER_VALUE} Result.make (debugger_manager.expression_evaluation (a_expression_text + once ".out").output_for_debugger.to_integer)
					end
				end
				if Result = Void then
					l_address := a_dump_value.address
					create {EPA_REFERENCE_VALUE} Result.make (l_address.physical_addr (l_address).as_string, system.any_type)
				end
			else
				check False end
			end
		end

end
