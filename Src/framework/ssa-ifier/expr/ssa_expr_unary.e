note
  description: "Summary description for {SSA_EXPR_UNARY}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_EXPR_UNARY

inherit
  SSA_EXPR
    redefine
      type
    end

create
  make

feature
  make (a_op: STRING; a_expr: SSA_EXPR)
    require
      non_void_un_expr: attached a_expr
    do
      op := a_op
      expr := a_expr
    end

  op: STRING
  expr: SSA_EXPR

  goal_string (var_prefix: STRING): STRING
    do
      Result := op + " (" + expr.goal_string (var_prefix) + ")"
    end
  
  as_code: STRING
    do
      Result := op + " (" + expr.as_code + ")"
    end

  is_old: BOOLEAN
    do
      Result := op.is_equal ("old")
    end

  type: TYPE_A
    do
      if is_old then
        Result := expr.type
      else
        Result := Precursor
      end
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      Result := expr.all_pre_conditions
    end
end
