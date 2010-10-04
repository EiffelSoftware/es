note
	description: "Summary description for {AST_REPLACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_REPLACE

create
	make

feature
	make (a_type: TYPE_A;
	      a_var, a_target, a_call: STRING
	      a_req: REQUIRE_AS)
		do
			type := a_type
			var := a_var
			target := a_target
			call := a_call
			req := a_req
		end

	type: TYPE_A
	var: STRING
	target: STRING
	call: STRING
	req: REQUIRE_AS

end
