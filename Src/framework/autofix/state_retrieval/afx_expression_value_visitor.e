note
	description: "Summary description for {AFX_EXPRESSION_VALUE_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPRESSION_VALUE_VISITOR

feature -- Process

	process_boolean_value (a_value: AFX_BOOLEAN_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_random_boolean_value (a_value: AFX_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_integer_value (a_value: AFX_INTEGER_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_nonsensical_value (a_value: AFX_NONSENSICAL_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_void_value (a_value: AFX_VOID_VALUE)
			-- Process `a_value'.
		deferred
		end

end
