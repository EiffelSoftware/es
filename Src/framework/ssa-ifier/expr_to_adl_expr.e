note
	description: "Summary description for {PRE_TO_ADL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRE_TO_ADL

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
			process_integer_as
		end

create
	make

feature
	make (a_params: LIST [STRING])
		do
			params := a_params
			params.compare_objects
		end

	params: LIST [STRING]

	last_expr: EXPR

	process_id_as (l_as: ID_AS)
		do
			if attached last_expr then
				create {UN_EXPR} last_expr.make_un (l_as.name_8, last_expr)
			elseif not params.has (l_as.name_8) then
				create {UN_EXPR} last_expr.make_un (l_as.name_8, create {VAR_EXPR}.make_var ("Current"))
			else
				create {VAR_EXPR} last_expr.make_var (l_as.name_8)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			args: ARRAYED_LIST [EXPR]
			expr: EXPR
			var: VAR_EXPR
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
			elseif not params.has (l_as.access_name_8) then
				create {UN_EXPR} last_expr.make_un (l_as.access_name_8, create {VAR_EXPR}.make_var ("Current"))
			else
				create var.make_var (l_as.access_name_8)
				last_expr := var
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

	process_binary_as (l_as: BINARY_AS)
		local
			bin: BIN_EXPR
			e1: EXPR
			e2: EXPR
		do
			last_expr := Void
			l_as.left.process (Current)
			e1 := last_expr
--			print (last_expr.op+"%N")

			last_expr := Void
			l_as.right.process (Current)
			e2 := last_expr
--			print (last_expr.op+"%N")
			create bin.make_bin (l_as.op_name.name_8, e1, e2)

			last_expr := bin
		end

end
