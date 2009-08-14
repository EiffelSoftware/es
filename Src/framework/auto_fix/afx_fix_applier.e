note
	description: "Summary description for {AFX_FIX_APPLIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_APPLIER

inherit
	AFX_TASK

	AFX_SHARED_SESSION

	ES_SHARED_PROMPT_PROVIDER

	SHARED_TEST_SERVICE

	SHARED_AFX_FIX_REPOSITORY

	SHARED_EIFFEL_PARSER_WRAPPER

create
    make

feature -- Creation

	make
			-- initialization
		do
		end

feature -- execution

	start
			-- <Precursor>
		require else
		    fix_repository_healthy: repository.is_healthy
		do
			is_successful := True
		    is_executing := True
		    current_step := Collect_involved_classes_step
		end

	step
			-- <Precursor>
		local
		    l_session: detachable AFX_SESSION
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_proposer: AFX_FIX_PROPOSER
		    l_tests: DS_ARRAYED_LIST[attached TEST_I]
		    l_error_handler: AFX_ERROR_HANDLER_I
		do
		    l_session := session
		    check l_session /= Void end
		    l_error_handler := session.error_handler

		    if not is_cancel_requested and repository.is_healthy then
				inspect
					current_step

				when Collect_involved_classes_step then
					repository.collect_involved_classes

				when Backup_modify_compile_and_restore_step then
				    backup_modify_compile_and_restore

--				when Backup_involved_classes then
--					repository.backup_involved_classes

--				when Write_root_class_and_apply_fixes then
--        				-- prepare the list of all tests to be carried out
--        		    l_conf := l_session.conf
--        		    create l_tests.make_default
--        		    l_tests.append_last (l_conf.failing_tests)
--        		    l_tests.append_last (l_conf.regression_tests)

--				    write_root_class (l_tests)

--				    if not is_last_root_class_successful then
--				        cancel
--				    else
--					    apply_fixes
--				    end

--				when Compile_system_and_restore then
--				    l_proposer := l_session.fix_proposer
--					l_proposer.compile_project
--					if not l_proposer.last_compilation_successful then
--					    cancel
--					end

--						-- undo all the changes no matter the previous actions are successful or not
--				    write_root_class (Void)

--					repository.restore_involved_classes

				else
					l_error_handler.report_error_message ("Bad applier step code: " + current_step.out)
				end

    		    current_step := current_step + 1
    		    if current_step > Total_steps then
    		        is_finished := True
    		        if attached repository as l_repos and then l_repos.is_healthy then
    		            is_successful := True
    		        end
    		    end
    		end

    		if is_cancel_requested or not repository.is_healthy then
    			current_step := Total_steps + 1
    			is_executing := False
    			is_finished := True
    			is_successful := False

    			repository.set_health_state (False)
		    end
		end

	stop
			-- <Precursor>
		do

		end

	cancel
			-- <Precursor>
		do
		    is_cancel_requested := True
		end

feature -- Status report

	is_finished: BOOLEAN
			-- is task finished?

	is_cancel_requested: BOOLEAN
			-- should task be cancelled?

	is_successful: BOOLEAN
			-- is the execution successful?

	is_executing: BOOLEAN
			-- is the task executing?

	is_last_root_class_successful: BOOLEAN
			-- is last writing to root class successful?

feature -- Access

	source_writer: AFX_FIX_EVALUATOR_SOURCE_WRITER
			-- source writer to generate the new root class for evaluation
		once
		    create Result
		end

