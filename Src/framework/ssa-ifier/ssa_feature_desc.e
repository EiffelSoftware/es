class
  SSA_FEATURE_DESC

create
  make

feature
  make (a_name: STRING)
    do
      name := a_name
      create arguments.make (10)
      create preconds.make (10)
      create postconds.make (10)
    end

  set_type (a_type: TYPE_A)
    do
      type := a_type
    end

  type: TYPE_A
  
  name: STRING

  arguments: ARRAYED_LIST [SSA_DECL]
  
  preconds: ARRAYED_LIST [SSA_EXPR]
  postconds: ARRAYED_LIST [SSA_EXPR]
  
end

