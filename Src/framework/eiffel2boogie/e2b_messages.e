note
	description: "Messages used in AutoProof."
	date: "$Date$"
	revision: "$Revision$"

frozen class
	E2B_MESSAGES

inherit

	SHARED_LOCALE

feature -- Validity error messages

	functional_feature_not_function: STRING_32
		do Result := "Functional feature has to be a function" end

	functional_feature_not_single_assignment: STRING_32
		do Result := "A functional feature has to consist of exactly one assignment to the Result" end


	modify_field_first_argument_only_manifeststrings: STRING_32
		do Result := "The tuple in the first argument of 'modify_field' needs to consist only of manifest strings." end

	modify_field_first_argument_string_or_tuple: STRING_32
		do Result := "First argument of 'modify_field' has to be a manifest string or a tuple of manifest strings." end

	modify_field_field_does_not_exist (a_fname, a_cname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' mentioned in 'modify_field' does not exist in class '$2'", a_fname, a_cname) end

	modify_field_field_not_attribute (a_fname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' mentioned in 'modify_field' is not an attribute", a_fname) end

feature -- Verification error messages

	check_violated: STRING_32
		do Result := "Check may be violated (untagged)." end

	check_with_tag_violated: STRING_32
		do Result := "Check $tag may be violated." end

	precondition_violated: STRING_32
		do Result := "Precondition may be violated on call to $called_feature (untagged)." end

	precondition_with_tag_violated: STRING_32
		do Result := "Precondition $tag may be violated on call to $called_feature." end

	postcondition_violated: STRING_32
		do Result := "Postcondition may be violated (untagged)." end

	postcondition_with_tag_violated: STRING_32
		do Result := "Postcondition $tag may be violated." end

	loop_inv_violated_on_entry: STRING_32
		do Result := "Loop invariant may be violated on entry (untagged)." end

	loop_inv_with_tag_violated_on_entry: STRING_32
		do Result := "Loop invariant $tag may be violated on entry." end

	loop_inv_not_maintained: STRING_32
		do Result := "Loop invariant may not be maintained (untagged)." end

	loop_inv_with_tag_not_maintained: STRING_32
		do Result := "Loop invariant $tag may not be maintained." end

	loop_var_negative: STRING_32
		do Result := "Loop variant may be negative." end

	loop_var_with_tag_negative: STRING_32
		do Result := "Loop variant $tag may be negative." end

	loop_var_not_decreasing: STRING_32
		do Result := "Loop variant may not decrease." end

	loop_var_with_tag_not_decreasing: STRING_32
		do Result := "Loop variant $tag may not decrease." end

	void_call: STRING_32
		do Result := "Possible Void call." end

	void_call_in_precondition: STRING_32
		do Result := "Possible Void call in precondition on call to $called_feature (untagged)." end

	void_call_in_precondition_with_tag: STRING_32
		do Result := "Possible Void call in precondition $tag on call to $called_feature." end

	void_call_in_postcondition: STRING_32
		do Result := "Possible Void call in postcondition (untagged)." end

	void_call_in_postcondition_with_tag: STRING_32
		do Result := "Possible Void call in postcondition $tag." end

	overflow: STRING_32
		do Result := "Possible arithmetic overflow." end

	overflow_in_precondition: STRING_32
		do Result := "Possible arithmetic overflow in precondition on call to $called_feature (untagged)." end

	overflow_in_precondition_with_tag: STRING_32
		do Result := "Possible arithmetic overflow in precondition $tag on call to $called_feature." end

	overflow_in_postcondition: STRING_32
		do Result := "Possible arithmetic overflow in postcondition (untagged)." end

	overflow_in_postcondition_with_tag: STRING_32
		do Result := "Possible arithmetic overflow in postcondition $tag." end

	assignment_attached_and_allocated: STRING_32
		do Result := "Target of assignment may not be attached or allocated" end

	assignment_closed_or_owner_not_allowed: STRING_32
		do Result := "The fields `closed' and `owner' cannot be directly assigned." end

	assignment_target_open: STRING_32
		do Result := "Target of assignment may not be open." end

	assignment_observers_open_or_inv_preserved: STRING_32
		do Result := "Observers of the assignment target may not be open or do not preserver their invariant." end

	assignment_attribute_writable: STRING_32
		do Result := "The attribute of the assignment may not be writable." end

	ownership_explicit_note: STRING_32
		do Result := "Disable this default by making $explicit_value explicit." end

feature -- Verificaiton success/inconclusive messages

	successful_verification: STRING_32
		do Result := "Verification successful." end

	inconclusive_result: STRING_32
		do Result := "Inconclusive result (verifier timed out)." end

end
