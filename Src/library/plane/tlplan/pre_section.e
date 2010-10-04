note
	description: "Summary description for {PRE_SECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRE_SECTION

inherit
	PRINTABLE

create
	make

feature
	make
		do
			create generators.make (10)
			create pre_exprs.make (10)
		end

	generators: ARRAYED_LIST [PRE]
	pre_exprs: ARRAYED_LIST [EXPR]


feature
	to_printer (p : PRINTER)
		do
			p.add ("(pre")
			p.indent
			p.newline

			from generators.start
			until generators.after
			loop
				generators.item.to_printer (p)
				generators.forth
				p.newline
			end

			from pre_exprs.start
			until pre_exprs.after
			loop
				pre_exprs.item.to_printer (p)
				pre_exprs.forth

				if not pre_exprs.after then
					p.newline
				end
			end

			p.unindent
			p.newline
			p.add (")")
		end
end
