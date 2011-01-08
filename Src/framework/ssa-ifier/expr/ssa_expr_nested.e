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
      arg_strs: LIST [STRING]
		do
			create {ARRAYED_LIST [SSA_REPLACEMENT]} Result.make (10)

			arg_strs := arg_strings (Result)
      text := compose_name_and_args (arg_strs)
      
			if attached target then
				repls := target.replacements
				Result.append (repls)
        
				text := repls.last.var + "." + text

				create repl.make (res_type (repls.last.type),
                          ssa_prefix,
                          text,
                          arg_strs,
                          feat (repls.last.type)
                          )
			else
				create epa_expr.make_with_text (class_c, feature_i, as_code, class_c)
				type := epa_expr.type

				create repl.make (type, ssa_prefix, text, arg_strs, feat (Void))
			end

			Result.extend (repl)
		end

	res_type (target_type: TYPE_A): TYPE_A
		do
			Result := target_type.associated_class.feature_named_32 (name).type
		end

	feat (type: TYPE_A): FEATURE_I
		local
			clas: CLASS_C
			body: BODY_AS
		do
			if attached type then
				clas := type.associated_class
			else
				clas := class_c
			end

      Result := clas.feature_named_32 (name)
		end

  compose_name_and_args (a_args: LIST [STRING]): STRING
    do
      Result := name

      if not a_args.empty then
        Result :=  result + " ("
        
        from a_args.start
        until a_args.after
        loop
          Result := Result + a_args.item
          a_args.forth

          if not a_args.after then
            Result := Result + ", "
          end
        end
        Result := Result + ")"
      end
    end
  
	arg_strings (repls: LIST [SSA_REPLACEMENT]): ARRAYED_LIST [STRING]
		local
			arg_repls: LIST [SSA_REPLACEMENT]
      str: STRING
		do
			create Result.make (10)

			if not args.is_empty then
				from
					args.start
				until
					args.after
				loop
					arg_repls := args.item.replacements
					repls.append (arg_repls)

					if not arg_repls.is_empty then
						str := arg_repls.last.var
					else
						str := args.item.as_code
					end

          Result.extend (str)
          
					args.forth
				end
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
