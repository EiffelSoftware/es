
note
	description: "Summary description for {DOMAINIFIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
  SSA_DOMAINIFIER

inherit
  SSA_SHARED

  SSA_GET_SUPPLIERS

create
  make

feature
  make (a_class: CLASS_C)
    do
      cls := a_class
      set_class (a_class)
    end

  cls: CLASS_C

  write_gen_dom_file
    local
      c2dmn: SSA_CLASS_TO_DEMONL
      extras: ARRAYED_LIST [TUPLE [STRING, STRING]]
      instr_fix: SSA_EXTRA_INSTR
    do
      create instr_fix
      create extras.make (10)
      across fetch_suppliers (cls) as cc loop
--        set_class (cc.item)
        create c2dmn.make (cc.item)
        print (cc.item.name + "%N")
        class_descs.put (c2dmn.class_desc, cc.item.name)
        extras.append (c2dmn.extra_attrs)
      end

      instr_fix.write_extra (extras)
    end

  write_domain_files
    local
      c2dmn: SSA_CLASS_TO_DEMONL
      dmn: SSA_DEMONL_DOMAIN
      file: PLAIN_TEXT_FILE
    do
      create file.make (cls.name + ".dmn")
      file.create_read_write

      across fetch_suppliers (class_c) as cc loop
        set_class (cc.item)
        create c2dmn.make (class_c)
        create dmn.make

        file.put_string (dmn.domain_string (c2dmn.class_desc))
      end

      file.close
    end
end
