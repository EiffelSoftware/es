indexing
	description: "Summary description for {MY_SHARED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_SHARED

create
	make

feature --init

	make is
			-- creation
		do
			create some_string.make_from_string("test")
			some_int := 5
		end

	some_int:INTEGER

	some_string:STRING


end
