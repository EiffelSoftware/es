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
		redefine
			help_text,
			single_line_help_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_procedure_result: E2B_PROCEDURE_RESULT)
			-- Initialize.
		do
			set_class (a_procedure_result.eiffel_class)
			set_feature (a_procedure_result.eiffel_feature)
			create original_errors.make
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
