note
	description: "Summary description for {AFX_FIX_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_REPOSITORY

inherit

    AFX_OBJECT_TUNER_FACTORY

    KL_SHARED_FILE_SYSTEM

    ES_SHARED_PROMPT_PROVIDER

    AFX_SHARED_SESSION

    SHARED_TEST_SERVICE

    AFX_SHARED_TEST_ID_CODEC

    SHARED_FIX_ID

create
    make

feature

    make (an_exception: AFX_TEST_INVOCATION_EXCEPTION)
    		-- initialize object
    	do
    	    exception := an_exception
    	    create exception_positions.make_default
    	    create fix_operations.make_default
    	    create fixes.make_default
    	    create involved_classes.make_default

    	    	-- reset global fix id
    	    reset_global_fix_id

    	    is_healthy := True
    	end

feature -- Access

	exception: AFX_TEST_INVOCATION_EXCEPTION
			-- the exception to be solved

	exception_positions: DS_ARRAYED_LIST[AFX_EXCEPTION_POSITION]
			-- the exception positions in the exception trace

	fix_operations: DS_ARRAYED_LIST [AFX_FIX_OPERATION_I]
			-- the possible fix operations

	fixes: DS_ARRAYED_LIST [AFX_FIX_INFO_I]
			-- all the possible fixes, whose `exception_position' and `fix_operation' are coming from the above two lists

	involved_classes: DS_ARRAYED_LIST [CLASS_C]
			-- the classes change when these fixes are all applied

feature -- Status report

	is_healthy: BOOLEAN assign set_health_state
			-- is the repository in good condition?

	is_last_copy_successful: BOOLEAN
			-- is last class file successfully copied?

feature -- Set state

	set_health_state (a_state: BOOLEAN)
			-- set the health state of repository
		do
		    is_healthy := a_state
		end

