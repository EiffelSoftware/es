note
	description: "Summary description for {AFX_SYSTEM_ADJUSTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SYSTEM_ADJUSTER

inherit
    SHARED_TEST_SERVICE

    EB_CLUSTER_MANAGER_OBSERVER

    KL_SHARED_FILE_SYSTEM

    CONF_ACCESS

    SHARED_AFX_SESSION

    SHARED_EIFFEL_PARSER_WRAPPER

    SHARED_AFX_FIX_REPOSITORY_NEW

    SHARED_AFX_INTERNAL_PROGRESS_CONSTANT

feature -- Status report

	is_last_root_class_successful: BOOLEAN
			-- is last writing to root class successful?

	is_last_fix_successful: BOOLEAN
			-- is last fix application successful?

	is_last_copy_successful: BOOLEAN
			-- is last class file copy successful?

	is_root_written: BOOLEAN
			-- is the new root for test written?

	is_fix_applied: BOOLEAN
			-- are all the fixes applied?

	is_successful: BOOLEAN
			-- is adjustion successful so far?

feature -- Access

	auto_fix_override_cluster: detachable CONF_OVERRIDE
			-- cluster to accommodate the modified classes
		do
		    Result := internal_autofix_override_cluster
		end

	source_writer: AFX_FIX_EVALUATOR_SOURCE_WRITER
			-- source writer to generate the new root class for evaluation
		once
		    create Result
		end

feature -- Operation

	apply_compile_and_restore
			-- modify, compile, and restore
		require
		    repository_not_empty: not repository.is_empty
		local
		    l_ok: BOOLEAN
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_progress: REAL
		    l_proposer: AFX_FIX_PROPOSER
		    l_tests: DS_ARRAYED_LIST[AFX_TEST]
		do
		    l_ok := False

   		    l_session := session
   		    check l_session /= Void end
   		    l_conf := l_session.conf
		    l_proposer := l_session.fix_proposer
		    l_progress := (System_adjuster_finished_fraction - Fix_synthesizer_finished_fraction) / 3

   		    create l_tests.make_default
   		    l_tests.append_last (l_conf.failing_tests)
   		    l_tests.append_last (l_conf.regression_tests)

		    add_auto_fix_override_cluster
			if internal_autofix_override_cluster /= Void then
				apply_fixes_to_classes
				if is_last_fix_successful then
				    write_root_class (l_tests)
					l_session.progress (l_progress)
				    if is_last_root_class_successful then
				        l_proposer.compile_project
						l_session.progress (l_progress)
				        if l_proposer.last_compilation_successful then
					        l_ok := True
				        end
				    end
				end
			end

				-- restore system
		    write_root_class (Void)
			remove_auto_fix_override_cluster
			l_session.progress (l_progress)

			is_successful := l_ok
		end

feature -- Override cluster

	add_auto_fix_override_cluster
			-- add the autofix override cluster -- in case the cluster was not in the universe -- save the cluster into internal storage
		local
		    l_target: CONF_TARGET
		    l_overrides: HASH_TABLE [CONF_OVERRIDE, STRING]

			l_project_directory: PROJECT_DIRECTORY
			l_autofix_override_directory_name: DIRECTORY_NAME
			l_vis: CONF_FIND_LOCATION_VISITOR
			l_dir: DIRECTORY
			l_file: RAW_FILE
			l_parse_factory: CONF_PARSE_FACTORY
			l_loc: CONF_DIRECTORY_LOCATION
			l_override: CONF_OVERRIDE
			l_comp_factory: CONF_COMP_FACTORY
			l_sys: CONF_SYSTEM
		do
		    internal_autofix_override_cluster := Void

		    l_target := test_suite.service.eiffel_project.universe.target
			l_overrides := l_target.overrides
			l_overrides.search (Auto_fix_override_cluster_name)

			if l_overrides.found then
			    l_override := l_overrides.found_item

					-- clear the auto_fix_override cluster by deleting everything inside the directory
			    create l_dir.make (l_overrides.found_item.location.evaluated_path)
			    check l_dir.exists end
			    l_dir.delete_content

    				-- make sure the cluster has empty class list
    			l_override.set_classes (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))
    			l_override.set_classes_by_filename (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))

