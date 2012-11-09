note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SUCCESSFUL_VERIFICATION

inherit

	E2B_FEATURE_RESULT
		rename
			data as procedure_result
		redefine
			help_text,
			single_line_help_text,
			procedure_result
		end

create
	make

feature {NONE} -- Initialization

	make (a_procedure_result: E2B_PROCEDURE_RESULT)
			-- Initialize.
		do
			initialize (a_procedure_result.eiffel_class, a_procedure_result.eiffel_feature)
			set_class (a_procedure_result.eiffel_class)
			set_feature (a_procedure_result.eiffel_feature)
			create original_errors.make
		end

feature -- Access

	procedure_result: E2B_PROCEDURE_RESULT
			-- Procedure result associated with this event.

	description: STRING_32
			-- <Precursor>
		do
			Result := "Verification of {" + context_class.name_in_upper + "}." + context_feature.feature_name_32.as_lower + " successful."
		end

feature -- Access

	original_errors: LINKED_LIST [E2B_VERIFICATION_ERROR]
			-- Original errors (if any)

	help_text: attached LIST [STRING]
			-- <Precursor>
		do
			create {LINKED_LIST [STRING]} Result.make
			Result.extend ("Verification of {" + class_c.name_in_upper + "}." + e_feature.name_8.as_lower + " successful.")
		end

	single_line_help_text: STRING
			-- <Precursor>
		do
			Result := "Verification of {" + class_c.name_in_upper + "}." + e_feature.name_8.as_lower + " successful."
		end

end
