indexing
	description:
		"[
			Strings used in EVE Proofs.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_NAMES

inherit {NONE}

	SHARED_LOCALE
		export {NONE} all end

feature -- Access: Error strings

	description_no_description: STRING_32
			-- Error description that no description is available
		do
			Result := locale.translation ("No description available.")
		end

	error_unsupported_platform: STRING_32
			-- Error message for unsupported platform
		do
			Result := locale.translation ("Unsupported platform")
		end

	description_unsupported_platform: STRING_32
			-- Error description for unsupported platform
		do
			Result := locale.translation ("EVE Proofs is using Boogie which currently only runs on Windows.")
		end

	error_file_not_found: STRING_32
			-- Error message for file not found
		do
			Result := locale.translation ("Boogie code file not found")
		end

	description_file_not_found (a_file: STRING_GENERAL): STRING_32
			-- Error description for file not found
		do
			Result := locale.formatted_string (locale.translation ("Boogie code file $1 not found."), [a_file])
		end

	error_file_not_writable: STRING_32
			-- Error message for file not found
		do
			Result := locale.translation ("Output file not writable")
		end

	description_file_not_writable (a_file: STRING_GENERAL): STRING_32
			-- Error description for file not found
		do
			Result := locale.formatted_string (locale.translation ("The output file $1 could not be written to.%NMake sure the file is writable."), [a_file])
		end

	error_launching_boogie_failed: STRING_32
			-- Error message for file not found
		do
			Result := locale.translation ("Launching Boogie failed")
		end

	description_launching_boogie_failed: STRING_32
			-- Error description for file not found
		do
			Result := locale.translation ("Launching of Boogie failed.%NMake sure the Boogie executable 'boogie' is installed and in the PATH.")
		end

	error_unsupported_constant_type: STRING_32
			-- Error message that constant of this type is not supported
		do
			Result := locale.translation ("Unsupported constant type")
		end

	error_unknown_verification_error: STRING_32
			-- Error message that an unknown error occured
		do
			Result := locale.translation ("An unknown error occured")
		end

	description_unknown_verification_error: STRING_32
			-- Error description that an unknown error occured
		do
			Result := locale.translation ("Boogie produced an unknown error.%NPlease report this to the developers of EVE Proofs.")
		end

	error_precondition_violation: STRING_32
			-- Error message that precondition is violated
		do
			Result := locale.translation ("Precondition of call may be violated")
		end

	description_precondition_violation: STRING_32
			-- Error description that precondition is violated
		do
			Result := locale.translation ("The precondition of this call may be violated.")
		end

	error_postcondition_violation: STRING_32
			-- Error message that postcondition is violated
		do
			Result := locale.translation ("Postcondition may be violated")
		end

	description_postcondition_violation: STRING_32
			-- Error description that postcondition is violated
		do
			Result := locale.translation ("The postcondition of this feature may be violated.")
		end

	error_invariant_violation: STRING_32
			-- Error message that invariant is violated
		do
			Result := locale.translation ("Invariant may be violated")
		end

	description_invariant_violation: STRING_32
			-- Error description that invariant is violated
		do
			Result := locale.translation ("The invariant of this class may be violated at the end of the feature.")
		end

	error_loop_invariant_violation: STRING_32
			-- Error message that loop invariant is violated
		do
			Result := locale.translation ("Loop invariant may be violated")
		end

	description_loop_invariant_violation: STRING_32
			-- Error description that loop invariant is violated
		do
			Result := locale.translation ("This loop invariant may be violated.")
		end

	error_check_violation: STRING_32
			-- Error message that check instruction is violated
		do
			Result := locale.translation ("Check may be violated")
		end

	description_check_violation: STRING_32
			-- Error description that check is violated
		do
			Result := locale.translation ("This check instruction may be violated.")
		end

	error_frame_violation: STRING_32
			-- Error message that frame condition is violated
		do
			Result := locale.translation ("Frame condition may be violated")
		end

	description_frame_violation: STRING_32
			-- Error description that frame condition is violated
		do
			Result := locale.translation ("The frame condition of this feature may be violated.")
		end

	error_syntax_error: STRING_32
			-- Error message that a syntax error occured
		do
			Result := locale.translation ("Syntax error in Boogie code")
		end

	description_syntax_error: STRING_32
			-- Error description that a syntax error occured
		do
			Result := locale.translation ("The generated Boogie code contains a syntax error.%NPlease report this to the developers of EVE Proofs.")
		end

	error_old_expression_not_allowed: STRING_32
			-- Error message that a syntax error occured
		do
			Result := locale.translation ("Old expression not allowed")
		end

	description_old_expression_not_allowed: STRING_32
			-- Error description that a syntax error occured
		do
			Result := locale.translation ("An old expression in this context is not allowed for the verification.")
		end

	error_constant_type_not_supported: STRING_32
			-- Error message that a syntax error occured
		do
			Result := locale.translation ("Constant type not supported")
		end

	description_constant_type_not_supported: STRING_32
			-- Error description that a syntax error occured
		do
			Result := locale.translation ("The type of the constant is not supported.")
		end

