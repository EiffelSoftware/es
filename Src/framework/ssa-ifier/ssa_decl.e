class
  SSA_DECL

inherit
  SSA_SHARED
    undefine
      is_equal
    end

  ANY
    redefine
      is_equal
    end

  
create
  make, make_in_feature

feature
  make_in_feature (a_name: STRING)
    local
      epa: EPA_AST_EXPRESSION
    do
      create epa.make_with_text (class_c, feature_i, a_name, class_c)
      type := epa.type
      name := a_name
    end

  make (a_name: STRING; a_type: TYPE_A)
    require
      non_void_name: a_name /= Void and then not a_name.is_empty
      non_void_type: a_type /= Void
    do
      name := a_name
      type := a_type
    end

  name: STRING
  type: TYPE_A

  is_equal (a_obj: like Current): BOOLEAN
    do
      Result := name.is_equal (a_obj.name) and
        type.name.is_equal (a_obj.type.name)
    end
  
end

