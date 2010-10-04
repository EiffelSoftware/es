note
	description: "Summary description for {INTERGER_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGER_VALUE

inherit
	VALUE

create
	make

feature
	make (i : INTEGER)
		do
			int := i
		end

	int : INTEGER


	execute (env : PLAN_ENVIRONMENT) : ANY
		do
			Result := int
		end

end
