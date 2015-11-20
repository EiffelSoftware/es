note
	description: "Summary description for {AFX_UNMATCHED_INSPECT_VALUE_EXCEPTION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UNMATCHED_INSPECT_VALUE_EXCEPTION_SIGNATURE

inherit
	AFX_EXCEPTION_SIGNATURE
		redefine
			analyze_exception_condition
		end

create make

feature{NONE} -- Initialization

	make (a_recipient_class: CLASS_C; a_recipient_feature: FEATURE_I; a_recipient_breakpoint: INTEGER)
			-- Initialization.
		do
			set_exception_code ({EXCEP_CONST}.Incorrect_inspect_value)
			make_common (Void, Void, 0, 0, a_recipient_class, a_recipient_feature, a_recipient_breakpoint, 0)
		end

feature{NONE} -- Implementation

	analyze_exception_condition_in_recipient
			-- <Precursor>
		local
		do

		end

	analyze_exception_condition
			-- <Precursor>
		local
		do

		end

end
