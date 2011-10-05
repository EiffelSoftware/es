note
description: "Top-level annotation of a class' feature."
author: ""
date: "$Date$"
revision: "$Revision$"

class SSAIFIER

inherit
  SSA_SHARED

create
  make

feature
  make (a_class: CLASS_C; a_name: STRING)
    -- Process the feature `a_name' from the class `a_class'.
    require
      non_void_class: attached a_class
    local
      ssa_printer: SSA_PRINTER
      rely_guar: SSA_RELY_GUAR
    do
      -- print ("DMN_TEST: " + a_class.name + "." + a_name + "%N")
      set_class (a_class)

      if attached a_class.feature_named_32 (a_name) as feat then
        set_feature (feat)

        create rely_guar.make
        class_c.ast.process (rely_guar)

        if attached rely_guar.rely_str then
          set_rely (rely_guar.rely_str)
        else
          set_rely ("True")
        end

        set_feature (feat)
        create ssa_printer.make_for_ssa
        ssa_printer.process
        write_default_instrumented (ssa_printer.text)
      else
        io.put_string ("Feature " + a_name + " not found in " + a_class.name)
        io.new_line
        check False end
      end
    end

  write_default_instrumented (str: STRING)
    do
      write_instrumented_file (create {FILE_NAME}.make_from_string (class_c.name + "_instr.e"), str)
    end

  write_instrumented_file (file_name: FILE_NAME; str: STRING)
    local
      file: PLAIN_TEXT_FILE
    do
      create file.make (file_name.string)

      file.create_read_write
      file.put_string (str)
      file.close
    end

end
