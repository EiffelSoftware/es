note
	description: "Summary description for {AFX_FEATURE_BOOL_STATE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_BOOL_STATE_ITEM

inherit
	AFX_FEATURE_BASED_STATE_ITEM
		redefine
			value,
			type
		end

create
	make,
	make_with_value

feature -- Access

	value: detachable BOOLEAN_REF
			-- Value current item

	type: detachable BOOLEAN_A
			-- Type of current state
		do
			Result := boolean_type
		ensure then
			result_set: Result = boolean_type
		end

end
