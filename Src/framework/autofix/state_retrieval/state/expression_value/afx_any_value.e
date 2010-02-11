note
	description: "Summary description for {AFX_ANY_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ANY_VALUE

inherit
	AFX_EXPRESSION_VALUE

	SHARED_TYPES
		undefine
			is_equal,
			out
		end

	SHARED_WORKBENCH
		undefine
			is_equal,
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item)
		-- Initialize Current.
		do
			item := a_item
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := system.any_class.compiled_representation.actual_type
		end

	item: ANY
			-- Value item in current

feature -- Process

	process (a_visitor: AFX_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
		end

end
