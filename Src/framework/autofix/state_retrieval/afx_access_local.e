note
	description: "Summary description for {AFX_ACCESS_LOCAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ACCESS_LOCAL

inherit
	AFX_ACCESS
		redefine
			text,
			is_local,
			length
		end

	SHARED_STATELESS_VISITOR

create
	make

feature{NONE} -- Initialization

	make (a_class: like context_class; a_feature: like context_feature; a_local_name: STRING)
			-- Initialize Current with local named `a_local_name'.
		do
			make_with_class_feature (a_class, a_feature)
			text := a_local_name.as_lower
		end

feature -- Access

	type: TYPE_A
			-- Type of current access
		do
		end

	text: STRING
			-- Text of current access

	length: INTEGER is 1
			-- Length of current access

feature -- Status report

	is_local: BOOLEAN is True
			-- Is current access a local?

end
