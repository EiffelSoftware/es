note
  description: "Summary description for {SSA_EXPR}."

deferred class
  SSA_EXPR

inherit
  SSA_SHARED

feature
  as_code: STRING
    deferred
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    deferred
    end

  single_precond (var_prefix: STRING): STRING
    local
      pres: ARRAYED_LIST [SSA_EXPR]
    do
      pres := all_pre_conditions
      Result := ""

      if pres.is_empty then
        Result := "True"
      elseif pres.count = 1 then
        Result := pres [1].goal_string (var_prefix)
      else
        from pres.start
        until pres.after
        loop
          Result := Result + "%N%T" + pres.item.goal_string (var_prefix)
          pres.forth
          if not pres.after then
            Result := Result + " and"
          end
        end
      end
    end

  ssa_prefix: STRING
    do
      Result := "ssatemp_" + get_count.out
    end

  type: TYPE_A
    local
      epa_expr: EPA_AST_EXPRESSION
    do
      create epa_expr.make_with_text (class_c, feature_i, as_code, class_c)
      Result := epa_expr.type
    ensure
      non_void_result: attached Result
    end

feature -- Goal serialization of this call as a string
  goal_string (var_prefix: STRING) : STRING
    deferred
    end

feature -- Precondition of expression

  from_pre (args: HASH_TABLE [SSA_EXPR, STRING]; a_as: ASSERT_LIST_AS): SSA_EXPR
    local
      pre: SSA_EXPR
      pres: LIST [TAGGED_AS]
      pres_ssa: ARRAYED_LIST [SSA_EXPR]
      fix: SSA_EXPR_FIXER
    do
      create pres_ssa.make (10)
      create fix.make (args)
      create {SSA_EXPR_BOOLEAN} Result.make (True)

      if attached a_as then
        pres := a_as.assertions
        
        from
          pres.start
        until
          pres.after
        loop
          pres.item.process (fix)
          pre := fix.last_expr
          pres_ssa.extend (pre)
          create {SSA_EXPR_BIN} Result.make ("and", Result, pre)
          pres.forth
        end
      else
        
      end
    end
end

