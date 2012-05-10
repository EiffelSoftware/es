note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_VALUE

inherit

	IV_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_value: STRING; a_type: IV_TYPE)
			-- Initialize with value `a_value' of type `a_type'.
		do
			value := a_value.twin
			type := a_type
		ensure
			value_set: value ~ a_value
			type_set: type = a_type
		end

feature -- Access

	value: STRING
			-- Value expressed as a string.

	type: IV_TYPE
			-- Type of value.

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_value (Current)
		end

invariant
	value_attached: attached value

end
