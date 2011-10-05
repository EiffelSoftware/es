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

  goal_string (var_prefix: STRING): STRING
    do
      Result := "(" + expr1.goal_string (var_prefix) + ") " + op +
                " (" + expr2.goal_string (var_prefix) + ")"
    end
  
  as_code: STRING
    do
      Result := "(" + expr1.as_code + ") " + op + " (" + expr2.as_code + ")"
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

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (10)

      Result.append (expr1.all_pre_conditions)
      Result.append (expr2.all_pre_conditions)
    end
end
