indexing
	description: "Summary description for {JS_NOT_SUPPORTED_EXCEPTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_NOT_SUPPORTED_EXCEPTION

inherit

	DEVELOPER_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make (a_reason: STRING)
		do
			make_with_tag_and_trace (a_reason, "")
		end

end
