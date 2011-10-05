note
  description: "Summary description for {SSA_EXPR_BOOLEAN}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_EXPR_BOOLEAN

inherit
  SSA_EXPR

create
  make

feature
  make (a_bool: BOOLEAN)
    do
      boolean := a_bool
    end

  boolean: BOOLEAN

  goal_string (var_prefix: STRING): STRING
    do
      if boolean then
        Result := "True"
      else
        Result := "False"
      end
    end
  
  as_code: STRING
    do
      Result := boolean.out
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (10)
    end
end
