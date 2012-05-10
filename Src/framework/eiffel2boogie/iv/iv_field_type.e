note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_FIELD_TYPE

inherit

	IV_TYPE

create
	make

feature {NONE} -- Initialization

	make (a_content_type: IV_TYPE)
			-- Initialize field type with content type `a_content_type'.
		require
			a_content_type_attached: attached a_content_type
		do
			content_type := a_content_type
		ensure
			content_type_set: content_type = a_content_type
		end

feature -- Access

	content_type: IV_TYPE
			-- Content type for this field type.

feature -- Visitor

	process (a_visitor: IV_TYPE_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_field_type (Current)
		end

end
