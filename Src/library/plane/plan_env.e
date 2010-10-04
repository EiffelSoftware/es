note
	description: "Summary description for {ENVIRONMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_ENV

create
	make

feature
	make
		do
			create var_table.make (10)
		end

	lookup_var (key : STRING) : ANY
		do
			Result := var_table [key]
		end

	lookup_func (key : STRING): ROUTINE [ANY, TUPLE]
		do
			Result := rout_table [key]
		end

feature {NONE}
	rout_table : HASH_TABLE [ROUTINE [ANY, TUPLE], STRING]
	var_table : HASH_TABLE [ANY, STRING]

end