feature -- Operation

	backup_modify_compile_and_restore
			-- backup involved class files
			-- make necessary modification to the system, including adding new root feature and applying fixes
			-- compile the project
			-- restore the system state, whether or not the previous compile is successful
		local
		    l_repository: like repository
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_proposer: AFX_FIX_PROPOSER
		    l_tests: DS_ARRAYED_LIST[attached TEST_I]
		    l_error_handler: AFX_ERROR_HANDLER_I
		    l_retried: BOOLEAN
		do
		    if not l_retried then
    		    	-- backup
    		    l_repository := repository
    		    check l_repository /= Void end
    		    l_repository.backup_involved_classes

    		    l_session := session
    		    check l_session /= Void end
    		    l_conf := l_session.conf

    		    create l_tests.make_default
    		    l_tests.append_last (l_conf.failing_tests)
    		    l_tests.append_last (l_conf.regression_tests)

    		    	-- modify
    		    write_root_class (l_tests)

    		    if not is_last_root_class_successful then
    		        cancel
    		    else
    		        	-- apply fixes
    		        apply_fixes

    		        	-- compile
    		        l_proposer := l_session.fix_proposer
    		        l_proposer.compile_project

    		        if not l_proposer.last_compilation_successful then
    		            cancel
    		        end
    		    end
			end

		    	-- restore
		    write_root_class (Void)
		    l_repository.restore_involved_classes

		rescue
		    l_retried := True
		    retry
		end

	write_root_class (a_list: detachable DS_LINEAR [TEST_I])
			-- write new root class
		local
			l_dir: PROJECT_DIRECTORY
			l_file: KL_TEXT_OUTPUT_FILE
			l_file_name: FILE_NAME
		do
			is_last_root_class_successful := False

				-- create file if not exist
			l_dir := test_suite.service.eiffel_project.project_directory
			create l_file_name.make_from_string (l_dir.eifgens_cluster_path)
			l_file_name.set_file_name (source_writer.class_name.as_lower)
			l_file_name.add_extension ("e")
			create l_file.make (l_file_name)
			if not l_file.exists then
				test_suite.service.eiffel_project.system.system.force_rebuild
			end

				-- writing
			l_file.recursive_open_write
			if l_file.is_open_write then
				source_writer.write_source (l_file, a_list)
				is_last_root_class_successful := True
				l_file.flush
				l_file.close
			end
		end

	resolve_fix_positions_and_apply (a_table: HASH_TABLE [DS_ARRAYED_LIST[AFX_EXCEPTION_POSITION], CLASS_C])
			-- resolve the position where the fix should be applied
		local
		    l_repository: like repository
		    l_calculator: AFX_FIX_POSITION_CALCULATOR
		    l_list: DS_ARRAYED_LIST [AFX_EXCEPTION_POSITION]
		    l_pos: AFX_EXCEPTION_POSITION
		    l_class: CLASS_C
		    l_class_modifier: AFX_FIX_WRITER
		    l_class_ast: CLASS_AS
		    l_bkpt_ast: AST_EIFFEL
		    l_fix_position: detachable AST_EIFFEL
		    l_wrapper: EIFFEL_PARSER_WRAPPER
		    l_parser: EIFFEL_PARSER
		    l_options: detachable CONF_OPTION

--		    l_class_ast_2: CLASS_AS
--			l_calculator_2: AFX_FIX_POSITION_CALCULATOR
--			l_fix_position_2: detachable AST_EIFFEL
		do
			from
			    a_table.start
			until
			    a_table.after or is_cancel_requested
			loop
			    -- apply all fixes in a class file one time

			    l_class := a_table.key_for_iteration
			    l_list := a_table.item_for_iteration

    		    	-- TODO: check how to get the class_i from e_feature
--    		   	check False end

				create l_class_modifier.make (l_class.original_class)
				l_class_modifier.prepare

				if l_class_modifier.original_text.count /= l_class.text.count then
				    do_nothing
				end

				if l_class_modifier.is_ast_available then
				    l_class_ast := l_class_modifier.ast

				    from
				        l_list.start
				    until
				        l_list.after
				    loop
				        l_pos := l_list.item_for_iteration
           			    l_bkpt_ast := l_pos.breakpoint_info.ast

