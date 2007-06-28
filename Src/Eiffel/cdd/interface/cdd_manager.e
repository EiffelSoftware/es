indexing
	description: "Central object for managing all CDD activities"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_MANAGER

inherit

	CDD_CONSTANTS

	EB_CLUSTER_MANAGER_OBSERVER
		rename
			manager as eb_cluster_manager,
			refresh as eb_cluster_refresh,
			on_class_removed as remove_test_case_for_class
		export
			{NONE} all
		redefine
			remove_test_case_for_class
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

--	EB_CONSTANTS
--		export
--			{NONE} all
--		end

	CONF_ACCESS
		export
			{NONE} all
		end

	EB_SHARED_GRAPHICAL_COMMANDS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Add `Current' to cluster observer list.
		local
			l_prj_manager: EB_PROJECT_MANAGER
		do
			l_prj_manager := eiffel_project.manager
			l_prj_manager.load_agents.extend (agent check_for_existing_cdd_cluster)
			l_prj_manager.compile_stop_agents.extend (agent check_for_existing_cdd_cluster)
			eb_cluster_manager.add_observer (Current)
		end

feature -- Access (CDD Status)

	is_cdd_enabled: BOOLEAN is
			-- Is testing currently enabled?
		do
			Result := test_suite /= Void
		end

	is_capturing_enabled: BOOLEAN is
			-- Is capturing currently enabled?
		do
			Result := is_cdd_enabled and then capturer /= Void
		end

	test_suite: CDD_TEST_SUITE
			-- Test suite which is managed by `Current'

	capturer: CDD_CAPTURER

	can_enable_cdd: BOOLEAN is
			-- Can cdd support be enabled?
		do
			Result := not is_cdd_enabled and
				not project.initialized and
				not project.is_read_only and
				not target.system.date_has_changed
		end

	can_disable_cdd: BOOLEAN is
			-- Can cdd support be disabled?
		do
			Result := is_cdd_enabled and
				not target.system.date_has_changed
		end

	project: E_PROJECT is
			-- Currently opened project
		do
			Result := eiffel_project
		ensure
			open_project_not_void: Result /= Void
		end

	target: CONF_TARGET is
			-- Currently opened target of `project'
		require
			project_initialized: project.initialized
		do
			Result := eiffel_universe.target
		ensure
			not_void: Result /= Void
		end

	last_error: INTEGER
			-- Last error that occured

feature -- Status setting (Application)

	on_application_stopped (an_application_status: APPLICATION_STATUS) is
			-- Check whether we want to create a new test case from the current
			-- application status `an_application_status'.
		local
			l_file: KL_TEXT_OUTPUT_FILE
			l_cse: EIFFEL_CALL_STACK_ELEMENT
		do
			if is_capturing_enabled then
				capturer.capture_call_stack (an_application_status)
			end
		end

	on_application_quit is
			-- If `is_debugging' is true, notify test debugger that application is quit.
		do
		end

feature -- Status setting (CDD)

	enable_cdd is
			-- Try to create cdd cluster within project. On succeed recompile,
			-- otherwise set `last_error' appropriately.
		require
			not_enabled_yet: not is_cdd_enabled
			can_enable: can_enable_cdd
		local
			l_dirname: DIRECTORY_NAME
			l_dir: KL_DIRECTORY
			l_loc: CONF_FILE_LOCATION
			l_lib: CONF_LIBRARY
			ed: EV_ERROR_DIALOG
			l_root: CONF_CLUSTER
			rule: CONF_FILE_RULE
		do
			last_error := error_none
			l_root ?= eiffel_system.root_cluster
			if l_root = Void then
				last_error := error_bad_root_cluster
			else
				create l_dirname.make_from_string (l_root.location.evaluated_directory)
				l_dirname.extend (tests_cluster_name)
				create l_dir.make (l_dirname)
				l_dir.create_directory
				if l_dir.exists then
					eb_cluster_manager.remove_observer (Current)
					l_loc := conf_factory.new_location_from_full_path ("$ISE_LIBRARY\library\cdd\cdd.ecf", target)
					l_lib := conf_factory.new_library ("cdd", l_loc, target)
					target.add_library (l_lib)
					if l_root.is_recursive then
						create rule.make
						rule.add_exclude (tests_cluster_name)
						l_root.add_file_rule (rule)
					end
					create l_dirname.make_from_string (l_root.location.original_directory)
					l_dirname.extend (tests_cluster_name)
					eb_cluster_manager.add_cluster (tests_cluster_name, l_root, l_dirname)
					create test_suite.make_with_cluster (eb_cluster_manager.last_added_cluster)
					eb_cluster_manager.add_observer (Current)
					melt_project_cmd.execute
				else
					last_error := error_unable_to_create_dir
				end
			end
		end

	disable_cdd is
			-- Try to remove cdd cluster from project but leave all
			-- created directories and test cases.
		require
			cdd_enabled: can_disable_cdd
		do
				-- TODO: make sure no execution is running....
			target.remove_cluster (tests_cluster_name)
			target.system.store
			Discover_melt_cmd.execute
			test_suite := Void
		ensure
			cdd_disabled: not is_cdd_enabled
		end

	enable_capturing is
			-- Enable capturing mode.
		do
			--is_capturing_enabled := True
		end

	disable_capturing is
			-- Disable capturing mode.
		do
			--is_capturing_enabled := False
		end

	start_execution is
			--
		do

		end

	start_examinating is
			--
		do

		end

	start_debugging is
			--
		do

		end

feature {EB_CLUSTERS} -- Status setting (Eiffel Project)

	check_for_existing_cdd_cluster is
			-- Check if testing was enabled for this project before
			-- Note: This is usually called when project is opened.
		local
			l_cdd_enabled, l_cpt_enabled: BOOLEAN
			l_cluster: CLUSTER_I
			l_printer: CDD_TEST_CASE_PRINTER
		do
			l_cdd_enabled := is_cdd_enabled
			l_cpt_enabled := is_capturing_enabled
			l_cluster := eiffel_universe.cluster_of_name (tests_cluster_name)
			if l_cluster /= Void and not is_cdd_enabled then
				create test_suite.make_with_cluster (l_cluster)
			end

			if is_cdd_enabled and not is_capturing_enabled then
				create l_printer.make_with_cluster (l_cluster)
				create capturer.make
				capturer.capture_observers.put_last (l_printer)
			end
		end

	refresh is
			-- Refresh all CDD components.
		do
		end

	remove_test_case_for_class (a_class: CLASS_I) is
			-- Check if there is a test case for `a_class'. If this is
			-- the case, remove the test case.
		do
		end

feature -- Status change

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions performed after `Current' has refreshed the test suite

	update_state_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Actions performed when testing status changes

	log_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Agents for redirecting all output from external processes

feature {NONE} -- Implementation

	conf_factory: CONF_FACTORY is
			-- Factory for creating cdd library
		once
			create Result
		end

invariant
	capturing_implies_cdd_enabled: is_capturing_enabled implies is_cdd_enabled
end
