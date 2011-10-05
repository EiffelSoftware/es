note
  description: "Summary description for {SSA_EXPR_VAR}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_EXPR_RESULT

inherit
  SSA_EXPR

create
  make

feature
  make
    do
    end

  goal_string (var_prefix: STRING): STRING
    do
      Result := "Result"
    end
  
  as_code: STRING
    do
      Result := "Result"
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (0)
    end
  
end