feature -- Operation

	get_exception_positions
			-- put basic exception position in the program into `exception_positions'
		require
		    exception_is_analysable: exception.is_analysable
		    fix_positions_empty: exception_positions.is_empty
		    is_healthy: is_healthy
		do
		    exception.get_exception_position (exception_positions)

		    if exception_positions.is_empty then
		        set_health_state (False)
		    end
		end

	resolve_exception_position_info
			-- resolve detailed location according to the exception trace
		require
		    is_healthy: is_healthy
		local
		    l_is_successful: BOOLEAN
		    l_exception_position: AFX_EXCEPTION_POSITION
		do
		    l_is_successful := True
		    from
		        exception_positions.start
		    until
		        exception_positions.after or not l_is_successful
		    loop
		        l_exception_position := exception_positions.item_for_iteration

	            l_exception_position.resolve_e_feature

	            if l_exception_position.e_feature /= Void then

		            l_exception_position.resolve_breakpoint_info
	            	if l_exception_position.breakpoint_info = Void then
	            	    l_is_successful := False
	            	end
	        	else
	        	    l_is_successful := False
	        	end

		        exception_positions.forth
		    end

		    set_health_state (l_is_successful)
		end

	mark_relevant_exception_positions
			-- mark which fix positions are relevant
			-- we don't eliminate the irrelevant ones, since they may be useful in identifying involved objects
			-- TODOMP: distinguish library classes from application classes
		require
		    is_healthy: is_healthy
		local
		    l_exception_positions: like exception_positions
		    l_class: attached CLASS_C
		    i: INTEGER
		    l_fp: AFX_EXCEPTION_POSITION
		    l_has_relevant_fp: BOOLEAN
		do
		    l_exception_positions := exception_positions

		    if not l_exception_positions.is_empty then

		        	-- the class of the test case
		        l_class := l_exception_positions.last.e_feature.associated_class

		        	-- mark all positions relevant, except for those in test-case classes
		        from
		            i := 1
		        until
		            	-- skip the test case feature
		            i = l_exception_positions.count
		        loop
		            l_fp := l_exception_positions.at(i)
	            	if i = 1 then
   		       	        if exception.exception.code /= {EXCEP_CONST}.Precondition
   		       	        		and then not (l_fp.e_feature.associated_class ~ l_class) then
   		       	        		    -- the top feature at call stack is relevant, if not precondition violation and it's not the test case class
   		       	        	l_fp.is_relevant := True
   		       	        	l_has_relevant_fp := True
   		       	        end
   		       	    else
   		       	        if not (l_fp.e_feature.associated_class ~ l_class) then
   		       	        	l_fp.is_relevant := True
   		       	        	l_has_relevant_fp := True
   		       	        end
	            	end

	            	i := i + 1
		        end -- loop
		    end

		    	-- we only continue if there is some relevant fix position to work on.
		    set_health_state (l_has_relevant_fp)
		end

--	resolve_fix_positions
--			-- compute the positions where fixes should be applied
--		local
--		    l_exception_positions: like exception_positions
--		    l_exception_pos: AFX_EXCEPTION_POSITION
--		    l_fix_position: AST_EIFFEL
--		do
--		    l_exception_positions := exception_positions

--		    from
--		        l_exception_positions.start
--		    until
--		        l_exception_positions.after or not is_healthy
--		    loop
--		        l_exception_pos := l_exception_positions.item_for_iteration
--		        l_exception_pos.resolve_fix_position
--		    end
--		end

	collect_relevant_objects_at_fix_positions
			-- for each fix position, collect all the possible relevant objects
		local
		    l_exception_positions: like exception_positions
			l_caller_index: INTEGER
			l_callee_index: INTEGER
			l_caller_position: AFX_EXCEPTION_POSITION
			l_callee_position: detachable AFX_EXCEPTION_POSITION
		do
		    l_exception_positions := exception_positions

			from
			    l_caller_index := l_exception_positions.count - 1 		-- skip the test case feature
			until
			    l_caller_index = 0
			loop
			    l_caller_position := l_exception_positions.at (l_caller_index)
			    if l_caller_position.is_relevant then
			    		-- compute the callee
		            l_callee_index := l_caller_index - 1
		            if l_callee_index > 0 then
		                l_callee_position := l_exception_positions.at (l_callee_index)
		            else
		                l_callee_position := Void
		            end

		            	-- compute relevant objects in caller
		            l_caller_position.collect_relevant_objects (l_callee_position)
			    end

			    l_caller_index := l_caller_index - 1
			end
		end

	generate_and_register_fixes
			-- generate possible fixes to tune relevant objects
		local
		    l_exception_positions: like exception_positions
		    l_position: AFX_EXCEPTION_POSITION
		    l_feature: E_FEATURE
		    l_relevant_obj: HASH_TABLE[TYPE_A, STRING]
		    l_obj_name: STRING
		    l_obj_type: TYPE_A
			l_tuner: detachable AFX_OBJECT_TUNER
			l_operations: DS_LINEAR [AFX_FIX_OPERATION_INSERTION]
			l_remove_index: INTEGER
		do
		    l_exception_positions := exception_positions

		    from
		        l_exception_positions.start
		    until
		        l_exception_positions.after
		    loop
		        l_position := l_exception_positions.item_for_iteration

				if l_position.is_relevant then
    		        l_relevant_obj := l_position.relevant_objects
    		        l_feature := l_position.e_feature

    				from
    				    l_relevant_obj.start
    				until
    				    l_relevant_obj.after
    				loop
    				    l_obj_name := l_relevant_obj.key_for_iteration
    				    l_obj_type := l_relevant_obj.item_for_iteration

    						-- get suitable object tuner for the objects
    					if l_obj_type.is_integer or else l_obj_type.is_natural then
    						l_tuner := integer_number_tuner
    					elseif l_obj_type.is_real_32 or else l_obj_type.is_real_64 then
    					    l_tuner := real_number_tuner
    					elseif l_obj_type.is_reference then
    					    l_tuner := reference_tuner
    					elseif l_obj_type.is_boolean then
    					    l_tuner := boolean_tuner
    					else	-- other types not supported yet
    					    l_tuner := Void
    					end

    						-- register the fixes generated by the tuner
    					if l_tuner /= Void then
    					    l_tuner.generate_tunes (l_obj_name, l_obj_type, l_feature)
    					    l_operations := l_tuner.last_tunes

    						fix_operations.append_last (l_operations)
    					    register_fixes (l_position, l_operations)
    					end

    				    l_relevant_obj.forth
    				end	-- loop
				end	-- l_position.is_relevant

				exception_positions.forth
		    end

--				-- leave only 2 fixes for testing purpose
--			from l_remove_index := fixes.count
--			until l_remove_index <= 2
--			loop
--			    fixes.remove (l_remove_index)
--			    l_remove_index := l_remove_index - 1
--			end

		    	-- we only continue if there is some fix generated
		    if fixes.is_empty then
		        set_health_state (False)
		    else
				codec.set_fix_count (fixes.count.to_natural_32)
		    end
		end

	register_fixes (a_position: AFX_EXCEPTION_POSITION; an_op_list: DS_LINEAR [AFX_FIX_OPERATION_INSERTION])
			-- register fixes as tuples of fix position and fix operations
		local
		    l_simple_fix: AFX_SIMPLE_FIX_INFO
		do
		    from
		        an_op_list.start
		    until
		        an_op_list.after
		    loop
		        create l_simple_fix.make (a_position, an_op_list.item_for_iteration)
		        a_position.fix_operations.force_last (l_simple_fix)
				fixes.force_last (l_simple_fix)

				an_op_list.forth
		    end

		end

	collect_involved_classes
			-- collect the classes which would be modified during autoFixing
		require
		    is_healthy: is_healthy
		local
		    l_exception_positions: like exception_positions
		    l_position: AFX_EXCEPTION_POSITION
		do
		    l_exception_positions := exception_positions

			from
			    l_exception_positions.start
			until
			    l_exception_positions.after
			loop
			    l_position := l_exception_positions.item_for_iteration

					-- only relevant classes
				if l_position.is_relevant then
				    involved_classes.force_last (l_position.e_feature.associated_class)
				end

			    l_exception_positions.forth
			end
		ensure
		    non_empty_classes_list: not involved_classes.is_empty
		end

	backup_involved_classes
			-- backup involved class files
		require
		local
		    l_session: like session
		    l_involved_classes: like involved_classes
		    l_position: AFX_EXCEPTION_POSITION
		    l_class_c: CLASS_C
			l_file_system: KL_FILE_SYSTEM
			l_project_directory: PROJECT_DIRECTORY
			l_autofix_backup_directory_name: DIRECTORY_NAME
			l_old_file_name: FILE_NAME
			l_new_file_name: FILE_NAME
			l_log_file_name: FILE_NAME
			l_file: detachable KL_TEXT_OUTPUT_FILE
			l_retried: BOOLEAN
		do
		    if not l_retried then
    		    l_session := session
    		    check l_session /= Void end
    			l_file_system := file_system

    				-- prepare backup directory name
    			l_project_directory := test_suite.service.eiffel_project.project_directory
    			l_autofix_backup_directory_name := l_project_directory.backup_path.twin
    			l_autofix_backup_directory_name.extend ("auto_fix")

    				-- prepare the logging file
    			create l_log_file_name.make_from_string (l_autofix_backup_directory_name)
    			l_log_file_name.set_file_name ("copied_file_list")
    			l_log_file_name.add_extension ("log")

    			create l_file.make (l_log_file_name)
    			l_file.recursive_open_write
    			if l_file.is_open_write then

        			l_involved_classes := involved_classes
        			check l_involved_classes /= Void and then not l_involved_classes.is_empty end

       			    	-- number of files
       			    l_file.put_integer (l_involved_classes.count)
       			    l_file.put_new_line

       			    is_last_copy_successful := True

           			from
           			    l_involved_classes.start
           			until
           			    l_involved_classes.after or not is_last_copy_successful
           			loop
           			    l_class_c := l_involved_classes.item_for_iteration

           					-- old file name (including file path)
           				create l_old_file_name.make_from_string (l_class_c.file_name)

           					-- new file name
           				create l_new_file_name.make_from_string (l_autofix_backup_directory_name)
           				l_new_file_name.set_file_name (l_class_c.external_name)
           				l_new_file_name.add_extension ("bak")

           					-- copy
           				guaranteed_file_copy (l_old_file_name, l_new_file_name)

						if is_last_copy_successful then
               					-- log copy
               				l_file.put_string (l_old_file_name)
               				l_file.put_new_line
               				l_file.put_string ("---> " + l_new_file_name)
               				l_file.put_new_line

               			    l_involved_classes.forth
						end
        			end

    				l_file.flush
    				l_file.close
    				l_file := Void

    					-- when not successful, delete the log file also
    				if not is_last_copy_successful then
    				    prompts.show_warning_prompt ("Cannot backup file " + l_old_file_name + ", autoFix quitting...",
						    					Void, Void)
    				    l_file_system.delete_file (l_log_file_name)
    				    set_health_state (False)
    				end
    			else
    			    prompts.show_warning_prompt ("Cannot create list of changed files, autoFix quitting...",
						    					Void, Void)
    			    l_session.error_handler.raise_error ("Error creating %"copied_file_list.log%" file.")
    			end
    		end

    	rescue
    	    l_retried := True

			if l_file /= Void then l_file.close end
    		l_file_system.delete_file (l_log_file_name)

			set_health_state (False)

			retry
		end

	guaranteed_file_copy (a_from, a_to: STRING)
			-- make sure the file copy really happens, and update the `is_last_copy_successful' state
		local
			l_file_system: KL_FILE_SYSTEM
			l_file: KL_TEXT_INPUT_FILE
			l_file_length: INTEGER
		do
		    is_last_copy_successful := False

		    l_file_system := file_system

   			create l_file.make (a_from)
   			l_file.open_read
   			if l_file.is_open_read then
   			    	-- source file exists
   				l_file.close
   			    l_file_length := l_file.count

   				l_file_system.copy_file (a_from, a_to)

   				create l_file.make (a_to)
   				l_file.open_read
   				if l_file.is_open_read then
   				    	-- dest file exists
   				    l_file.close

   				    if l_file_length = l_file.count then
   				        is_last_copy_successful := True
   				    end
   				end
   			end
		end

	restore_involved_classes
			-- copy the backed up class files back to their positions
		local
		    l_session: like session
		    l_exception_positions: like exception_positions
		    l_position: AFX_EXCEPTION_POSITION
		    l_class_c: CLASS_C
			l_file_system: KL_FILE_SYSTEM
			l_project_directory: PROJECT_DIRECTORY
			l_autofix_backup_directory_name: DIRECTORY_NAME
			l_old_file_name: FILE_NAME
			l_new_file_name: FILE_NAME
			l_log_file_name: FILE_NAME
			l_file: KL_TEXT_INPUT_FILE
			l_line_from, l_line_to: STRING
			l_line_no: STRING
			l_no_of_files: INTEGER
			i: INTEGER
		do
		    l_session := session
		    check l_session /= Void end
			l_file_system := file_system

				-- prepare backup directory name
			l_project_directory := test_suite.service.eiffel_project.project_directory
			l_autofix_backup_directory_name := l_project_directory.backup_path.twin
			l_autofix_backup_directory_name.extend ("auto_fix")

				-- open the log file
			create l_log_file_name.make_from_string (l_autofix_backup_directory_name)
			l_log_file_name.set_file_name ("copied_file_list")
			l_log_file_name.add_extension ("log")

			check is_last_copy_successful = True end

			create l_file.make (l_log_file_name)
			l_file.open_read
			if l_file.is_open_read then
				l_file.read_line
				l_line_no := l_file.last_string.twin
				l_no_of_files := l_line_no.to_integer

			    from i := 1
			    until i > l_no_of_files or not is_last_copy_successful
			    loop
			        l_file.read_line
			        l_line_from := l_file.last_string.twin
			        l_file.read_new_line

			        l_file.read_line
			        l_line_to := l_file.last_string.twin
			        l_line_to := l_line_to.substring (6, l_line_to.count)
			        l_file.read_new_line

			        guaranteed_file_copy (l_line_to, l_line_from)
			        l_file_system.delete_file (l_line_to)
			        i := i + 1
			    end

				l_file.close
				l_file := Void
			else
			    	-- backup log file destroyed. Warn user of possible manual restore
				is_last_copy_successful := False
			end

			if not is_last_copy_successful then
    		    prompts.show_warning_prompt ("Cannot restore changed files...",
					    					Void, Void)
--				set_health_state (False)

--    		    l_session.error_handler.raise_error ("Error creating %"copied_file_list.log%" file.")
    		else
				l_file_system.delete_file (l_log_file_name)
			end

		end

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
