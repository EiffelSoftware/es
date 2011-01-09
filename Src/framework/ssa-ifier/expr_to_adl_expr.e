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
	make_for_domain,
  make_for_instr

feature {NONE}
  make (a_in_dom: BOOLEAN; a_target: STRING; a_params: LIST [STRING])
    require
      a_in_dom implies not attached a_target
		do
      target := a_target
      in_dom := a_in_dom
			params := a_params
			params.compare_objects
		end
  
feature
	make_for_domain (a_params: LIST [STRING])
		do
      make (True, "Current", a_params)
		end

  make_for_instr (a_target: STRING; a_instn: HASH_TABLE [STRING, STRING])
    require
      name_present: attached a_target and then not a_target.is_empty
    do
      make (False, a_target, create {ARRAYED_LIST[STRING]}.make (10))
      instn := a_instn
    end

  instn: HASH_TABLE [STRING, STRING]
  target: STRING
      -- Target of non-prefixed id's
  in_dom: BOOLEAN
      -- Is this run part of processing a domain file? If not, then 
      -- it is instrumentation.
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
      if in_dom then
        if not params.has (str) then
          targ := var_expr (target)
          create {UN_EXPR} Result.make_un (str, targ)
        else
          Result := const_expr (target)
        end
      else
        if not instn.has_key (str) then
          io.print ("Didn't find: " + str + "%N")

          from instn.start
          until instn.after
          loop
            io.print (instn.key_for_iteration + "%N")
            instn.forth
          end
          
          targ := const_expr (target)
          create {UN_EXPR} Result.make_un (str, targ)
        else
          Result := const_expr (instn.found_item)
        end
      end
      
      -- if not params.has (str) then
      --   if in_dom then
      --     targ := var_expr (target)
      --   else
      --     targ := const_expr (target)
      --   end

			-- 	create {UN_EXPR} Result.make_un (str, targ)
			-- else
      --   if in_dom then
      --     Result := var_expr (target)
      --   else
      --     Result := const_expr (target)
      --   end
      -- end
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
