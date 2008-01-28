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
			on_application_stopped
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

	CONF_ACCESS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (dbg_mng: DEBUGGER_MANAGER; a_project: like project) is
			-- Add `Current' to cluster observer list.
		require
			a_project_not_void: a_project /= Void
		local
			l_prj_manager: EB_PROJECT_MANAGER
		do
			debugger_manager := dbg_mng
			create status_update_actions
			create output_actions
			create test_suite.make (Current)
			create background_executor.make (Current)
			create debug_executor.make (Current)
			create capturer.make (Current)
			create printer.make (Current)
			capturer.capture_observers.put_last (printer)

			status_update_actions.extend (agent process_update)

			project := a_project
			l_prj_manager := project.manager
			l_prj_manager.load_agents.extend (agent refresh_status)
			l_prj_manager.compile_stop_agents.extend (agent refresh_status)
			eb_cluster_manager.add_observer (Current)

			create cdd_breakpoints.make (debugger_manager, 30)
			debugger_manager.application_prelaunching_actions.extend (agent cdd_breakpoints.update)
		ensure
			project_set: project = a_project
		end

feature -- Access (status)

	cdd_breakpoints: CDD_BREAKPOINTS_LIST
			-- CDD breakpoints.

	test_suite: CDD_TEST_SUITE
			-- Test suite which is managed by `Current'

	debugger_manager: DEBUGGER_MANAGER
			-- Debugger manager.

	project: E_PROJECT
			-- Project for which we manager tests

	is_project_initialized: BOOLEAN is
			-- Has `project' been initialized?
			-- NOTE: This is the main condition whether cdd is active or not
		do
			Result := project.initialized and project.system_defined -- target /= Void
		end

	is_extracting_enabled: BOOLEAN
			-- Is capturing currently enabled?

	is_executing_enabled: BOOLEAN
			-- Do we automatically execute tests?

	is_changing_status: BOOLEAN
			-- Is `Current' changing its status?

	last_updated_test_class: EIFFEL_CLASS_C
			-- Test class which has last been processed in degree 5

	testing_directory: CONF_DIRECTORY_LOCATION is
			-- Directory where test classes, interpreter,
			-- cdd root class etc. are created
			-- NOTE: if .ecf file is in directory x, `testing_directory'
			-- will point to x/cdd_tests/target
		require
			project_initialized: is_project_initialized
		local
			l_path: STRING
		do
			if cached_testing_directory = Void then
				l_path := ".\cdd_tests\" + target.name
				cached_testing_directory := conf_factory.new_location_from_path (l_path, target)
			end
			Result := cached_testing_directory
		end

feature -- Access (execution)

	background_executor: CDD_TEST_EXECUTOR
			-- Background executor of test suite

	debug_executor: CDD_TEST_DEBUGGER
			-- Test debugger for debugging tests

feature -- Access (Extraction)

	printer: CDD_TEST_CASE_PRINTER
			-- Printer for extracting test cases

feature {DEBUGGER_MANAGER} -- Status setting (Application)

	on_application_stopped (a_dbg_manager: DEBUGGER_MANAGER) is
			-- Check whether we want to create a new test case from the current
			-- application status `an_application_status'.
		require else
			a_dbg_manager_not_void: a_dbg_manager /= Void
			valid_app_status: a_dbg_manager.application_is_executing and
				a_dbg_manager.application_is_stopped
		do
				-- Before we extract any thing, make sure
				--		* extraction is actually enabled
				--		* the debugger is not debugging a
				--		  test routine right now
				--		* an exception has occured which
				--		  is not a developer exception
			if is_extracting_enabled and
				not debug_executor.is_running and
				a_dbg_manager.application_status.exception_occurred and
				a_dbg_manager.application_status.exception_code /= {EXCEP_CONST}.developer_exception then
				capturer.capture_call_stack (a_dbg_manager.application_status)
			end
		end

