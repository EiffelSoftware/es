note
	description: "Task to evaluate Boogie output."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_EVALUATE_BOOGIE_OUTPUT_TASK

inherit

	ROTA_TASK_I

	SHARED_WORKBENCH

	EBB_SHARED_BLACKBOARD

create
	make

feature {NONE} -- Initialization

	make (a_verifier: attached like verifier)
			-- Initialize task.
		do
			verifier := a_verifier
			has_next_step := True
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		do
			if attached verifier.last_output then
				verifier.parse_verification_output

-- TODO: do this right
				update_blackboard

			end
			has_next_step := False
		end

-- TODO: do this right
	update_blackboard
		local
			l_result: EBB_FEATURE_VERIFICATION_RESULT
			l_feature: FEATURE_I
		do
			from
				verifier.last_result.verified_procedures.start
			until
				verifier.last_result.verified_procedures.after
			loop
				procedure_name_regexp.match (verifier.last_result.verified_procedures.item.procedure_name)
				l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))

				create l_result.make (l_feature)
				l_result.set_time (create {DATE_TIME}.make_now)
				l_result.set_tool (blackboard.tools.first)
				l_result.is_postcondition_proven.set_proven_to_hold
				l_result.is_postcondition_proven.set_update
				l_result.is_class_invariant_proven.set_proven_to_hold
				l_result.is_class_invariant_proven.set_update

				blackboard.add_verification_result (l_result)

				verifier.last_result.verified_procedures.forth
			end
			from
				verifier.last_result.verification_errors.start
			until
				verifier.last_result.verification_errors.after
			loop
				procedure_name_regexp.match (verifier.last_result.verification_errors.item.procedure_name)
				l_feature := feature_with_name (procedure_name_regexp.captured_substring (2), procedure_name_regexp.captured_substring (3))

				create l_result.make (l_feature)
				l_result.set_time (create {DATE_TIME}.make_now)
				l_result.set_tool (blackboard.tools.first)
				l_result.is_postcondition_proven.set_proven_to_fail
				l_result.is_postcondition_proven.set_update
				l_result.is_class_invariant_proven.set_proven_to_fail
				l_result.is_class_invariant_proven.set_update

				blackboard.add_verification_result (l_result)

				verifier.last_result.verification_errors.forth
			end
		end

-- TODO: do this right
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

-- TODO: do this right
	procedure_name_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^(\w*)\.(\w*)\.(\w*)$")
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	verifier: attached E2B_VERIFIER
			-- Boogie verifier.

end