--			    manager.remove_group (l_overrides.found_item, l_overrides.found_item.location.evaluated_path)
				internal_autofix_override_cluster := l_override
			else
    				-- prepare backup directory name
    			l_project_directory := test_suite.service.eiffel_project.project_directory
    			l_autofix_override_directory_name := l_project_directory.backup_path.twin
    			l_autofix_override_directory_name.extend (Auto_fix_override_directory_name)

                create l_vis.make
                l_vis.set_directory (l_autofix_override_directory_name)
                l_vis.process_target (l_target)

    			if l_vis.found_clusters.is_empty then
    				create l_dir.make (l_autofix_override_directory_name)

    				if not l_dir.exists then
    					create l_file.make (l_autofix_override_directory_name)
    					if l_file.exists then
    					    	-- report error, a file with the same name already exists
    					else
    					    	-- create the directory
    					    create_directory (l_dir)
    					end
    				end

    				if l_dir.exists then
    				    create l_parse_factory
    					l_loc := l_parse_factory.new_location_from_path (l_autofix_override_directory_name, l_target)

    					create l_comp_factory
    					l_override := l_comp_factory.new_override (Auto_fix_override_cluster_name, l_loc, l_target)

            				-- create empty class list, so that the folder can be displayed
            			l_override.set_classes (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))
            			l_override.set_classes_by_filename (create {HASH_TABLE [EIFFEL_CLASS_I, STRING]}.make (0))

    					l_override.set_recursive (True)
    					l_override.set_internal (True)
--    					manager.add_cluster (Auto_fix_override_cluster_name, a_parent: CONF_GROUP, a_path: STRING_8, a_is_tests_cluster: BOOLEAN)
    					l_target.add_override (l_override)

            			l_sys := l_target.system
            			l_sys.store
            			if l_sys.store_successful then
                			l_sys.set_file_date

                				-- force rebuild as we know, that we changed the group layout
                			test_suite.service.eiffel_project.system.system.force_rebuild
                			manager.refresh

        					internal_autofix_override_cluster := l_override
        				end
    				else
    				    -- error in creating the directory
    				end
    			else
    			    -- error. the cluster could only be in overrides.
    			end
			end


    	ensure
    	    internal_autofix_override_cluster_can_be_void:
    	    					internal_autofix_override_cluster = Void
    	    				 or internal_autofix_override_cluster /= Void
		end

	remove_auto_fix_override_cluster
			-- remove auto fix override cluster
		require
		    auto_fix_override_cluster_not_void: auto_fix_override_cluster /= Void
		local
		    l_target: CONF_TARGET
		    l_conf: CONF_OVERRIDE
			l_dir: DIRECTORY
			l_sys: CONF_SYSTEM
		do
		    l_conf := auto_fix_override_cluster
			create l_dir.make (l_conf.location.evaluated_path)
		    l_dir.delete_content

		    l_target := test_suite.service.eiffel_project.universe.target
		    l_target.remove_override (Auto_fix_override_cluster_name)
--		    manager.remove_group (l_conf, l_conf.location.evaluated_path)
			l_sys := l_target.system
			l_sys.store
   			l_sys.set_file_date
   			test_suite.service.eiffel_project.system.system.force_rebuild
		    manager.refresh

		    internal_autofix_override_cluster := Void
		end

feature -- System root

	write_root_class (a_list: detachable DS_LINEAR [AFX_TEST])
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
				source_writer.write_fix_evaluator (l_file, a_list)
				is_last_root_class_successful := True
				l_file.flush
				l_file.close
			end
		end

feature -- Apply fixes

	apply_fixes_to_classes
			-- apply fixes to classes, save the result classes into the override cluster
		require
		    auto_fix_override_cluster_not_void: auto_fix_override_cluster /= Void
		local
		    l_fixes: HASH_TABLE [DS_ARRAYED_LIST[AFX_FIX_INFO_I], INTEGER]
		    l_list: DS_ARRAYED_LIST [AFX_FIX_INFO_I]
		    l_class_id: INTEGER
		    l_class: CLASS_C
		do
			l_fixes := repository.storage
		    is_last_fix_successful := True

			from l_fixes.start
			until l_fixes.after or not is_last_fix_successful
			loop
			    l_list := l_fixes.item_for_iteration

					-- copy class files to override cluster
			    l_class_id := l_fixes.key_for_iteration
				l_class := test_suite.service.eiffel_project.comp_system.class_of_id (l_class_id)

				add_overriding_class (l_class)

				if is_last_fix_successful and then attached {EIFFEL_CLASS_I}manager.last_added_class as l_overriding_class then
				    	-- apply fix to overriding class
				    apply_fix_to_class (l_overriding_class, l_list)
				else
				    is_last_fix_successful := False
				end

			    l_fixes.forth
			end
		end

