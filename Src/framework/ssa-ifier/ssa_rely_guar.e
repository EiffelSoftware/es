class
  SSA_RELY_GUAR

inherit
  SSA_SHARED
  
  AST_ITERATOR
    redefine
      process_tagged_as,
      process_feature_as
    end

create
  make

feature
  make
    do
    end

  rely_str: STRING
  
  process_feature_as (l_as: FEATURE_AS)
    do
      set_feature (class_c.feature_named_32 (l_as.feature_name.name_32))
      Precursor (l_as)
    end

  
  process_tagged_as (l_as: TAGGED_AS)
    local
      fixer: SSA_EXPR_FIXER
      expr: SSA_EXPR
    do
      if attached l_as.tag as tag then
        if tag.name_8.is_equal ("rely") then
          create fixer.make (feat_arguments)
          l_as.process (fixer)
          expr := fixer.last_expr

          rely_str := expr.goal_string ("")
        end
      end
    end

end
