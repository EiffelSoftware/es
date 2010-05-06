note
	description: "[
		Class represents a queryable property.
		A queryable property contains:
		1. The property itself, for example, l.is_empty.
		2. The category of that property (for example, precondition, postcondition, to change, by change).
		3. A boost value indicating how important the property is.		
		4. The matching criterion: SHOULD, MUST, MUST_NOT.
		
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_QUERYABLE_PROPERTY

feature -- Access

	context: EPA_CONTEXT
			-- Context within which current property is type checked

	category: INTEGER
			-- Category of current property


feature -- Constants

	precondition_category: INTEGER is 1
	postcondition_category: INTEGER is 2
	to_change_category: INTEGER is 3


invariant
	context_attached: context /= Void

end
