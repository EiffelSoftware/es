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
	make

feature
	make (a_target: SSA_EXPR; a_name: STRING; a_args: LIST [SSA_EXPR])
		do
			target := a_target
			name := a_name
			args := a_args
		end

	target: SSA_EXPR
	name: STRING
	args: LIST [SSA_EXPR]

	replacements: LIST [SSA_REPLACEMENT]
		local
			repls: LIST [SSA_REPLACEMENT]
			repl: SSA_REPLACEMENT
			epa_expr: EPA_AST_EXPRESSION
			text: STRING
			type: TYPE_A
		do
			create {ARRAYED_LIST [SSA_REPLACEMENT]} Result.make (10)
			text := name_and_args (Result)

			if attached target then
				repls := target.replacements
				Result.append (repls)

				text := repls.last.var + "." + text

				create repl.make (res_type (repls.last.type), ssa_prefix, text, req (repls.last.type))
			else
				create epa_expr.make_with_text (class_c, feature_i, as_code, class_c)
				type := epa_expr.type

				create repl.make (type, ssa_prefix, text, req (Void))
			end

			Result.extend (repl)
		end

	res_type (target_type: TYPE_A): TYPE_A
		do
			Result := target_type.associated_class.feature_named_32 (name).type
		end

	req (type: TYPE_A): REQUIRE_AS
		local
			clas: CLASS_C
			body: BODY_AS
		do
			if attached type then
				clas := type.associated_class
			else
				clas := class_c
			end

			body := clas.feature_named_32 (name).body.body

			if attached body.as_routine as rout then
				Result := rout.precondition
			end
		end

	name_and_args (repls: LIST [SSA_REPLACEMENT]): STRING
		local
			arg_repls: LIST [SSA_REPLACEMENT]
		do
			Result := name

			if not args.is_empty then
				Result := Result + " ("

				from
					args.start
				until
					args.after
				loop
					arg_repls := args.item.replacements
					repls.append (arg_repls)

					if not arg_repls.is_empty then
						Result := Result + arg_repls.last.var
					else
						Result := Result + args.item.as_code
					end

					args.forth
					if not args.after then
						Result := Result + ", "
					end
				end
				Result := Result + ")"
			end
		end

	as_code: STRING
		do
			Result := ""
			if attached target then
				Result := Result + target.as_code + "."
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

end
