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
      process_instr_call_as,
      process_assign_as,
      process_create_creation_as,
      process_if_as,
      process_elseif_as,
      process_loop_as,
      process_check_as
    end

  INTERNAL_COMPILER_STRING_EXPORTER

  SSA_SHARED

  SHARED_SERVER

create
  make

feature
  make (a_doms: ARRAYED_LIST [CLASS_C];
        a_locals: LIST [TYPE_DEC_AS])
    require
      non_void_rely: rely /= Void
    do
      doms := a_doms
      locals := a_locals
      context := ""
    end

  locals: LIST [TYPE_DEC_AS]
  doms: ARRAYED_LIST [CLASS_C]
  in_loop_inv: BOOLEAN
  
feature -- AST
  process_check_as (l_as: CHECK_AS)
    local
      e: STRING
    do
      if l_as.check_list.count > 0 then
        io.put_string ("Found check:%N")
        e := eif_to_ssa_expr (l_as.check_list [1].expr).goal_string ("")
        put_raw_string (serialize_pre (e, l_as.start_location.line))
        io.new_line
      end
    end

  process_assign_as (l_as: ASSIGN_AS)
    local
      str: STRING
    do
      str := instrument (l_as.source)
      put_raw_string ("%N")
      put_raw_string (l_as.target.access_name)
      put_raw_string (" := ")
      put_raw_string (str)
    end

  process_create_creation_as (l_as: CREATE_CREATION_AS)
    local
      str: STRING
    do
      str := instrument (l_as)
      put_raw_string ("%N")
      put_raw_string ("create ")
      put_raw_string (str)
    end

  process_if_as (l_as: IF_AS)
    local
      var: STRING
    do
      var := instrument (l_as.condition)
      put_raw_string ("%Nif " + var + " then ")
      safe_process (l_as.compound)
      safe_process (l_as.elsif_list)

      if attached l_as.else_part then
        put_raw_string ("%Nelse")
        safe_process (l_as.else_part)
      end

      put_raw_string ("%Nend")
    end

  process_elseif_as (l_as: ELSIF_AS)
    local
      var: STRING
    do
      var := instrument (l_as.expr)
      put_raw_string ("%Nelseif " + var + " then ")
      safe_process (l_as.compound)
    end

  process_loop_as (l_as: LOOP_AS)
    local
      str: STRING
    do
      put_raw_string ("%Nfrom ")
      safe_process (l_as.from_part)

      in_loop_inv := True
      safe_process (l_as.invariant_part)
      in_loop_inv := False

      str := instrument (l_as.stop)
      put_raw_string ("%Nuntil ")
      put_raw_string ("%N" + str)
      put_raw_string ("%Nloop")
      safe_process (l_as.compound)

      str := instrument (l_as.stop)
      put_raw_string ("%Nend")
      safe_process (l_as.variant_part)
    end

  process_instr_call_as (l_as: INSTR_CALL_AS)
    do
      if attached {NESTED_AS} l_as.call as af then
        put_raw_string ("%N" + instrument (af))
      elseif attached {ACCESS_FEAT_AS} l_as.call as af then
        put_raw_string ("%N" + instrument (af))
      else
        print ("SSA_FEATURE_PRINTER: Unhandled " +
               l_as.call.generating_type +
               "%N")
      end
    end

  instrument (a_expr: AST_EIFFEL): STRING
    local
      expr: SSA_EXPR
    do
      expr := eif_to_ssa_expr (a_expr)
      put_serialize_call (expr, a_expr.start_location.line)

      Result := expr.as_code
    end

  put_serialize_call (a_expr: SSA_EXPR; line: INTEGER)
    do
      put_raw_string (serialize_call (a_expr, line))
    end
      
  serialize_call (a_expr: SSA_EXPR; line: INTEGER): STRING
    do
      Result := serialize_pre (a_expr.single_precond (""), line)
    end

  serialize_pre (a_goal_str: STRING; line: INTEGER): STRING
    local
      args: HASH_TABLE [SSA_EXPR, STRING]
      str: STRING
    do
      args := feat_arguments
      str := "rely_call ("
      str := str + line.out + ", "
      str := str + "<" + "<" +
        tuple_string ("%"Current%"", "Current")

      from args.start
      until args.after
      loop
        str := str + ","
        str := str +
          double_tuple_string (args.key_for_iteration)

        args.forth
      end

      from locals.start
      until locals.after
      loop
        str := str + ","
        str := str +
          double_tuple_string (locals.item.item_name (1))

        locals.forth
      end
      
      str := str + ">>"


      str := "%N" + str + ","
      str := str + "%N" + doms_str + ","
      str := str + "%N" + block_string (a_goal_str) + ","
      str := str + "%N" + block_string (rely_string) + ","
      str := str + "%N agent extra_serial"
      str := str + ")"

      Result := str
    end

  doms_str: STRING
    do
      Result := "<"+"<"
      from doms.start
      until doms.after
      loop
        Result := Result + "%"" + doms.item.name + "%""
        doms.forth
        if not doms.after then
          Result := Result + ","
        end
      end
      Result := Result + ">>"
    end

  rely_string: STRING
    do
      Result := rely
    end

  block_string (a_str: STRING): STRING
    do
      Result := "%"[%N" + a_str + "%N]%""
    end

  tuple_string (a_str1: STRING; a_str2: STRING): STRING
    do
      Result := "[" + a_str1 + "," + a_str2 + "]"
    end

  double_tuple_string (a_str: STRING): STRING
    do
      Result := tuple_string ("%"" + a_str + "%"", a_str)
    end

feature
  context: STRING

  put_raw_string (a_str: STRING)
    do
      context := context + a_str
    end
end
