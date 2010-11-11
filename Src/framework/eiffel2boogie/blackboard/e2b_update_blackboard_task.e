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
				verify_task.verifier_result.verified_procedures.do_all (agent handle_verified_procedure (?))
				verify_task.verifier_result.verification_errors.do_all (agent handle_verification_error (?))
				blackboard.commit_results
			end
			has_next_step := False
		end

--			from
--				a_result.verified_procedures.start
--			until
--				a_result.verified_procedures.after
--			loop
--				procedure_name_regexp.match (a_result.verified_procedures.item.procedure_name)
--				l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))

--				create l_result.make (l_feature)
--				l_result.set_time (create {DATE_TIME}.make_now)
--				l_result.set_tool (blackboard.tools.first)
--				l_result.is_postcondition_proven.set_proven_to_hold
--				l_result.is_postcondition_proven.set_update
--				l_result.is_class_invariant_proven.set_proven_to_hold
--				l_result.is_class_invariant_proven.set_update

--				l_result.set_message ("Verified")
--				blackboard.add_verification_result (l_result)

--				a_result.verified_procedures.forth
--			end
--			from
--				a_result.verification_errors.start
--			until
--				a_result.verification_errors.after
--			loop
--				procedure_name_regexp.match (a_result.verification_errors.item.procedure_name)
--				l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))


--				create l_result.make (l_feature)
--				l_result.set_time (create {DATE_TIME}.make_now)
--				l_result.set_tool (blackboard.tools.first)
--				l_result.is_postcondition_proven.set_proven_to_fail
--				l_result.is_postcondition_proven.set_update
--				l_result.is_class_invariant_proven.set_proven_to_fail
--				l_result.is_class_invariant_proven.set_update

--				blackboard.add_verification_result (l_result)

--				a_result.verification_errors.forth
--			end
--		end


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
			procedure_name_regexp.match (a_procedure_result.procedure_name)
			l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))

			create l_feature_result.make (l_feature, tool_instance.configuration, 1.0)
			blackboard.add_verification_result (l_feature_result)
		end

	handle_verification_error (a_verification_error: E2B_VERIFICATION_ERROR)
		local
			l_feature: FEATURE_I
			l_feature_result: E2B_FAILED_VERIFICATION_RESULT
		do
			procedure_name_regexp.match (a_verification_error.procedure_name)
			l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))

			create l_feature_result.make (l_feature, tool_instance.configuration, 0.0)
			l_feature_result.set_error (a_verification_error)
			blackboard.add_verification_result (l_feature_result)
		end

	procedure_name_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^(\w*)\.(\w*)\.(\w*)$")
		end

	feature_with_name (a_class_name, a_feature_name: STRING): FEATURE_I
			-- Feature with name `a_feature_name' in class `a_class_name'
		require
			a_class_name_not_void: a_class_name /= Void
			a_feature_name_not_void: a_feature_name /= Void
		local
			l_class: CLASS_C
		do
			l_class := system.universe.classes_with_name (a_class_name).first.compiled_class
			check l_class /= Void end
			Result := l_class.feature_named_32 (a_feature_name.to_string_32)
			check Result /= Void end
		end


end
