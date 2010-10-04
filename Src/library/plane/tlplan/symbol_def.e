note
	description: "Summary description for {SYMBOL_DEF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SYMBOL_DEF

inherit
	ANY
		redefine
			is_equal
		end

create
	make_func,
	make_pred

feature
	make_func (s: STRING; n : INTEGER)
		do
			type := "function"
			make_other (s,n)
		end

	make_pred (s: STRING; n : INTEGER)
		do
			type := "predicate"
			make_other (s,n)
		end

	to_printer (p : PRINTER)
		do
			p.add ("(")
			p.add (type)
			p.space
			p.add (name)
			p.space
			p.add (num_args.out)
			p.add (")")
		end

	name : STRING
	num_args : INTEGER

	is_equal (other: SYMBOL_DEF): BOOLEAN
		do
			Result := other.name.is_equal (name) and
			          other.num_args = num_args
		end

feature {NONE}

	make_other (s: STRING; n : INTEGER)
		do
			name := s
			num_args := n
		end

	type : STRING

end
