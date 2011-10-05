class
  SSA_DEMONL_DOMAIN

inherit
  SSA_SHARED

create
  make

feature
  make
    do
    end

  domain_string (desc: SSA_CLASS_DESC): STRING
    require
      attached desc
    do
      Result := ""
      across convert_class (desc) as si
      loop Result := Result + "%N%N" + si.item end
    end

  convert_class (desc: SSA_CLASS_DESC): ARRAYED_LIST [STRING]
    do
      create Result.make (10)


      Result.extend (convert_attrs (desc))

      across desc.functions as fc
      loop Result.extend (convert_func (desc, fc.item)) end

      across desc.procedures as pc
      loop Result.extend (convert_proc (desc, pc.item)) end
    end

feature -- Convert class components
  convert_attrs (desc: SSA_CLASS_DESC): STRING
    require
      non_void_desc: attached desc
    do
      Result := "type " + desc.type.name + "%N{"

      across desc.attributes as ic
      loop Result := Result + convert_attr (desc, ic.item) + "%N" end

      Result := Result + "}%N"
    end

  convert_attr (desc: SSA_CLASS_DESC; decl: SSA_DECL): STRING
    require
      non_void_arguments: attached decl
    do
      Result := dmn_type (desc.type) + "_" + decl.name + ": " +
        dmn_type (decl.type)
    ensure
      attached Result
    end

  convert_decl (decl: SSA_DECL): STRING
    require
      non_void_arguments: attached decl
    do
      Result := decl.name + ": " + dmn_type (decl.type)
    ensure
      attached Result
    end

  convert_func (desc: SSA_CLASS_DESC; func: SSA_FEATURE_DESC): STRING
    do
      Result := arg_list (desc, func)
      Result := Result + ": " + dmn_type (func.type) + "%N"

      if not func.preconds.is_empty then
        Result := Result + "require%N"
        Result := Result + prefix_assert_list ("pre", func.preconds)
      end

      if not func.postconds.is_empty then
        Result := Result + "ensure%N"
        Result := Result + prefix_assert_list ("post", func.postconds)
      end
    ensure
      attached Result
    end

  convert_proc (desc: SSA_CLASS_DESC; proc: SSA_FEATURE_DESC): STRING
    do
      set_feature (class_c.feature_named_32 (proc.name))
      Result := arg_list (desc, proc) + "%N"
      if not proc.preconds.is_empty then
        Result := Result + "require%N"
        Result := Result + prefix_assert_list ("pre", proc.preconds)
      end

      if not proc.postconds.is_empty then
        Result := Result + "ensure%N"
        Result := Result + prefix_assert_list ("post", proc.postconds)
      end
    ensure
      attached Result
    end

  arg_list (desc: SSA_CLASS_DESC; proc: SSA_FEATURE_DESC): STRING
    do
      Result := dmn_type (desc.type) + "_" + proc.name +
        "(" + arg_prefix + "Current:" + dmn_type (desc.type)

      across proc.arguments as ai loop
        Result := Result + ", " + arg_prefix + convert_decl (ai.item)
      end
      Result := Result + ")"
    end

  prefix_assert_list (pre: STRING; assert_list: LIST [SSA_EXPR]): STRING
    local
      i: INTEGER
    do
      Result := ""

      from i := 1
      until i > assert_list.count
      loop
        Result := Result + pre + "_" + i.out + ": "
        Result := Result + assert_list [i].goal_string (arg_prefix) + "%N"
        i := i + 1
      end
    end

  arg_prefix: STRING = "arg__"

  dmn_type (type: TYPE_A): STRING
    do
      if type.is_integer then
        Result := "Int"
      elseif  type.is_boolean then
        Result := "Bool"
      elseif type.is_real_32 then
        Result := "Float"
      elseif type.is_real_64 then
        Result := "Double"
      else
        Result := type.name
      end
    end

end
