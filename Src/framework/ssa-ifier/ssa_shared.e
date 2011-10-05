note
  description: "Summary description for {SSA_SHAREd}."
  author: ""
  date: "$Date$"
  revision: "$Revision$"

class
  SSA_SHARED

feature -- Class being processed
  class_c: CLASS_C
    do
      Result := class_c_cell.item
    end

  class_c_cell: CELL [CLASS_C]
    once
      create class_.put (Void)
      Result := class_
    end
  
  set_class (a_c: CLASS_C)
    do
      class_c_cell.put (a_c)
    end

feature -- Feature being processed
  feature_i: FEATURE_I
    do
      Result := feature_i_cell.item
    end

  feature_i_cell: CELL [FEATURE_I]
    once
      create feature_.put (Void)
      Result := feature_
    end
  
  feature_name: STRING
    once
      Result := feature_i.feature_name_32
    end

  set_feature (a_f: FEATURE_I)
    do
      feature_i_cell.put (a_f)
    end

  feat_arguments: HASH_TABLE [SSA_EXPR, STRING]
    local
      i: INTEGER
      str: STRING
    do
      create Result.make (10)
      if attached feature_i.arguments as args then
        
        from i := 1
        until i > feature_i.argument_count          
        loop
          str := args.item_name (i)
          Result.put (create {SSA_EXPR_VAR}.make (str), str)
          i := i + 1
        end
      end
    end
  
feature -- Rely expression
  rely: STRING
    do
      Result := rely_cell.item
    end

  rely_cell: CELL [STRING]
    once
      create rely_.put (Void)
      Result := rely_
    end

  set_rely (e: STRING)
    do
      rely_cell.put (e)
    end

feature -- Abstract class descriptions
  class_descs: HASH_TABLE [SSA_CLASS_DESC, STRING]
    do
      Result := class_descs_cell.item
    end

  class_descs_cell: CELL [HASH_TABLE [SSA_CLASS_DESC, STRING]]
    once
      create class_descs_.put
         (create {HASH_TABLE [SSA_CLASS_DESC, STRING]}.make (10))
      Result := class_descs_
    end

feature -- Ignored classes  
  ignored_class (a_class: CLASS_C): BOOLEAN
    do
      Result := ignored_set.has (a_class.name)
    end

  ignored_set: ARRAYED_SET [STRING]
    once
      create Result.make (10)
      Result.compare_objects
      Result.merge (ignored_classes_a)
    end

  ignored_classes_a: ARRAY [STRING]
  	once
  		Result := <<"ARRAYED_LIST">>
  		Result.compare_objects
  	end

feature
  eif_to_ssa_expr (a_expr: AST_EIFFEL): SSA_EXPR
    local
      fix: SSA_EXPR_FIXER
    do
      create fix.make (feat_arguments)

      a_expr.process (fix)
      Result := fix.last_expr
    end
  
  
feature {NONE}
  class_: CELL [CLASS_C]
  feature_: CELL [FEATURE_I]
  rely_: CELL [STRING]
  class_descs_: CELL [HASH_TABLE [SSA_CLASS_DESC, STRING]]

feature -- Counting  
  temp_count: INTEGER_32_REF
    once
      create Result
      Result.set_item (0)
    end

  get_count: INTEGER
    do
      Result := temp_count.item
      temp_count.set_item (Result + 1)
    end
  
end
