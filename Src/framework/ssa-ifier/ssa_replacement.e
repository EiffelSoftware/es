note
	description: "Summary description for {AST_REPLACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_REPLACEMENT

create
	make

feature
	make (a_type: TYPE_A;
	      a_var: STRING;
	      a_text: STRING;
	      --a_target: STRING;
	      --a_call: AST_EIFFEL;
	      a_req: REQUIRE_AS)
		do
			type := a_type
			var := a_var
--			target := a_target
--			call := a_call
			repl_text := a_text
			req := a_req
		end


	type: TYPE_A
	var: STRING
	--target: STRING
	--call: AST_EIFFEL
	repl_text: STRING
	req: REQUIRE_AS
end
