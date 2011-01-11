note
	description: "Used to print a feature body in SSA form."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
  SSA_FEATURE_PRINTER

inherit
  AST_ITERATOR
    redefine
      process_nested_as,
      process_access_feat_as,
      process_assign_as,
      process_id_as,
      process_binary_as,
      process_unary_as,
      process_bool_as,
      process_integer_as
		end

  INTERNAL_COMPILER_STRING_EXPORTER

	SSA_SHARED

	SHARED_SERVER

create
	make

feature
  make
    do
      context := ""
      in_body := True
    end

feature -- AST
	process_assign_as (l_as: ASSIGN_AS)
    local
      str: STRING
		do
      str := fix_print (l_as.source)
      put_raw_string ("%N")
      put_raw_string (l_as.target.access_name)
      put_raw_string (" := ")
      put_raw_string (str)
    end

	in_body: BOOLEAN


	process_id_as (l_as: ID_AS)
		do
			fix_print_basic (l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			fix_print_basic (l_as)
		end

	process_binary_as (l_as: BINARY_AS)
		do
			fix_print_basic (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			fix_print_basic (l_as)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			fix_print_basic (l_as)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			fix_print_basic (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			fix_print_basic (l_as)
		end

	fix_print_basic (l_as: AST_EIFFEL)
		do
			if attached fix_print (l_as) then
			end
		end

	fix_print (l_as: AST_EIFFEL): STRING
		local
			fix: EXPR_FIXER
			expr: SSA_EXPR
			repls: LIST [SSA_REPLACEMENT]
		do
			if in_body then
				create fix.make
				l_as.process (fix)
				expr := fix.last_expr
				repls := expr.replacements

				from repls.start
				until repls.after
				loop
					Result := repls.item.var
					put_raw_string ("%N" + "-- planning step")
          print_plan_call (repls.item)
					put_raw_string ("%N" + Result  + " := " + repls.item.repl_text)
					repls.forth
				end
			else
        -- print nothing, we only operate in the body
			end
		end

  print_plan_call (a_repl: SSA_REPLACEMENT)
    do
      put_raw_string ("%N" + "rely_call (%"[%N")

      put_raw_string (req_to_lisp (a_repl))

      put_raw_string ("%N%"])")
    end


  req_to_lisp (a_repl: SSA_REPLACEMENT): STRING
    local
      pres: LIST [TAGGED_AS]
      pre_trans: PRE_TO_ADL
      lexpr: EXPR
      args: LIST [STRING]
      i: INTEGER
    do
      Result := "(and"

      if not attached a_repl.args then
        args := create {ARRAYED_LIST [STRING]}.make (10)
      else
        args := a_repl.args
      end
      
      if attached a_repl.feat as feat and then
        attached feat.body.body.as_routine as rout
       then
        pres := rout.precondition.assertions

        from i := 1
        until i > pres.count
        loop
          create pre_trans.make_for_instr (class_c.name,
                                           a_repl.target,
                                           inst_args (args, feat.arguments))

          pres [i].process (pre_trans)
          Result := Result + pre_trans.last_expr.print_string

          i := i + 1
        end
      else
        Result := Result + "(TRUE)"
      end
      
      Result := Result + ")"
    end

  inst_args (a_args: LIST [STRING];
             a_form_args: FEAT_ARG): HASH_TABLE [STRING, STRING]
    require
      same_count: a_args.count = a_form_args.count
    local
      i: INTEGER
    do
      create Result.make (10)

      from i := 1
      until i > a_args.count
      loop
        Result.put (a_args [i], a_form_args.item_name (i))
        i := i + 1
      end
    end

feature
  context: STRING

  put_raw_string (a_str: STRING)
    do
      context := context + a_str
    end
end
