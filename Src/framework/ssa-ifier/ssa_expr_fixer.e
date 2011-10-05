note
  description: "Summary description for {EXPR_FIXER}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_EXPR_FIXER

inherit
  AST_ITERATOR
    redefine
      process_id_as,
      process_void_as,
      process_nested_as,
      process_binary_as,
      process_access_feat_as,
      process_bool_as,
      process_object_test_as,
      process_unary_as,
      process_integer_as,
      process_result_as,
      process_create_creation_as,
      process_current_as
    end

  SSA_SHARED
  
create
  make

feature
  make (a_arg_map: HASH_TABLE [SSA_EXPR, STRING])
    do
      reset_state
      arg_map := a_arg_map
    end

  arg_map: HASH_TABLE [SSA_EXPR, STRING]

  convert_ast (expr: EXPR_AS): SSA_EXPR
    do
      reset_state
      safe_process (expr)
      Result := last_expr
    end

  reset_state
    do
      constructor := Void
      last_expr   := Void
    end

  constructor: FUNCTION [ANY, TUPLE[STRING, LIST[SSA_EXPR]], SSA_EXPR]
  last_expr: SSA_EXPR

  has_last_expr: BOOLEAN
    do
      Result := attached last_expr
    end

  last_expr_name: STRING
    do
      if attached {SSA_EXPR_NESTED} last_expr as nested then
        Result := nested.name
      elseif attached {SSA_EXPR_VAR} last_expr as var then
        Result := var.name
      end
    end

  last_expr_args: LIST [SSA_EXPR]
    do
      if attached {SSA_EXPR_NESTED} last_expr as nested then
        Result := nested.args
      else
        Result := empty_args
      end
    end

  empty_args: LIST [SSA_EXPR]
    do
      create {ARRAYED_LIST[SSA_EXPR]} Result.make (10)
    end

  construct_nested (a_target: SSA_EXPR;
                    a_name: STRING;
                    a_args: ARRAYED_LIST [SSA_EXPR]): SSA_EXPR
    do
      create {SSA_EXPR_NESTED} Result.make (a_target, a_name, a_args)
    end

  construct_create  (a_target: SSA_EXPR;
                    a_name: STRING;
                    a_args: ARRAYED_LIST [SSA_EXPR]): SSA_EXPR
    do
      create {SSA_EXPR_NESTED} Result.make_create (a_target, a_name, a_args)
    end


  process_create_creation_as (l_as: CREATE_CREATION_AS)
    do
      safe_process (l_as.target)
      constructor := agent construct_create (last_expr, ?, ?)
      safe_process (l_as.call)
    end

  process_current_as (l_as: CURRENT_AS)
    do
      if attached constructor then
        constructor.call ([l_as.access_name, empty_args])
        last_expr := constructor.last_result
      else
        last_expr := create {SSA_EXPR_VAR}.make (l_as.access_name)
      end
    end

  process_result_as (l_as: RESULT_AS)
    do
      last_expr := create {SSA_EXPR_RESULT}.make
    end

  process_id_as (l_as: ID_AS)
    do
      if attached constructor then
        constructor.call ([l_as.name_8, empty_args])
        last_expr := constructor.last_result
      else
        last_expr := create {SSA_EXPR_VAR}.make (l_as.name_32)
      end
    end

  process_void_as (l_as: VOID_AS)
    do
      last_expr := create {SSA_EXPR_VOID}.make (Void)
    end
  
  process_nested_as (l_as: NESTED_AS)
    do
      safe_process (l_as.target)

      if has_last_expr then
        constructor := agent construct_nested (last_expr, ? , ?)
      else
        constructor := Void
      end

      safe_process (l_as.message)
    end

  process_access_feat_as (l_as: ACCESS_FEAT_AS)
    do
      if attached constructor then
        constructor.call ([l_as.access_name_8, params_list (l_as.parameters)])
        last_expr := constructor.last_result
      elseif arg_map.has_key (l_as.access_name_8) then
        last_expr := arg_map.found_item
      elseif arg_map.has_key ("Current") then
        last_expr :=
          create {SSA_EXPR_NESTED}.make (arg_map.found_item,
                                         l_as.access_name_8,
                                         params_list (l_as.parameters))
      elseif not attached class_c.feature_named_32 (l_as.access_name_32) then
        last_expr := create {SSA_EXPR_VAR}.make (l_as.access_name_32)
      else
        last_expr :=
          create {SSA_EXPR_NESTED}.make_unqual
              (l_as.access_name_8, params_list (l_as.parameters))
      end
    end

  params_list (l_params: EIFFEL_LIST [EXPR_AS]): ARRAYED_LIST [SSA_EXPR]
    local
      expr_as: EXPR_AS
      saved_expr: SSA_EXPR
      saved_constr: FUNCTION [ANY, TUPLE[STRING, LIST[SSA_EXPR]], SSA_EXPR]
    do
      create {ARRAYED_LIST [SSA_EXPR]} Result.make (10)

      if attached l_params then
        saved_expr := last_expr
        saved_constr := constructor

        from
          l_params.start
          reset_state
        until
          l_params.after
        loop
          expr_as := l_params.item
          safe_process (expr_as)
          Result.extend (last_expr)

          reset_state
          l_params.forth
        end

        constructor := saved_constr
        last_expr := saved_expr
      end

    end

  process_bool_as (l_as: BOOL_AS)
    do
      create {SSA_EXPR_BOOLEAN} last_expr.make (l_as.value)
    end

  process_object_test_as (l_as: OBJECT_TEST_AS)
    local
      e: SSA_EXPR
    do
      safe_process (l_as.expression)
      e := last_expr
      reset_state

      create {SSA_EXPR_BIN}
        last_expr.make ("/=",
                        e,
                        create {SSA_EXPR_VOID}.make (e.type))
    end

  process_unary_as (l_as: UNARY_AS)
    local
      e: SSA_EXPR
    do
      safe_process (l_as.expr)
      e := last_expr

      reset_state

      create {SSA_EXPR_UNARY} last_expr.make (l_as.operator_name_32, e)
    end

  process_binary_as (l_as: BINARY_AS)
    local
      e1,e2: SSA_EXPR
    do
      safe_process (l_as.left)
      e1 := last_expr
      reset_state

      safe_process (l_as.right)
      e2 := last_expr
      reset_state

      create {SSA_EXPR_BIN} last_expr.make (l_as.op_name.name_32, e1, e2)
    end

  process_integer_as (l_as: INTEGER_AS)
    do
      create {SSA_EXPR_INTEGER} last_expr.make (l_as.integer_32_value)
    end

end
