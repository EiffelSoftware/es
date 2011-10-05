class
  SSA_EXPR_VOID

inherit
  SSA_EXPR
    redefine
      type
    end
  
create
  make

feature
  make (a_type: TYPE_A)
    do
      type := a_type
    end

  type: TYPE_A
  as_code: STRING = "Void"

  goal_string (var_prefix: STRING): STRING
    do
      Result := "null"
    end
  
  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (10)
    end
end


