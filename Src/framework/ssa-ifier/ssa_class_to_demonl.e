note
  description: "Summary description for {CLASS_TO_DOMAIN}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_CLASS_TO_DEMONL

inherit
  AST_ROUNDTRIP_ITERATOR
    redefine
      process_require_as,
      process_ensure_as,
      process_tagged_as,
      process_feature_clause_as,
      process_feature_as,
      process_do_as
    end

  SSA_SHARED

  SHARED_SERVER

create
  make

feature
  make (a_class: CLASS_C)
    local
      dmn: SSA_DEMONL_DOMAIN
      ast: CLASS_AS
    do
      create extra_attrs.make (10)

      in_do := False
      
      current_class := a_class
      ast := a_class.ast

      setup (ast, match_list_server.item (ast.class_id),
             False, False)
      create class_desc.make (a_class.actual_type)
      set_class (a_class)
      process_ast_node (ast)
    end

  current_class: CLASS_C
  current_feature: FEATURE_I
  feature_desc: SSA_FEATURE_DESC
  class_desc: SSA_CLASS_DESC

      -- Are we currently processing the body of a routine?
  in_do: BOOLEAN
  

  process_do_as (l_as: DO_AS)
    do
      in_do := True
      Precursor (l_as)
      in_do := False                 
    end
  
  process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
    do
      if attached l_as.clients and then
        l_as.clients.clients.i_th (1).name_8.is_equal ("NONE") then
      else
        l_as.features.process (Current)
      end
    end

  process_feature_as (l_as: FEATURE_AS)
    local
      f: FEATURE_I
    do
      current_feature :=
        current_class.feature_named_32 (l_as.feature_name.name_32)
      create feature_desc.make (l_as.feature_name.name_8)

      set_feature (current_feature)

      if l_as.is_attribute then
        add_attribute (l_as)
      elseif l_as.is_function then
        if (attached l_as.body.arguments as args implies args.count = 0) and
           (attached l_as.body.as_routine as rout and then
            attached rout.postcondition as post and then
            attached post.assertions as asserts implies
            asserts.count = 0) then
          add_extra_attr (current_class.name, l_as.feature_name.name_32)
          add_attribute (l_as)
        else
          add_function (l_as)
        end
      elseif l_as.is_procedure then
        add_procedure (l_as)
      end

      feature_desc := Void
    end

  extra_attrs: ARRAYED_LIST [TUPLE [STRING, STRING]]
  
  add_extra_attr (class_name: STRING; feat_name: STRING)
    do
      extra_attrs.extend ([class_name, feature_name])
    end
  
  add_attribute (l_as: FEATURE_AS)
    local
      name: STRING
      decl: SSA_DECL
      epa: EPA_AST_EXPRESSION
      type: TYPE_A
    do
      name := l_as.feature_name.name_32
      create epa.make_with_text (current_class,
                                 current_feature,
                                 name,
                                 current_class)
      type := epa.type

      if not ignored_class (type.associated_class) then
        create decl.make (name, type)

        class_desc.attributes.extend (decl)
      end
    end

  add_function (l_as: FEATURE_AS)
    local
      arg_name: STRING
      i: INTEGER
    do
      feature_desc.set_type (
        class_c.feature_named_32 (l_as.feature_name.name_32).type
        )

      if attached l_as.body.arguments as args then
        from
          i := 1
        until
          i > args.count
        loop
          -- doesn't take into account grouped type declarations
          arg_name := args [i].item_name (1)
          feature_desc.arguments.extend (name_to_decl (arg_name))

          i := i + 1
        end
      end
      safe_process (l_as.body.as_routine)

      class_desc.functions.extend (feature_desc)
    end

  add_procedure (l_as: FEATURE_AS)
    local
      arg_name: STRING
      i: INTEGER
    do
      if attached l_as.body.arguments as args then
        from
          i := 1
        until
          i > args.count
        loop
            -- doesn't take into account grouped type declarations
          arg_name := args [i].item_name (1)
          feature_desc.arguments.extend (name_to_decl (arg_name))

          i := i + 1
        end
      end
      safe_process (l_as.body.as_routine)

      class_desc.procedures.extend (feature_desc)
    end

  name_to_decl (a_name: STRING): SSA_DECL
    local
      epa_expr: EPA_AST_EXPRESSION
    do
      create epa_expr.make_with_text (current_class,
                                      current_feature,
                                      a_name,
                                      current_class)
      create Result.make (a_name, epa_expr.type)
    end

feature -- Invariant processing
  process_require_as (l_as: REQUIRE_AS)
    do
      invariants := feature_desc.preconds
      safe_process (l_as.assertions)
    end

  process_ensure_as (l_as: ENSURE_AS)
    do
      invariants := feature_desc.postconds
      safe_process (l_as.assertions)
    end

  process_tagged_as (l_as: TAGGED_AS)
    local
      fixer: SSA_EXPR_FIXER
      expr: SSA_EXPR
    do
      if attached feature_desc and not in_do then
        if attached l_as.tag and then l_as.tag.name_8.is_equal ("rely") then
        else
          create fixer.make (feat_arguments) -- feature_desc.arguments)
          expr := fixer.convert_ast (l_as.expr)
          invariants.extend (expr)
        end
      else
        print ("TODO: Class invariant not processed%N")
      end
    end

  invariants: LIST [SSA_EXPR]
end
