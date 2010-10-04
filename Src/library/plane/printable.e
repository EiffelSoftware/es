note
	description: "Summary description for {PRINTABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PRINTABLE

feature
	to_printer (p : PRINTER)
		deferred
		end

	print_string : STRING
		local
			p : PRINTER
		do
			create p.make
			to_printer (p)
			Result := p.context
		end


	print_list_ln_indent (p : PRINTER; l: LIST [PRINTABLE])
		do
			p.indent
			p.newline

			print_list_ln (p, l)

			p.unindent
			p.newline
		end

	print_list_ln (p : PRINTER; l: LIST [PRINTABLE])
		do
			from l.start
			until l.after
			loop
				l.item.to_printer (p)
				l.forth

				if not l.after then
					p.newline
				end
			end
		end

end
