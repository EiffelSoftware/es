note
	description: "Program variables representing pointers, which can be assigned."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"
class
	VARIABLE
inherit
	SIMPLE_EXPRESSION
		redefine is_inverse end

create
	make
feature -- Initialization

	make (s: STRING)
			-- Build with variable name `s' and positive ("false") polarity.
		require
			exists: s /= Void
			non_empty: not s.is_empty
		do
			base_name := s
		end

feature -- Access

	dot_count: INTEGER
			-- Number of dots (here 1).
		do
			Result := 1
		end

	name: STRING
			-- Variable name, accounting for polarity.
		do
			Result := base_name
			if polarity then Result := Result + "%'" end
		end

	prepended (x: VARIABLE): MULTIDOT
			-- `x.v' where `v' is current variable.
		do
			debug ("MULTIDOT")
				print ("(VARIABLE) Prepending variable " + x.name + " to ")
				printout
			end
			Result := as_multidot.prepended ((x))
		end


feature -- Status report

	polarity: BOOLEAN
			-- Positive or negative?


	is_inverse (v: SIMPLE_EXPRESSION): BOOLEAN
			-- Is `v' the same variable with different polarity?
		do
			Result := attached {VARIABLE} v as vvv and then ((vvv.base_name ~ base_name) and (vvv.polarity = not polarity))
		end

feature -- Element change

	invert
			-- Reverse polarity.
		do
			polarity := not polarity
		end

feature -- Duplication

	inverse alias "-": VARIABLE
			-- Variable with same name and reversed polarity
		do
			Result := twin
			Result.invert
		end


feature {VARIABLE} -- Implementation

	base_name: STRING
			-- Variable name, without polarity.

invariant
	name_exists: name /= Void
end
