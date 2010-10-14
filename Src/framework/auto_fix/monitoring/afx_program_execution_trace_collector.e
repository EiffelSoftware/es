note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_TRACE_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE_COLLECTOR

inherit
	AFX_SHARED_PROGRAM_EXECUTION_TRACE_REPOSITORY

create
	make

feature -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
			-- `a_config': AutoFix configuration.
		local
			l_repos: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
		do
			config := a_config

			create l_repos.make
			set_repository (l_repos)
		end

feature -- Access

	config: AFX_CONFIG
			-- Configuration.

feature -- Callback

	on_trace_start (a_tc: EPA_TEST_CASE_INFO)
			-- Action to perform on start of an execution trace.
		require
			tc_has_uuid: a_tc.uuid /= Void and then not a_tc.uuid.is_empty
		local
		do

		end

	on_trace_step (a_tc: EPA_TEST_CASE_INFO; a_state: AFX_PROGRAM_EXECUTION_STATE; a_bpslot: INTEGER)
			-- Action to perform on step of an execution trace.
		require
			tc_has_uuid: a_tc.uuid /= Void and then not a_tc.uuid.is_empty
		local
		do

		end

	on_trace_end (a_tc: EPA_TEST_CASE_INFO)
			-- Action to perform on end of an execution trace.
		require
			tc_has_uuid: a_tc.uuid /= Void and then not a_tc.uuid.is_empty
		local
		do

		end

	on_finish_collecting
			-- Action to perform when finish collecting.
		local
		do
			
		end

feature{NONE} -- Implementation


end
