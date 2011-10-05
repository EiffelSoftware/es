note
  description: "Summary description for {SSA_EXPR_NESTED}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_EXPR_NESTED

inherit
  SSA_EXPR

create
  make, make_unqual, make_create

feature
  make (a_target: SSA_EXPR; a_name: STRING; a_args: ARRAYED_LIST [SSA_EXPR])
    require
      non_void_target: attached a_target
    do
      target := a_target
      name := a_name
      args := a_args
      non_create := True
    end

  make_unqual (a_name: STRING; a_args: ARRAYED_LIST [SSA_EXPR])
    local
      this: SSA_EXPR_THIS
    do
      create this.make
      make (this, a_name, a_args)
    end

  make_create (a_target: SSA_EXPR;
               a_name: STRING;
               a_args: ARRAYED_LIST [SSA_EXPR])
    require
      non_void_target: attached a_target
    do
      target := a_target
      name := a_name
      args := a_args
      non_create := False
    end


  target: SSA_EXPR
  name: STRING
  args: ARRAYED_LIST [SSA_EXPR]

  goal_string (var_prefix: STRING): STRING
    local
      l_args: ARRAYED_LIST [SSA_EXPR]
    do      
      if is_attribute then
        Result := target.goal_string (var_prefix) + "." +
          target.type.name + "_" + name
      else
        l_args := args.twin
        l_args.put_front (target)

        Result := target.type.name + "_" + name + " ("

        from l_args.start
        until l_args.after
        loop
          Result := Result + l_args.item.goal_string (var_prefix)
          
          l_args.forth
          
          if not l_args.after then
            Result := Result + ", "
          end
        end
        
        Result := Result + ")"
      end
    end

  
  as_code: STRING
    do
      if attached {SSA_EXPR_THIS} target then
        Result := ""
      else
        Result := target.as_code + "."
      end
      
      Result := Result + name

      if not args.is_empty then
        Result := Result + " ("

        from
          args.start
        until
          args.after
        loop
          Result := Result + args.item.as_code
          args.forth

          if not args.after then
            Result := Result + ", "
          end
        end

        Result := Result + ")"
      end
    end

  non_create: BOOLEAN
  
  target_type: TYPE_A
    do
      Result := target.type
    end

  is_attribute: BOOLEAN
    do
      Result := featr_i.is_attribute or
        (featr_i.argument_count = 0 and not featr_i.has_postcondition)
    end
  
  featr_i: FEATURE_I
    do
      Result := target_type.associated_class.feature_named_32 (name)
    ensure
      attached Result
    end
      
  featr: ROUTINE_AS
    do
      Result := featr_i.body.body.as_routine
    end

  pre_condition: SSA_EXPR
    local
      non_void: SSA_EXPR_BIN
    do
      if non_create then
        create non_void.make ("/=",
                              target,
                              create {SSA_EXPR_VOID}.make (target_type))
      end

      if is_attribute then
        Result := non_void
      elseif non_create then
        Result := create {SSA_EXPR_BIN}.make ("and",
                                              from_pre (arg_map,
                                                        featr.precondition),
                                                        non_void)
      else
        Result := from_pre (arg_map, featr.precondition)
      end
    end

  arg_map: HASH_TABLE [SSA_EXPR, STRING]
    local
      i: INTEGER
    do
      create Result.make (10)
      Result.compare_objects
      from i := 1
      until i > featr_i.argument_count
      loop
        Result.put (create {SSA_EXPR_UNARY}.make ("old", args [i]),
                    featr_i.arguments.item_name (i))
        i := i + 1
      end
      Result.put (target, "Current")
    end
  
  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (10)

      Result.append (target.all_pre_conditions)

      across args as ac loop Result.append (ac.item.all_pre_conditions) end

      if attached pre_condition then
        Result.extend (pre_condition)
      end
    end


end