--						l_class_ast_2 := l_class.ast
--            		    create l_calculator_2.make (l_class_ast_2, l_bkpt_ast)
--            		    l_calculator_2.calculate_fix_position
--            		    l_fix_position_2 := l_calculator_2.instruction_ast

    				        	-- resolve fix position
            		    create l_calculator.make (l_class_ast, l_bkpt_ast)
            		    l_calculator.calculate_fix_position
            		    l_fix_position := l_calculator.instruction_ast

            			if l_fix_position = Void then
            			    l_repository := repository
            			    check l_repository /= Void end
            			    l_repository.set_health_state (False)
            			else
                		    l_pos.set_fix_position (l_fix_position)

                		    	-- insert fix code into class file
                		    l_pos.apply_fix (l_class_modifier)
						end

				        l_list.forth
				    end

				    	-- fix should not introduce syntax error
				    l_wrapper := Eiffel_parser_wrapper
				    l_parser := l_class_modifier.validating_parser
				    l_options := l_class_modifier.context_class.options
				    check options_attached: l_options /= Void end

				    l_wrapper.parse_with_option (l_parser, l_class_modifier.text, l_options, True, Void)
				    if not l_wrapper.has_error and then l_class_modifier.is_dirty then
				        l_class_modifier.commit
				    else
				        -- report error
				    end
				else -- not l_class_modifier.is_ast_available
				    is_cancel_requested := True
				end

			    a_table.forth
			end
		end

	apply_fixes
			-- apply the fixes to classes
		local
		    l_repository: like repository
		    l_table: HASH_TABLE [DS_ARRAYED_LIST[AFX_EXCEPTION_POSITION], CLASS_C]
		    l_list: DS_ARRAYED_LIST [AFX_EXCEPTION_POSITION]
		    l_positions: DS_LINEAR [AFX_EXCEPTION_POSITION]
		    l_class: CLASS_C
		do
		    l_repository := repository
		    check l_repository /= Void end

			l_positions := l_repository.exception_positions
		    create l_table.make (l_positions.count)

				-- categorize fixes according to their classes
			categorize_fix_positions (l_table)

				-- resolve the fix position and apply the fix
			resolve_fix_positions_and_apply (l_table)
		end

feature{NONE} -- Implementation

	current_step: INTEGER
			-- current step index

	Collect_involved_classes_step: INTEGER = 1
		-- step of collecting relevant classes

	Backup_modify_compile_and_restore_step: INTEGER = 2

--	Backup_involved_classes: INTEGER = 2
--		-- step of class file backup

--	Write_root_class_and_apply_fixes: INTEGER = 3
--			-- step of modify the system

--	Compile_system_and_restore: INTEGER = 4
--			-- system compilation

	Total_steps: INTEGER = 2
			-- total number of steps of applier

	categorize_fix_positions (a_table: HASH_TABLE [DS_ARRAYED_LIST[AFX_EXCEPTION_POSITION], CLASS_C])
			-- categorize fixes according to their classes
		local
		    l_repository: like repository
		    l_list: DS_ARRAYED_LIST [AFX_EXCEPTION_POSITION]
		    l_positions: DS_LINEAR [AFX_EXCEPTION_POSITION]
		    l_pos: AFX_EXCEPTION_POSITION
		    l_class: CLASS_C
		do
		    l_repository := repository
		    check l_repository /= Void end

			l_positions := l_repository.exception_positions

			from
			    l_positions.start
			until
			    l_positions.after
			loop
			    l_pos := l_positions.item_for_iteration

			    if l_pos.is_relevant then
    			    l_class := l_pos.e_feature.associated_class
    			    a_table.search (l_class)
    			    if a_table.found and then a_table.found_item /= Void then
    			        l_list := a_table.found_item
    			        l_list.force_last (l_pos)
    			    else
    			        create l_list.make_default
    			        l_list.force_last (l_pos)
    			        a_table.put (l_list, l_class)
    			    end
			    end
			    l_positions.forth
			end
		end


note
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
