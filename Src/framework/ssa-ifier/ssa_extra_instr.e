class
  SSA_EXTRA_INSTR

feature
  write_extra (fixes: LIST [TUPLE [class_name: STRING;
                                   feature_name: STRING]])
    local
      file: PLAIN_TEXT_FILE
    do
      create file.make ("extra_instr.e")
      file.create_read_write
      file.put_string (add_fixes (fixes))
      file.close
    end
  
feature
  add_fixes (fixes: LIST [TUPLE [class_name: STRING;
                                 feature_name: STRING]]): STRING
    do
      Result := prestring
      across fixes as fi loop
        Result := Result + add_fix (fi.item.class_name, fi.item.feature_name)
      end
      Result := Result + poststring
    end

  add_fix (class_name: STRING; feature_name: STRING): STRING
    do
      Result := "%Nif attached {" + class_name + "} a_obj as cast_obj then"
      Result := Result +
        "%N%Tserizer.serialize_attr (" +
        "cast_obj." + feature_name + ", " +
        "a_name + %"." + class_name + "_" + feature_name + "%")"
      Result := Result + "%Nend"
    end

  prestring: STRING =
    "[
class EXTRA_INSTR

feature
     extra_serial (a_obj: ANY; a_name: STRING; serizer: SEXPR_SERIALIZER)
    do
     ]"

  poststring: STRING =
    "[

    end
  end
  ]"

end
