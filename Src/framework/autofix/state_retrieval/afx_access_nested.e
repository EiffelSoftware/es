note
	description: "Summary description for {AFX_ACCESS_NESTED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ACCESS_NESTED

inherit
	AFX_ACCESS
		redefine
			text,
			is_feature
		end

create
	make

feature{NONE} -- Initialization

	make (a_left: like left; a_right: like right)
			-- Initialize Current.
		do
			make_with_class_feature (a_left.context_class, a_left.context_feature)
			left := a_left
			right := a_right
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

	left: AFX_ACCESS
			-- Left part of the access

	right: AFX_ACCESS
			-- Right part of the access

	type: TYPE_A
			-- Type of current access
		do
			Result := right.type.instantiation_in (left.type, left.type.associated_class.class_id).actual_type
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

	is_feature: BOOLEAN
			-- Is Current access a feature?
		do
			Result := right.is_feature
		ensure then
			good_result: Result = right.is_feature
		end


end
