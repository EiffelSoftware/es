note
	description: "Summary description for {ADL_DOMAIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADL_DOMAIN

inherit
	PRINTABLE

create
	make

feature
	make (a_symbs : LIST [SYMBOL_DEF]
	     ;a_acts : LIST [ADL_ACTION]
	     )
		do
			symbols := a_symbs
			acts := a_acts
		end

	symbols : LIST [SYMBOL_DEF]
	acts    : LIST [ADL_ACTION]

	to_printer (p : PRINTER)
		do
			print_desc_symbs (p)
			p.newline
			print_acts (p)
			p.newline
		end

feature {NONE}
	print_desc_symbs (p: PRINTER)
		do
			p.add ("(clear-world-symbols)")
			p.newline
			p.add ("(set-search-strategy best-first)")
			p.newline

			p.add ("(declare-described-symbols")
			p.indent
			p.newline

			from symbols.start
			until symbols.after
			loop
				symbols.item.to_printer (p)
				symbols.forth
				p.newline
			end

			p.add (")")
			p.unindent
			p.newline
		end

	print_acts (p : PRINTER)
		do
			from acts.start
			until acts.after
			loop
				acts.item.to_printer (p)
				acts.forth

				if not acts.after then
					p.newline
				end
			end
		end

end
