note
	description: "Summary description for {SSA_EXPR_BIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_BIN

inherit
	SSA_EXPR

create
	make

feature
	make (a_op: STRING; a_e1, a_e2: SSA_EXPR)
		do
			op := a_op
			expr1 := a_e1
			expr2 := a_e2
		end

	op: STRING
	expr1, expr2: SSA_EXPR

	as_code: STRING
		do
			Result := "(" + expr1.as_code + ") " + op + " (" + expr2.as_code + ")"
		end

	replacements: LIST [SSA_REPLACEMENT]
    local
      repl1, repl2: LIST [SSA_REPLACEMENT]
      repl: SSA_REPLACEMENT
      repls: ARRAYED_LIST [SSA_REPLACEMENT]
      text: STRING
		do
      create repls.make (10)
      repl1 := expr1.replacements
      repl2 := expr2.replacements

      repls.append (repl1)
      repls.append (repl2)

      text := repl1.last.var + op + repl2.last.var

      create repl.make (res_type (repl1.last.type),
                        ssa_prefix,
                        text,
                        Void,
                        Void,
                        feat (repl1.last.type)
                        )

      repls.extend (repl)
      Result := repls
		end

  res_type (a_type: TYPE_A): TYPE_A
    local
      epa_expr: EPA_AST_EXPRESSION
    do
      create epa_expr.make_with_text (class_c, feature_i, as_code, class_c)
      Result := epa_expr.type
    end

  feat (a_type: TYPE_A): FEATURE_I
    do
      Result := Void
    end

end
