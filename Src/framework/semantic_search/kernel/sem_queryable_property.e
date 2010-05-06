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

inherit
	SEM_FIELD_NAMES

feature -- Access

	context: EPA_CONTEXT
			-- Context within which current property is type checked

	category: INTEGER
			-- Category of current property


feature -- Constants




invariant
	context_attached: context /= Void

end
