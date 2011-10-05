class SSA_EXPR_THIS

inherit
  SSA_EXPR
    redefine
      type
    end

create
  make

feature
  make
    do

    end

  goal_string (var_prefix: STRING): STRING
    do
      Result := var_prefix + "Current"
    end
  
  as_code: STRING
    do
      Result := "Current"
    end

  type: TYPE_A
    do
      Result := class_c.actual_type
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (10)
    end

end
