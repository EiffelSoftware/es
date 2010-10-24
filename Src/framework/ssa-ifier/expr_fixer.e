note
	description: "Summary description for {EXPR_FIXER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPR_FIXER

inherit
	AST_ITERATOR
		redefine
			process_id_as,
			process_nested_as,
			process_binary_as,
			process_access_feat_as,
			process_bool_as,
			process_unary_as,
			process_integer_as
		end

feature
	make
		do
			reset
		end

	reset
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
			if attached {SSA_NESTED} last_expr as nested then
				Result := nested.name
			elseif attached {SSA_EXPR_VAR} last_expr as var then
				Result := var.name
			end
		end

	last_expr_args: LIST [SSA_EXPR]
		do
			if attached {SSA_NESTED} last_expr as nested then
				Result := nested.args
			else
				Result := empty_args
			end
		end

	empty_args: LIST [SSA_EXPR]
		do
			create {ARRAYED_LIST[SSA_EXPR]} Result.make (10)
		end

	construct_nested (a_target: SSA_EXPR; a_name: STRING; a_args: LIST [SSA_EXPR]): SSA_EXPR
		do
			create {SSA_NESTED} Result.make (a_target, a_name, a_args)
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

	process_nested_as (l_as: NESTED_AS)
		do
			safe_process (l_as.target)

			if has_last_expr then
				constructor := agent construct_nested (last_expr, ? , ?)
			end

			safe_process (l_as.message)

		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if attached constructor then
				constructor.call ([l_as.access_name_8, params_list (l_as.parameters)])
				last_expr := constructor.last_result
			else
				last_expr := create {SSA_NESTED}.make (Void, l_as.access_name_8, params_list (l_as.parameters))
			end
		end

	params_list (l_params: EIFFEL_LIST [EXPR_AS]): LIST [SSA_EXPR]
		local
			expr_as: EXPR_AS
			saved_expr: SSA_EXPR
			saved_constr: FUNCTION [ANY, TUPLE[STRING, LIST[SSA_EXPR]], SSA_EXPR]
		do
			create {ARRAYED_LIST [SSA_EXPR]} Result.make (10)
			saved_expr := last_expr
			saved_constr := constructor

			from
				l_params.start
				reset
			until
				l_params.after
			loop
				expr_as := l_params.item
				safe_process (expr_as)
				Result.extend (last_expr)

				reset
				l_params.forth
			end

			constructor := saved_constr
			last_expr := saved_expr
		end

	process_bool_as (l_as: BOOL_AS)
		do
			create {SSA_EXPR_BOOLEAN} last_expr.make (l_as.is_true_keyword)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			safe_process (l_as.expr)
			create {SSA_EXPR_UNARY} last_expr.make (l_as.operator_name_32, last_expr)
		end

	process_binary_as (l_as: BINARY_AS)
		local
			e1,e2: SSA_EXPR
		do
			safe_process (l_as.left)
			e1 := last_expr
			reset

			safe_process (l_as.right)
			e2 := last_expr

			create {SSA_EXPR_BIN} last_expr.make (l_as.op_name.name_32, e1, e2)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			create {SSA_EXPR_INTEGER} last_expr.make (l_as.integer_32_value)
		end

end
