indexing
	description: "Central object for managing all CDD activities"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_MANAGER

inherit

	CDD_CONSTANTS

	DEBUGGER_OBSERVER
		redefine
			on_application_stopped,
			on_application_quit
		end

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
			l_prj_manager.load_agents.extend (agent refresh_status)
			l_prj_manager.compile_stop_agents.extend (agent refresh_status)
			eb_cluster_manager.add_observer (Current)

			create refresh_actions
			create log_actions
		end

feature -- Access (CDD Status)

	test_suite: CDD_TEST_SUITE
			-- Test suite which is managed by `Current'

	capturer: CDD_CAPTURER
			-- Capturer for extracting new test cases

	is_cdd_enabled: BOOLEAN is
			-- Is testing currently enabled?
		do
			Result := test_suite /= Void
		ensure
			correct_result: Result = (test_suite /= Void)
		end

	is_extracting_enabled: BOOLEAN is
			-- Is capturing currently enabled?
		do
			Result := is_cdd_enabled and then capturer /= Void
		ensure
			correct_result: Result = (is_cdd_enabled and then capturer /= Void)
		end

	can_enable_cdd: BOOLEAN is
			-- Can cdd support be enabled?
		do
			Result := not is_cdd_enabled and then
				project.initialized and then
				not project.is_read_only
		end

	can_disable_cdd: BOOLEAN is
			-- Can cdd support be disabled?
		do
			Result := is_cdd_enabled
		end

feature {DEBUGGER_MANAGER} -- Status setting (Application)

	on_application_stopped (a_dbg_manager: DEBUGGER_MANAGER) is
			-- Check whether we want to create a new test case from the current
			-- application status `an_application_status'.
		require else
			a_dbg_manager_not_void: a_dbg_manager /= Void
			valid_app_status: a_dbg_manager.application_is_executing and
				a_dbg_manager.application_is_stopped
		do
			if is_extracting_enabled and a_dbg_manager.application_status.exception_occurred then
				capturer.capture_call_stack (a_dbg_manager.application_status)
			end
		end

	on_application_quit (a_dbg_manager: DEBUGGER_MANAGER) is
			-- If `is_debugging' is true, notify test debugger that application is quit.
		require else
			a_dbg_manager_not_void: a_dbg_manager /= Void
			valid_app_status: not a_dbg_manager.application_is_executing
		do
			-- TODO: Will be used for fg-debugging (when done we need to reset the root class)
		end

feature -- Status setting (CDD)

	enable_cdd is
			-- Enable cdd in system configuration. Also add cdd library
			-- and exclude file rule to configuration.
		require
			not_enabled_yet: not is_cdd_enabled
			can_enable: can_enable_cdd
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_enabled (True)
			target.system.store
			create test_suite.make_with_target (target)
			create background_executor.make (test_suite)
			refresh_actions.call (Void)
		ensure
			enabled: is_cdd_enabled
			correct_config: cdd_conf.is_enabled
		end

	disable_cdd is
			-- Disable cdd in system configuration and store new configuration
		require
			cdd_enabled: can_disable_cdd
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_enabled (False)
			target.system.store
			test_suite := Void
			if background_executor.has_next_step then
				background_executor.cancel
			end
			background_executor := Void
			refresh_actions.call (Void)
		ensure
			cdd_disabled: not is_cdd_enabled
			correct_config: not cdd_conf.is_enabled
		end

	enable_extracting is
			-- Make cdd create new test cases automatically.
			-- Enable extracting mode in system configuration and store it.
		require
			cdd_enabled: is_cdd_enabled
			extracting_disabled: not is_extracting_enabled
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_extracting (True)
			target.system.store
			create capturer.make
				-- Arno: not sure where to hook up printer and log
				-- observers for capturing
			capturer.capture_observers.put_last (create {CDD_TEST_CASE_PRINTER}.make (test_suite))
			refresh_actions.call (Void)
		ensure
			extracting_enabled: is_extracting_enabled
			correct_config: cdd_conf.is_extracting
		end

	disable_extracting is
			-- Stop cdd creating test cases automatically.
			-- Disable capturing mode in system configuration and store it.
		require
			cdd_enabled: is_cdd_enabled
			extracting_enabled: is_extracting_enabled
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_extracting (False)
			target.system.store
			capturer := Void
			refresh_actions.call (Void)
		ensure
			extracting_disabled: not is_extracting_enabled
			correct_config: not cdd_conf.is_extracting
		end

	enable_capture_replay is
			-- Enable capture/replay mode and store it in system configuration.
		require
			cdd_enabled: is_cdd_enabled
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_capture_replay_activated (True)
			target.system.store
			refresh_actions.call (Void)
		ensure
			correct_config: cdd_conf.is_capture_replay_activated
		end

	disable_capture_replay is
			-- Disable capture/replay mode and store it in system configuration.
		require
			cdd_enabled: is_cdd_enabled
		do
			instantiate_cdd_configuration
			cdd_conf.set_is_capture_replay_activated (False)
			target.system.store
			refresh_actions.call (Void)
		ensure
			correct_config: not cdd_conf.is_capture_replay_activated
		end

feature -- Execution

	background_executor: CDD_TEST_EXECUTOR
			-- Background executor of test suite

feature {ANY} -- Cooperative multitasking

	drive_background_tasks is
			-- Drive background tasks (e.g.: test case compilation and
			-- execution). In an event driven setting call this routine
			-- whenever time perimits. This routine must not execute for
			-- very long so that it can be called from within GUI event loops
		do
			if is_cdd_enabled and then background_executor.has_next_step then
				background_executor.step
			end
		end

feature {EB_CLUSTERS} -- Status setting (Eiffel Project)

	refresh_status is
			-- Check configuration if cdd status has changed and update if so and
			-- reiinitate background testing.
			-- Note: This is usually called when project is opened or compiled.
		do
			if project.initialized and target /= Void then
				instantiate_cdd_configuration
				if cdd_conf.is_enabled then
					if not is_cdd_enabled then
						enable_cdd
					end
					test_suite.refresh
					if cdd_conf.is_extracting and not is_extracting_enabled then
						enable_extracting
					elseif not cdd_conf.is_extracting and is_extracting_enabled then
						disable_extracting
					end
				else
					if is_extracting_enabled then
						disable_extracting
					end
					if is_cdd_enabled then
						disable_cdd
					end
				end
				if is_cdd_enabled then
					background_executor.start
				end
			end
		ensure
			correct_status: (project.initialized and target /= Void) implies (cdd_conf.is_enabled = is_cdd_enabled and
				(is_cdd_enabled implies (cdd_conf.is_extracting = is_extracting_enabled)))
		end

	remove_test_case_for_class (a_class: CLASS_I) is
			-- Check if there is a test case for `a_class'. If this is
			-- the case, remove the test case.
		do
			-- TODO: remove corresponding test class from test
			-- suite for `a_class' if it represents a cdd test class.
		end

feature -- Status change

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions performed after `Current' has refreshed the test suite

	log_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Agents for redirecting all output from external processes

