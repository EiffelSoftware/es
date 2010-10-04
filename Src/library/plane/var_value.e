note
	description: "Summary description for {VAR_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VAR_VALUE

inherit VALUE

create
	make

feature
	make (id : STRING)
		do
			ident := id.twin
		end

	ident : STRING

	execute (env : ENVIRONMENT) : ANY
		do
			Result := env.lookup_var (ident)
		end

	tag : STRING
		do
			Result := "var_"
		end


end
