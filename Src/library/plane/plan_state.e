note
	description: "Summary description for {PLAN_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_STATE

create
	make

feature
	make
		do
			create predicates.make (10)
			create functions.make (10)
		end

	predicates: HASH_TABLE [LIST[STRING], STRING]
	functions: ARRAYED_LIST [TUPLE [VALUE, VALUE]]

end
