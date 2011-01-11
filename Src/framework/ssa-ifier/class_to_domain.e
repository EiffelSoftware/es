note
	description: "Summary description for {CLASS_TO_DOMAIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLASS_TO_DOMAIN

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_require_as,
			process_ensure_as,
			process_tagged_as,
			process_feature_as
		end

	SHARED_SERVER

create
	make

feature
  make (a_class: CLASS_AS)
    local
      gen_def: GENERATOR_DEF
    do
      setup (a_class, match_list_server.item (a_class.class_id), False, False)
      class_name := a_class.class_name.name_8
      
      create actions.make (10)
      create desc_symbs.make (10)
      create defn_symbs.make (10)
      create def_fns.make (10)
      
      create domain.make (desc_symbs, def_fns, actions)
      
      create gen_def.make_gen
        (type_name_to_gen_name (a_class.class_name.name_32))
      desc_symbs.extend (gen_def)
    end

  action_pre_sect: PRE_SECTION
  action_exprs: ARRAYED_LIST [EXPR]
  action_params: ARRAYED_LIST [STRING]

  domain: ADL_DOMAIN
  desc_symbs: ARRAYED_LIST [SYMBOL_DEF]
  defn_symbs: ARRAYED_LIST [SYMBOL_DEF]
  def_fns: ARRAYED_LIST [DEFINED_FUNC]
  
  actions: ARRAYED_LIST [ADL_ACTION]
  class_name: STRING
  feature_name: STRING

  in_function: BOOLEAN
  
  process_feature_as (l_as: FEATURE_AS)
    do
      feature_name := l_as.feature_name.name_8
      if l_as.is_procedure then
        add_command (l_as)
      elseif l_as.is_attribute then
        add_attribute (l_as)
      elseif l_as.is_function then
        add_function (l_as)
      end
    end

  add_function (l_as: FEATURE_AS)
    do
      add_function_symb (l_as)
      add_function_def (l_as)
    end
  
  add_function_symb (l_as: FEATURE_AS)
    local
      symb_def: SYMBOL_DEF
      type: TYPE_AS
      num_args: INTEGER      
    do
      type := l_as.body.type

      if attached l_as.body.arguments as args then
        num_args := args.count + 1
      else
        num_args := 1
      end

      if is_boolean_type (type) then
        create symb_def.make_pred (symbol_name, num_args)
      else
        create symb_def.make_func (symbol_name, num_args)
      end

      defn_symbs.extend (symb_def)
    end

    
  add_function_def (l_as: FEATURE_AS)
    local
      arg_name: STRING
      i: INTEGER
      fn_def: DEFINED_FUNC
      pre: PRE
    do
      create action_params.make (10)
      create action_exprs.make (10)

      create fn_def.make (symbol_name, action_params, action_exprs)

      action_params.extend ("Current")

      create pre.make_simple ("Current", type_name_to_gen_name (class_name))
      action_pre_sect.generators.extend (pre)

      if attached l_as.body.arguments as args then
        from
          i := 1
        until
          i > args.count
        loop
            -- doesn't take into account grouped type declarations
          arg_name := args [i].item_name (1)
          action_params.extend (arg_name)

          i := i + 1
        end
      end
      -- safe_process (l_as.body.as_routine)

      in_function := True
      safe_process (l_as.body.as_routine)
      in_function := False
      
      def_fns.extend (fn_def)
    end


  
  add_attribute (l_as: FEATURE_AS)
    local
      symb_def: SYMBOL_DEF
      type: TYPE_AS
      num_args: INTEGER
    do
      type := l_as.body.type

      if attached l_as.body.arguments as args then
        num_args := args.count
      else
        num_args := 0
      end

      num_args := num_args + 1

      if is_boolean_type (type) then
        create symb_def.make_pred (symbol_name, 1)
      else
        create symb_def.make_func (symbol_name, 1)
      end

      desc_symbs.extend (symb_def)
    end

  is_boolean_type (type: TYPE_AS): BOOLEAN
    do
      Result := type.text_32 (match_list).as_upper.is_equal ("BOOLEAN")
    end
  
  add_command (l_as: FEATURE_AS)
    local
      arg_name: STRING
      i: INTEGER
      action: ADL_ACTION
      pre: PRE
    do
      create action_params.make (10)
      create action_exprs.make (10)
      create action_pre_sect.make
      create action.make (symbol_name, action_params,
                          action_pre_sect, action_exprs)

      action_params.extend ("Current")

      create pre.make_simple ("Current", type_name_to_gen_name (class_name))
      action_pre_sect.generators.extend (pre)

      if attached l_as.body.arguments as args then
        from
          i := 1
        until
          i > args.count
        loop
            -- doesn't take into account grouped type declarations
          arg_name := args [i].item_name (1)
          action_params.extend (arg_name)

          if not is_boolean_type (args [i].type) then
            action_pre_sect.generators.extend (type_to_gen (arg_name,
                                                            args[i].type))
            add_gen_to_domain (type_to_gen_def (args[i].type))
          end
          i := i + 1
        end
      end
      safe_process (l_as.body.as_routine)
      actions.extend (action)
    end

	add_gen_to_domain (gen: GENERATOR_DEF)
		do
			domain.symbols.compare_objects
			if not domain.symbols.has (gen) then
				domain.symbols.extend (gen)
			end
		end

  symbol_name: STRING
    do
      Result := class_name.as_upper + "_" + feature_name
    end
  
	type_to_gen (l_name: STRING; l_type: TYPE_AS): PRE
		do
			if l_type.text_32 (match_list).as_lower.is_equal ("integer") then
				create Result.make_integer (l_name)
			else
				create Result.make_simple (l_name, type_to_gen_name (l_type))
			end
		end

	type_to_gen_def (l_type: TYPE_AS): GENERATOR_DEF
		do
			create Result.make_gen (type_to_gen_name (l_type))
		end

	type_name_to_gen_name (str: STRING): STRING
		do
			Result := str + "_gen"
		end

	type_to_gen_name (l_type: TYPE_AS): STRING
		do
			Result := type_name_to_gen_name (l_type.text_32 (match_list))
		end

	is_require: BOOLEAN
  is_ensure: BOOLEAN
  
  
	process_require_as (l_as: REQUIRE_AS)
		do
			is_require := True
			safe_process (l_as.assertions)
      is_require := False
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			is_ensure := True
			safe_process (l_as.assertions)
      is_ensure := False
		end

	process_tagged_as (l_as: TAGGED_AS)
		local
			pre_convert: PRE_TO_ADL
			post_convert: POST_TO_ADL
      func_convert: FUNCTION_TO_ADL
		do
			if is_require then
				create pre_convert.make_for_domain (class_name, action_params)
				l_as.expr.process (pre_convert)
				action_pre_sect.pre_exprs.extend (pre_convert.last_expr)
			elseif is_ensure then
        if in_function then
          create func_convert.make_for_domain (class_name,
                                               feature_name,
                                               action_params)
          l_as.expr.process (func_convert)
          action_exprs.extend (func_convert.last_expr)
        else
          create post_convert.make_for_domain (class_name, action_params)
          post_convert.wrap_expr_in_add (l_as)
          action_exprs.extend (post_convert.last_expr)
        end
			end
		end

end
