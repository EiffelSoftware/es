note
	description: "Summary description for {AFX_ACCESS_CURRENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_CURRENT

inherit
	EPA_ACCESS
		rename
			make_with_class_feature as make
		redefine
			is_current,
			length
		end

create
	make

feature -- Access

	type: TYPE_A
			-- Type of current access
		do
			Result := context_class.actual_type
		end

	text: STRING
			-- Text of current access
		do
			Result := once "Current"
		ensure then
			good_result: Result.is_equal ("Current")
		end

	length: INTEGER = 1
			-- Length of current access

feature -- Status report

	is_current: BOOLEAN = True
			-- Is current access is "Current"?

end
