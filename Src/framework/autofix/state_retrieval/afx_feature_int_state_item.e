note
	description: "Summary description for {AFX_FEATURE_INT_STATE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_INT_STATE_ITEM

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

	value: detachable INTEGER_REF
			-- Value current item

	type: detachable INTEGER_A
			-- Type of current state
		do
			Result := integer_type
		ensure then
			result_set: Result = integer_type
		end

end
