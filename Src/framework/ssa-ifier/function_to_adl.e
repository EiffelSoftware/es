note
	description: "Summary description for {FUNCTION_TO_ADL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FUNCTION_TO_ADL

inherit
	AST_ITERATOR
		redefine
			process_id_as,
			process_nested_as,
			process_binary_as,
			process_access_feat_as,
			process_void_as,
			process_bool_as,
			process_unary_as,
			process_integer_as,
      process_result_as
		end

create
	make_for_domain

feature
	make_for_domain (a_class_name: STRING;
                   a_feature_name: STRING;
                   a_params: LIST [STRING])
    require
      non_void_names: attached a_class_name and attached a_feature_name
      non_void_params: attached a_params
		do
      params := a_params
      params.compare_objects
      feature_name := a_feature_name
      class_name := a_class_name
		end

  class_name: STRING
  feature_name: STRING

  target: STRING = "Current"
  
	params: LIST [STRING]

	last_expr: EXPR

  const_expr (str: STRING): CONST_EXPR
    do
      create Result.make_const (str)
    end

  var_expr (str: STRING): VAR_EXPR
    do
      create Result.make_var (str)
    end

  process_unprefixed_id (str: STRING): EXPR
    local
      targ: EXPR
    do
      if not params.has (str) then
        targ := var_expr (target)
        create {UN_EXPR} Result.make_un (class_name + "_" + str, targ)
      else
        Result := var_expr (str)
      end
    end
  
	process_id_as (l_as: ID_AS)
		do
			if attached last_expr then
				create {UN_EXPR} last_expr.make_un (l_as.name_8, last_expr)
			else
        last_expr := process_unprefixed_id (l_as.name_8)
      end
		end
  
	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			args: ARRAYED_LIST [EXPR]
			expr: EXPR
		do
			if attached last_expr then
				print (l_as.access_name_8 +"%N")
				create args.make (10)

				args.extend (last_expr)

				if attached l_as.parameters then
					from l_as.parameters.start
					until l_as.parameters.after
					loop
						safe_process (l_as.parameters.item)
						args.extend (last_expr)
					end
				end
				create expr.make (l_as.access_name_8, args)
				last_expr := expr
			else
        last_expr := process_unprefixed_id (l_as.access_name_8)
			end

		end

	process_nested_as (l_as: NESTED_AS)
		do
			safe_process (l_as.target)
			safe_process (l_as.message)
		end

	process_integer_as (l_as: INTEGER_AS)
		local
			cons: CONST_EXPR
		do
			create cons.make_const (l_as.integer_32_value.out)
			last_expr := cons
		end

	process_unary_as (l_as: UNARY_AS)
		local
			un: UN_EXPR
		do
			l_as.expr.process (Current)
			create un.make_un (l_as.operator_name_32, last_expr)
			last_expr := un
		end

	process_void_as (l_as: VOID_AS)
		do
			create {CONST_EXPR} last_expr.make_const ("Void")
		end

	process_bool_as (l_as: BOOL_AS)
		local
			cons: CONST_EXPR
		do
			create cons.make_const (l_as.is_true_keyword.out)
			last_expr := cons
		end

  result_seen: BOOLEAN
  
  process_result_as (l_as: RESULT_AS)
    do
      result_seen := True
    end
  
	process_binary_as (l_as: BINARY_AS)
		local
			bin: BIN_EXPR
			e1: EXPR
			e2: EXPR
      op: STRING
		do
			last_expr := Void
			l_as.left.process (Current)
			e1 := last_expr

      op := l_as.op_name.name_8
      
      if result_seen and op.is_equal ("=") then
        op := ":="
        result_seen := False
        e1 := create {CONST_EXPR}.make_const (class_name + "_" + feature_name)
      end
      
			last_expr := Void
			l_as.right.process (Current)
			e2 := last_expr

			create bin.make_bin (op, e1, e2)

			last_expr := bin
		end
end