feature{NONE} -- Implementation

	apply_fix_to_class (a_class: EIFFEL_CLASS_I; a_fix_list: DS_ARRAYED_LIST [AFX_FIX_INFO_I])
			-- apply fixes to class with id `an_id'
		require
		    auto_fix_override_cluster_not_void: auto_fix_override_cluster /= Void
		local
		    l_class_modifier: AFX_FIX_WRITER
		    l_class_ast: detachable CLASS_AS
		    l_fix: AFX_FIX_INFO_I
		    l_wrapper: EIFFEL_PARSER_WRAPPER
		    l_parser: EIFFEL_PARSER
		    l_options: detachable CONF_OPTION
		do
			create l_class_modifier.make (a_class)
			l_class_modifier.prepare

			if l_class_modifier.is_ast_available then
			    l_class_ast := l_class_modifier.ast
			    check l_class_ast /= Void end

			    from
			        a_fix_list.start
			    until
			        a_fix_list.after or not is_last_fix_successful
			    loop
			        l_fix := a_fix_list.item_for_iteration

			        	-- apply a fix
			        l_fix.apply (l_class_modifier)

			        a_fix_list.forth
			    end

				if is_last_fix_successful then
    			    	-- fix should not introduce syntax error
    			    l_wrapper := Eiffel_parser_wrapper
    			    l_parser := l_class_modifier.validating_parser
    			    l_options := l_class_modifier.context_class.options
    			    check options_attached: l_options /= Void end

    			    l_wrapper.parse_with_option (l_parser, l_class_modifier.text, l_options, True, Void)
    			    if not l_wrapper.has_error and then l_class_modifier.is_dirty then
    			        l_class_modifier.commit
    			    else
    			        is_last_fix_successful := False
    			    end
				end
			end
		end

	add_overriding_class (a_class: CLASS_C)
			-- add an overriding class for `a_class'
		require
		    auto_fix_override_cluster_not_void: auto_fix_override_cluster /= Void
		local
		    l_class_name: STRING
		    l_class_file_name: STRING
			l_old_file_name: FILE_NAME
			l_cluster_dir: DIRECTORY_NAME
			l_new_file_name: FILE_NAME
		    l_factory: CONF_COMP_FACTORY
		do
            l_class_name := a_class.name_in_upper

            	-- old file name (including file path)
            create l_old_file_name.make_from_string (a_class.file_name)

            	-- new file
            create l_cluster_dir.make_from_string (auto_fix_override_cluster.location.evaluated_path)
            l_class_file_name := l_class_name.twin
            l_class_file_name.to_lower
            create l_new_file_name.make_from_string (l_cluster_dir)
            l_new_file_name.set_file_name (l_class_file_name)
            l_new_file_name.add_extension ("e")

            	-- copy
            guaranteed_file_copy (l_old_file_name, l_new_file_name)

            if is_last_copy_successful then
					-- add class to override
            	create l_factory
            	l_class_file_name.append (".e")
            	manager.add_class_to_cluster (l_class_file_name, auto_fix_override_cluster, ".", l_class_name)
				if not (attached {EIFFEL_CLASS_I}manager.last_added_class) then
            	    is_last_fix_successful := False
            	end
            else
                is_last_fix_successful := False
            end
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
   			if l_file.exists then
   			    l_file_length := l_file.count

   				l_file_system.copy_file (a_from, a_to)

   				create l_file.make (a_to)
   				if l_file.exists  and then l_file_length = l_file.count then
   				    is_last_copy_successful := True
   				end
   			end
		end



	Auto_fix_override_cluster_name: STRING = "auto_fix_override"
			-- cluster name

	Auto_fix_override_directory_name: STRING = "auto_fix_override"
			-- directory name

	internal_autofix_override_cluster: detachable CONF_OVERRIDE
			-- internal storage for the override cluster

	create_directory (dir: DIRECTORY)
			-- Physically create the directory `dir'.
		local
			retried: BOOLEAN
		do
			if not retried then
				dir.create_dir
			end

		rescue
			retried := True
			retry
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
