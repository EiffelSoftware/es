note
	description: "Summary description for {AFX_ACCESS_NESTED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_NESTED

inherit
	EPA_ACCESS_FEATURE
		rename
			make as make_feature
		undefine
			type,
			length
		redefine
			text,
			is_nested
		end

create
	make

feature{NONE} -- Initialization

	make (a_left: like left; a_right: like right)
			-- Initialize Current.
		require
			a_right.is_feature
		do
			left := a_left
			right := a_right
			make_feature (a_left.context_class, a_left.context_feature, a_right.feature_, a_right.arguments, a_left.written_class)

			create text.make (left.text.count + right.text.count + 1)
			if not left.is_current then
				text.append (left.text)
				text.append_character ('.')
			end
			text.append (right.text)
		ensure
			left_set: left = a_left
			right_set: right = a_right
		end

feature -- Access

	left: EPA_ACCESS
			-- Left part of the access

	right: EPA_ACCESS_FEATURE
			-- Right part of the access

	type: TYPE_A
			-- Type of current access
		do
			Result :=
				actual_type_from_formal_type (
					right.type.instantiation_in (left.type, left.type.associated_class.class_id).actual_type,
					left.type.associated_class)
		end

	text: STRING
			-- Text of current access

	length: INTEGER
			-- Length of current access
		do
			Result := left.length + right.length
		ensure then
			good_result: Result = left.length + right.length
		end

feature -- Status report

	is_nested: BOOLEAN is True
			-- Is Current access nested?

end
