note
	description: "Summary description for {DECL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPR

inherit
	PRINTABLE

create
	make

feature
	make (s : STRING; es: LIST[EXPR])
		do
			op := s
			exprs := es
		end

	op: STRING
	exprs: LIST [EXPR]

	to_printer (p : PRINTER)
		do
			p.add ("(")
			p.add (op)

			if not exprs.is_empty then
				p.indent
				p.newline

				from exprs.start
				until exprs.after
				loop
					exprs.item.to_printer (p)
					exprs.forth
					if not exprs.after then
						p.newline
					end
				end
				p.newline
				p.unindent
			end
			
			p.add (")")
		end

end
