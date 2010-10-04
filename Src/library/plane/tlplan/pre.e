note
	description: "Summary description for {PRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRE

create
	make,
	make_simple

feature
	make (s : STRING; e : EXPR)
		do
			var := s
			expr := e
		end

	make_simple (s: STRING; gen: STRING)
		local
			un: UN_EXPR
			x: VAR_EXPR
		do
			create x.make_var (s)
			create un.make_un (gen, x)

			make (s, un)
		end

	var: STRING
	expr: EXPR

	to_printer (p : PRINTER)
		do
			p.add ("(?"+var+") ")
			expr.to_printer (p)
		end

end
