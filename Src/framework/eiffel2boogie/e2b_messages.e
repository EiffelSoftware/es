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
		do Result := "Functional feature has to be a function." end

	functional_feature_not_single_assignment: STRING_32
		do Result := "A functional feature has to consist of exactly one assignment to the Result." end

	creator_feature_not_creation_procedure: STRING_32
		do Result := "Feature is marked as creator but is not a creation procedure." end

	creator_call_as_procedure (a_pname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' is a creator but is called as a regular procedure.", a_pname) end

	first_argument_string: STRING_32
		do Result := "First argument has to be a manifest string." end

	first_argument_string_or_tuple: STRING_32
		do Result := "First argument has to be a manifest string or a tuple of manifest strings." end

	field_does_not_exist (a_fname, a_cname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' does not exist in class '$2'.", a_fname, a_cname) end

	field_not_attribute (a_fname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' is not an attribute.", a_fname) end

	invalid_tag (a_tag, a_class_name: STRING): STRING_32
		do Result := locale.formatted_string ("Filtered invariant of class '$2' lists invalid tag: $1", a_tag, a_class_name) end

	variant_bad_type (a_index: INTEGER): STRING_32
		do Result := locale.formatted_string ("Type of variant number $1 has no well-founded order.", a_index.out) end

	invalid_set_seq_comparison: STRING_32
		do Result := "Sets and sequences can only be compared with other sets or sequences" end

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

	decreases_not_decreasing: STRING_32
		do Result := "Variant may not decrease at this recursive call / the end of this loop body." end

	decreases_bounded (index: STRING): STRING_32
		do Result := locale.formatted_string ("Integer variant component at position $1 may be negative.", index) end

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

feature -- Other

	boogie_launch_failed (a_executable: STRING_32): STRING_32
		do Result := locale.formatted_string ("Launching Boogie failed (command was '$1').", a_executable) end

feature -- GUI

	tool_header_class: STRING_32
		do Result := "Class" end

	tool_header_feature: STRING_32
		do Result := "Feature" end

	tool_header_information: STRING_32
		do Result := "Information" end

	tool_header_position: STRING_32
		do Result := "Position" end

	tool_header_time: STRING_32
		do Result := "Time [s]" end

	tool_successful_button (a_value: INTEGER): STRING_32
		do Result := locale.formatted_string ("$1 Successful", a_value) end

	tool_failed_button (a_value: INTEGER): STRING_32
		do Result := locale.formatted_string ("$1 Failed", a_value) end

	tool_error_button (a_value: INTEGER): STRING_32
		do Result := locale.formatted_string (locale.plural_translation ("$1 Error", "$1 Errors", a_value), a_value) end

	tool_text_filter: STRING_32
		do Result := "Filter" end

end
