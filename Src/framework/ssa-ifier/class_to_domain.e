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
		do
			setup (a_class, match_list_server.item (a_class.class_id), False, False)
			class_name := a_class.class_name.name_8

			create actions.make (10)
			create symb_defs.make (10)

			create domain.make (symb_defs, actions)
		end

	action_pre_sect: PRE_SECTION
	action_exprs: ARRAYED_LIST [EXPR]
	action_params: ARRAYED_LIST [STRING]

	domain: ADL_DOMAIN
	symb_defs: ARRAYED_LIST [SYMBOL_DEF]
	actions: ARRAYED_LIST [ADL_ACTION]
	class_name: STRING

	process_feature_as (l_as: FEATURE_AS)
		do
			if not attached l_as.body.type then
				add_feature_as_action (l_as)
			else
				add_feature_as_symbol (l_as)
			end
		end

	add_feature_as_symbol (l_as: FEATURE_AS)
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

			if type.text_32 (match_list).as_upper.is_equal ("BOOLEAN") then
				create symb_def.make_pred (l_as.feature_name.name_8, num_args)
			else
				create symb_def.make_func (l_as.feature_name.name_8, num_args)
			end

			symb_defs.extend (symb_def)
		end

	add_feature_as_action (l_as: FEATURE_AS)
		local
			arg_name: STRING
			i: INTEGER
			action: ADL_ACTION
			action_name: STRING
			feature_name: STRING
		do
			feature_name := l_as.feature_name.name_8

			create action_params.make (10)
			create action_exprs.make (10)
			create action_pre_sect.make
			action_name := class_name + "_" + feature_name
			create action.make (action_name, action_params, action_pre_sect, action_exprs)

			action_params.extend ("Current")
			action_pre_sect.generators.extend (create {PRE}.make_simple ("Current", type_name_to_gen_name (class_name)))

			if attached l_as.body.arguments as args then
				from
					i := 1
				until
					i > args.count
				loop
						-- doesn't take into account grouped type declarations
					arg_name := args [i].item_name (1)
					action_params.extend (arg_name)
					action_pre_sect.generators.extend (type_to_gen (arg_name, args[i].type))
					add_gen_to_domain (type_to_gen_def (args[i].type))
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

	type_to_gen (l_name: STRING; l_type: TYPE_AS): PRE
		do
			create Result.make_simple (l_name, type_to_gen_name (l_type))
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

	process_require_as (l_as: REQUIRE_AS)
		do
			is_require := True
			safe_process (l_as.assertions)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			is_require := False
			safe_process (l_as.assertions)
		end

	process_tagged_as (l_as: TAGGED_AS)
		local
			pre_convert: PRE_TO_ADL
			post_convert: POST_TO_ADL
		do
			if is_require then
				create pre_convert.make (action_params)
				l_as.expr.process (pre_convert)
				action_pre_sect.pre_exprs.extend (pre_convert.last_expr)
			else
				create post_convert.make (action_params)
				post_convert.wrap_expr_in_add (l_as)
				action_exprs.extend (post_convert.last_expr)
			end
		end

end
