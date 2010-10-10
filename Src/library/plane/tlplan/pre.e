note
	description: "Summary description for {PRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRE

create
	make,
	make_simple,
	make_integer

feature
	make (s : STRING; e : EXPR)
		do
			var := s
			expr := e
		end

	make_integer (s: STRING)
		local
			args: ARRAYED_LIST [EXPR]
		do
			create args.make (10)

			var := s
			create expr.make ("is-between", args)

			args.extend (create {VAR_EXPR}.make_var (s))
			args.extend (create {UN_EXPR}.make_un ("-", create {CONST_EXPR}.make_const (int_high.out)))
			args.extend (create {CONST_EXPR}.make_const (int_high.out))
		end

	int_low: INTEGER = -1000
	int_high: INTEGER = 1000

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