feature {NONE} -- Implementation

	triggered_compilation: BOOLEAN
			-- Has `Current' triggered a compilation?

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
		end

	cdd_conf: CONF_CDD
			-- CDD Configuration instance

	instantiate_cdd_configuration is
			-- Create cdd configuration with default parameters if
			-- doesn't exists. Set `cdd_conf' to current
			-- cdd configuration.
		require
			project_initialized: project.initialized
		local
			l_conf: CONF_CDD
		do
			l_conf := target.cdd
			if l_conf = Void then
				l_conf := conf_factory.new_cdd (target)
				target.set_cdd (l_conf)
			end
			cdd_conf := l_conf
		ensure
			cdd_conf_valid: cdd_conf /= Void and then cdd_conf.target = target
		end

	conf_factory: CONF_FACTORY is
			-- Factory for creating cdd library
		once
			create Result
		end

	add_file_rule is
			-- If `a_file_rule' does not already contain, add
			-- `tests_directory_name' as an exclude to `a_file_rule'.
		require
			project_initialized: project.initialized
		local
			l_rules: ARRAYED_LIST [CONF_FILE_RULE]
			l_conf: CONF_FILE_RULE
			l_found: BOOLEAN
		do
			from
				l_rules := target.file_rule
				l_rules.start
			until
				l_rules.after or l_found
			loop
				l_conf := l_rules.item
				if l_conf.exclude.has (tests_directory_name) then
					l_found := True
				else
					l_rules.forth
				end
			end
			if not l_found then
				if l_rules.is_empty then
					l_conf := conf_factory.new_file_rule
					l_rules.force (l_conf)
				end
				l_rules.first.add_exclude (tests_directory_name)
			end
		end

	remove_file_rule is
			-- Remove all excludes of `tests_directory_name' from `a_file_rule'.
		require
			project_initialized: project.initialized
		local
			l_rules: ARRAYED_LIST [CONF_FILE_RULE]
			l_conf: CONF_FILE_RULE
		do
			from
				l_rules := target.file_rule
				l_rules.start
			until
				l_rules.after
			loop
				l_conf := l_rules.item
				if l_conf.exclude.has (tests_directory_name) then
					l_conf.exclude.remove (tests_directory_name)
				end
				l_rules.forth
			end
		end


invariant
	extracting_implies_cdd_enabled: is_extracting_enabled implies is_cdd_enabled
	cdd_enabled_implies_executor_not_void: is_cdd_enabled implies (background_executor /= Void)
	refresh_actions_not_void: refresh_actions /= Void
	log_actions_not_void: log_actions /= Void

end
