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

			if not pre_exprs.is_empty then
				and_exprs.to_printer (p)
			end
			
			p.unindent
			p.newline
			p.add (")")
		end

feature -- Internal
	and_exprs: EXPR
		do
			create Result.make ("and", pre_exprs)
		end
end
