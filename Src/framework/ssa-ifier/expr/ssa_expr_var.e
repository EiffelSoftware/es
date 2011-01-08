note
	description: "Summary description for {SSA_EXPR_VAR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_VAR

inherit
	SSA_EXPR

create
	make

feature
	make (a_name: STRING)
		do
			name := a_name
		end

	name: STRING

	replacements: LIST [SSA_REPLACEMENT]
		local
			epa_expr: EPA_AST_EXPRESSION
			type: TYPE_A
			repl: SSA_REPLACEMENT
			pref_name: STRING
		do
			create epa_expr.make_with_text (class_c, feature_i, name, class_c)
			type := epa_expr.type

			pref_name := ssa_prefix
			create repl.make (type, pref_name , pref_name + " := " + name, Void, Void)

			create {ARRAYED_LIST [SSA_REPLACEMENT]} Result.make (10)
			Result.extend (repl)
		end

	req: REQUIRE_AS
		local
			body: BODY_AS
		do
			if attached class_c.feature_named_32 (name) as f then
				body := f.body.body
				if attached body.as_routine as rout then
					Result := rout.precondition
				end
			end
		end

	as_code: STRING
		do
			Result := name
		end
end
