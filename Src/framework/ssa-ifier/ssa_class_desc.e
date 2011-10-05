class
  SSA_CLASS_DESC

create
  make

feature
  make (a_type: TYPE_A)
    do
      type := a_type

      create attributes.make (10)
      create functions.make (10)
      create procedures.make (10)
    end

  type: TYPE_A

  attributes: ARRAYED_LIST [SSA_DECL]
  functions: ARRAYED_LIST [SSA_FEATURE_DESC]
  procedures: ARRAYED_LIST [SSA_FEATURE_DESC]

invariant
  non_void_type: type /= Void
end
