note
	description: "Summary description for {E2B_UPDATE_BLACKBOARD_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_UPDATE_BLACKBOARD_TASK

inherit

	ROTA_TASK_I

	SHARED_WORKBENCH

	EBB_SHARED_BLACKBOARD

create
	make

feature {NONE} -- Initialization

	make (a_tool_instance: attached like tool_instance; a_verify_task: attached like verify_task)
			-- Initialize task.
		do
			tool_instance := a_tool_instance
			verify_task := a_verify_task
			has_next_step := True
		end

feature -- Access

	tool_instance: E2B_TOOL_INSTANCE
			-- Tool instance running.

	verify_task: E2B_VERIFY_TASK
			-- Parent task.

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		do
			if attached verify_task.verifier_result then
				blackboard.record_results
				check False end
--				verify_task.verifier_result.verified_procedures.do_all (agent handle_verified_procedure (?))
--				verify_task.verifier_result.verification_errors.do_all (agent handle_verification_error (?))
				blackboard.commit_results
			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	handle_verified_procedure (a_procedure_result: E2B_PROCEDURE_RESULT)
		local
			l_feature: FEATURE_I
			l_feature_result: E2B_SUCCESSFUL_VERIFICATION_RESULT
		do
			l_feature := a_procedure_result.eiffel_feature

			create l_feature_result.make (l_feature, tool_instance.configuration, {E2B_BLACKBOARD_SCORES}.successful)
			blackboard.add_verification_result (l_feature_result)
		end

	handle_verification_error (a_verification_error: E2B_VERIFICATION_ERROR)
		local
			l_feature: FEATURE_I
			l_feature_result: E2B_FAILED_VERIFICATION_RESULT
		do
			l_feature := a_verification_error.eiffel_feature

			create l_feature_result.make (l_feature, tool_instance.configuration, {E2B_BLACKBOARD_SCORES}.failed)
			l_feature_result.set_error (a_verification_error)
			blackboard.add_verification_result (l_feature_result)
		end

end
