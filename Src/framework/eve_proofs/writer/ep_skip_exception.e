indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class EP_SKIP_EXCEPTION

inherit

	DEVELOPER_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make (a_reason: STRING)
			-- TODO
		do
			make_with_tag_and_trace (a_reason, "")
		end

end