feature -- Access: Message strings

	message_eve_proofs_started, window_message_eve_proofs_started: STRING_32
			-- Message that EVE Proofs started
		do
			Result := locale.translation ("EVE Proofs started")
		end

	message_generating_boogie_code: STRING_32
			-- Message that Boogie code generating started
		do
			Result := locale.translation ("Generating Boogie code")
		end

	message_generating_boogie_code_for_class (a_class: STRING_GENERAL): STRING_32
			-- Message that Boogie code is generated for `a_class'
		do
			Result := locale.formatted_string (locale.translation (" - Class $1"), [a_class])
		end

	message_generating_boogie_class_ignored (a_class: STRING_GENERAL): STRING_32
			-- Message that Boogie code is generated for `a_class'
		do
			Result := locale.formatted_string (locale.translation (" - Class $1 ignored due to indexing clause"), [a_class])
		end

	message_generating_referenced_features: STRING_32
			-- Message that Boogie code is generated for referenced features
		do
			Result := locale.translation (" - Referenced features")
		end

	window_message_generating_boogie_code_for_class (a_class: STRING_GENERAL): STRING_32
			-- Message that Boogie code is generated for `a_class'
		do
			Result := locale.formatted_string (locale.translation ("Generating Boogie code: $1"), [a_class])
		end

	window_message_generating_referenced_features: STRING_32
			-- Message that Boogie code is generated for referenced features
		do
			Result := locale.translation ("Generating Boogie code: Referenced features")
		end

	message_starting_verifier: STRING_32
			-- Message that verifier is being started
		do
			Result := locale.translation ("Starting verifier")
		end

	message_verifier_running: STRING_32
			-- Message that verifier is running
		do
			Result := locale.translation ("Verifier running")
		end

	message_verification_finished: STRING_32
			-- Message that verification was successful
		do
			Result := locale.translation ("Verification finished")
		end

	message_code_generation_failed: STRING_32
			-- Message that code generation failed
		do
			Result := locale.translation ("Code generation failed")
		end

	message_boogie_version (a_version: STRING_GENERAL): STRING_32
			-- Message which Boogie version is used
		do
			Result := locale.formatted_string (locale.translation ("Boogie version $1"), [a_version])
		end

	message_boogie_finished (a_verified, a_errors: STRING_GENERAL): STRING_32
			-- Message that Boogie has finished
		do
			Result := locale.formatted_string (locale.translation ("Boogie finished ($1 verified, $2 errors)"), [a_verified, a_errors])
		end

	message_verifying: STRING_32
			-- Message that Boogie is verifying
		do
			Result := locale.translation ("Veryfing")
		end

	message_failed: STRING_32
			-- Message that Boogie verification failed
		do
			Result := locale.translation ("failed")
		end

	message_successful: STRING_32
			-- Message that Boogie verification was successful
		do
			Result := locale.translation ("successful")
		end

feature -- Access: Command strings

	verify_class_menu_name: STRING_32
			-- Menu name to verify class
		do
			Result := locale.translation ("Verify class")
		end

	verify_class_menu_description: STRING_32
			-- Menu name to verify class
		do
			Result := locale.translation ("Statically verify class using EVE Proofs")
		end

	verify_class_context_menu_name (a_class: STRING_GENERAL): STRING_32
			-- Menu name to verify class
		do
			Result := locale.formatted_string (locale.translation ("Verify class $1"), [a_class])
		end

	verify_cluster_menu_name: STRING_32
			-- Menu name to verify class
		do
			Result := locale.translation ("Verify cluster")
		end

	verify_cluster_menu_description: STRING_32
			-- Menu name to verify class
		do
			Result := locale.translation ("Statically verify cluster using EVE Proofs")
		end

	verify_cluster_context_menu_name (a_cluster: STRING_GENERAL): STRING_32
			-- Menu name to verify class
		do
			Result := locale.formatted_string (locale.translation ("Verify cluster $1"), [a_cluster])
		end

	verify_library_context_menu_name (a_cluster: STRING_GENERAL): STRING_32
			-- Menu name to verify class
		do
			Result := locale.formatted_string (locale.translation ("Verify library $1"), [a_cluster])
		end

end