feature {STOPPED_HDLR} -- CDD breakpoints

	execution_paused_on_breakpoint (cse: CALL_STACK_ELEMENT_CLASSIC) is
			-- Execution paused on breakpoint
		local
			f: E_FEATURE
			i: INTEGER
		do
			f := cse.routine
			i := cse.break_index
			if
				i = f.first_breakpoint_slot_index and then
				cdd_breakpoints.has_cdd_breakpoint (f)
			then
				--| We reached a CDD breakpoint
				--| on routine `f'

			end
		end

feature -- Status setting (CDD)

	enable_extracting is
			-- Make cdd create new test cases automatically.
			-- Enable extracting mode in system configuration and store it.
		require
			project_initialized: project.initialized
			extraction_disabled: not is_extracting_enabled
			not_changing_status: not is_changing_status
		do
			is_changing_status := True
			instantiate_cdd_configuration
			cdd_conf.set_is_extracting (True)
			target.system.store
			is_extracting_enabled := True
			status_update_actions.call ([status_udpate])
			is_changing_status := False
		ensure
			extracting_enabled: is_extracting_enabled
			correct_config: cdd_conf.is_extracting
		end

	disable_extracting is
			-- Stop cdd creating test cases automatically.
			-- Disable capturing mode in system configuration and store it.
		require
			project_initialized: project.initialized
			extracting_enabled: is_extracting_enabled
			not_changing_status: not is_changing_status
		do
			is_changing_status := True
			instantiate_cdd_configuration
			cdd_conf.set_is_extracting (False)
			target.system.store
			is_extracting_enabled := False
			status_update_actions.call ([status_udpate])
			is_changing_status := False
		ensure
			extracting_disabled: not is_extracting_enabled
			correct_config: not cdd_conf.is_extracting
		end

	enable_executing is
			-- Make cdd create new test cases automatically.
			-- Enable extracting mode in system configuration and store it.
		require
			project_initialized: project.initialized
			executing_disabled: not is_executing_enabled
			not_changing_status: not is_changing_status
		do
			is_changing_status := True
			instantiate_cdd_configuration
			cdd_conf.set_is_executing (True)
			target.system.store
			is_executing_enabled := True
			status_update_actions.call ([status_udpate])
			start_background_executing := True
			is_changing_status := False
		ensure
			executing_enabled: is_executing_enabled
			correct_config: cdd_conf.is_executing
		end

	disable_executing is
			-- Stop cdd creating test cases automatically.
			-- Disable capturing mode in system configuration and store it.
		require
			project_initialized: project.initialized
			executing_enabled: is_executing_enabled
			not_changing_status: not is_changing_status
		do
			is_changing_status := True
			instantiate_cdd_configuration
			cdd_conf.set_is_executing (False)
			target.system.store
			is_executing_enabled := False
			status_update_actions.call ([status_udpate])
			is_changing_status := False
		ensure
			executing_disabled: not is_executing_enabled
			correct_config: not cdd_conf.is_executing
		end

feature {ANY} -- Cooperative multitasking

	start_background_executing: BOOLEAN
			-- Shall we (re)start executing the next time `drive_background_tasks' is called?

	drive_background_tasks is
			-- Drive background tasks (e.g.: test case compilation and
			-- execution). In an event driven setting call this routine
			-- whenever time perimits. This routine must not execute for
			-- very long so that it can be called from within GUI event loops
		do
			if not project.is_compiling then
				if start_background_executing and is_executing_enabled then
					background_executor.start
					start_background_executing := False
				elseif background_executor.has_next_step then
					background_executor.step
				end
			end
		end

