note
	description: "Blackboard data for a feature."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_FEATURE_DATA

inherit

	EBB_CHILD_ELEMENT [EBB_CLASS_DATA, EBB_FEATURE_DATA]
		redefine
			recalculate_correctness_confidence
		end

	EBB_FEATURE_ASSOCIATION

	EBB_SHARED_VERIFICATION_PROPERTIES

	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_feature: attached FEATURE_I)
			-- Initialize empty feature data associated to `a_feature'.
		do
			make_with_feature (a_feature)
			create verification_results.make
			create verification_state.make (a_feature)
			create applicable_verification_properties.make

			set_up_properties

			correctness_confidence := verification_state.correctness_confidence
		ensure
			consistent: system.class_of_id (class_id) = a_feature.written_class
			consistent2: associated_feature.rout_id_set ~ a_feature.rout_id_set
		end

	set_up_properties
			-- Set up properties.
		do
			if not associated_feature.is_attribute then
				applicable_verification_properties.extend (postcondition_satisfied)
				applicable_verification_properties.extend (class_invariant_satisfied)
				applicable_verification_properties.extend (frame_condition_satisfied)
				applicable_verification_properties.extend (preconditions_of_calls_satisfied)
				applicable_verification_properties.extend (checks_satisfied)
			end
		end

feature -- Access

	applicable_verification_properties: attached LINKED_LIST [attached EBB_VERIFICATION_PROPERTY]
			-- List of verification properties applicable to this feature.

	verification_properties: attached HASH_TABLE [attached EBB_VERIFICATION_PROPERTY_VALUE, attached EBB_VERIFICATION_PROPERTY]
			-- Current values for each verification property.





	verification_state: attached EBB_FEATURE_VERIFICATION_STATE
			-- Current verification state of this feature.
			-- This is the accumulated information from the individual verification results.

--	verification_properties: attached HASH_TABLE [EBB_VERIFICATION_PROPERTY_VALUE, EBB_VERIFICATION_PROPERTY]

	verification_results: attached LINKED_LIST [attached EBB_FEATURE_VERIFICATION_RESULT]
			-- List of verification results.

	last_result: detachable EBB_FEATURE_VERIFICATION_RESULT
			-- Last verification result, if any.
		do
			if not verification_results.is_empty then
				Result := verification_results.last
			end
		end

feature -- Basic operations

	update_with_new_result (a_result: attached EBB_FEATURE_VERIFICATION_RESULT)
			-- Update `verification_state' with `a_result'.
		do
			if is_stale then
					-- Previous information is out of date. Clear first.
				verification_results.wipe_out
			end
			
			set_last_check_time (a_result.time)
			set_last_check_tool (a_result.tool)

			verification_results.extend (a_result)

			verification_state.update_with_new_result (a_result)
		end

	recalculate_correctness_confidence
			-- <Precursor>
		do
			correctness_confidence := verification_state.correctness_confidence
			Precursor
		end

feature {NONE} -- Implementation

end
