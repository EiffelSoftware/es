class DEFINED_FUNC

inherit
  PRINTABLE
  
create
  make
  
feature
  make (a_name: STRING; a_args: LIST [STRING]; a_body: LIST [EXPR])
    do
      name := a_name
      args := a_args
      body := a_body
    end
  
  name: STRING
  args: LIST [STRING]
  body: LIST [EXPR]


  to_printer (p: PRINTER)
    do
      p.add ("(def-defined-function ")
      p.indent
      p.newline
      p.add ("(" + name + " ")

      from args.start
      until args.after
      loop
        p.add ("?"+args.item)
        p.add (" ")
        args.forth
      end
      p.add (")")

      if not body.is_empty then
        (create {EXPR}.make ("and", body)).to_printer (p)
      end

      p.unindent
      p.newline
      p.add (")")
    end
end