feature {EB_CLUSTERS} -- Status setting (Eiffel Project)

	refresh_status is
			-- Check configuration if cdd status has changed and update if so and
			-- reiinitate background testing.
			-- Note: This is usually called when project is opened or compiled.
		require
			not_changing_status: not is_changing_status
		local
			l_update_call: BOOLEAN
		do
			is_changing_status := True
			if is_project_initialized then
				if cdd_conf /= Void and then cdd_conf.is_extracting then
					if not is_extracting_enabled then
						is_extracting_enabled := True
						l_update_call := True
					end
				elseif is_extracting_enabled then
					is_extracting_enabled := False
					l_update_call := True
				end
				if cdd_conf /= Void and then cdd_conf.is_executing then
					if not is_executing_enabled then
						is_executing_enabled := True
						l_update_call := True
					end
				elseif is_executing_enabled then
					is_executing_enabled := False
					l_update_call := True
				end
				if not has_project_been_initialized then
					has_project_been_initialized := True
						-- From now on, we want to be notified whenever
						-- a test case class get processed in degree 5
					project.system.system.degree_5.process_actions.extend (agent add_updated_class)
					l_update_call := True
				end
				if l_update_call then
					status_update_actions.call ([status_udpate])
				end
				test_suite.refresh
				if project.successful and not debug_executor.is_running then
					start_background_executing := True
				end
			end
			is_changing_status := False
		end

	add_updated_class is
			-- If `a_class' is a test class (exists in test suite)
			-- add it to classes which for which test class should
			-- be updated.
		local
			l_class: EIFFEL_CLASS_C
		do
			l_class := project.system.system.degree_5.current_class
			if test_suite.has_test_case_for_class (l_class) then
				last_updated_test_class := l_class
				status_update_actions.call ([create {CDD_STATUS_UPDATE}.make_with_code ({CDD_STATUS_UPDATE}.test_class_update_code)])
			end
			last_updated_test_class := Void
		end

	remove_test_case_for_class (a_class: CLASS_I) is
			-- Check if there is a test case for `a_class'. If this is
			-- the case, remove the test case.
		do
			-- TODO: remove corresponding test class from test
			-- suite for `a_class' if it represents a cdd test class.
		end

feature -- Status change

	status_update_actions: ACTION_SEQUENCE [TUPLE [CDD_STATUS_UPDATE]]
			-- Actions performed whenever `Current' or any cdd controller changes its state

	output_actions: ACTION_SEQUENCE [TUPLE [STRING]]
			-- Actions performed whenever there is some kind of textual output available

feature {NONE} -- Implementation

	process_update (an_update: CDD_STATUS_UPDATE) is
			-- Process `an_update' if necessary.
		require
			an_update_not_void: an_update /= Void
		do
			if an_update.code = an_update.capturer_extracted_code then
				start_background_executing := True
			end
		end

feature {NONE} -- Implementation

	cached_testing_directory: like testing_directory
			-- Cached `testing_directory'

	has_project_been_initialized: BOOLEAN
			-- Has the project been initialized before?

	capturer: CDD_CAPTURER
			-- Capturer for extracting new test cases

	target: CONF_TARGET is
			-- Currently opened target of `project'
		require
			project_initialized: project.initialized
		do
			Result := project.system.universe.target
		end

	cdd_conf: CONF_CDD is
			-- CDD Configuration instance
		do
			Result := target.cdd
		end

	instantiate_cdd_configuration is
			-- Create cdd configuration with default parameters if
			-- doesn't exists. Set `cdd_conf' to current
			-- cdd configuration.
		require
			project_initialized: is_project_initialized
		local
			l_conf: CONF_CDD
		do
			l_conf := cdd_conf
			if l_conf = Void then
				l_conf := conf_factory.new_cdd (target)
				target.set_cdd (l_conf)
			end
		ensure
			cdd_conf_valid: cdd_conf /= Void and then cdd_conf.target = target
		end

	conf_factory: CONF_FACTORY is
			-- Factory for creating cdd library
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	status_udpate: CDD_STATUS_UPDATE is
			-- Update message for `Current'
		once
			create Result.make_with_code ({CDD_STATUS_UPDATE}.manager_update_code)
		ensure
			not_void: Result /= Void
		end

invariant
	test_suite_not_void: test_suite /= Void
	executor_not_void: background_executor /= Void
	debugger_not_void: debug_executor /= Void
	capturer_not_void: capturer /= Void
	printer_not_void: printer /= Void
	status_update_actions_not_void: status_update_actions /= Void
	output_actions_not_void: output_actions /= Void
	last_updated_test_class_valid: (last_updated_test_class /= Void) implies
		test_suite.has_test_case_for_class (last_updated_test_class)

	extracting_implies_project_initialized: is_extracting_enabled implies is_project_initialized
	executing_implies_project_initialized: is_executing_enabled implies is_project_initialized

end
