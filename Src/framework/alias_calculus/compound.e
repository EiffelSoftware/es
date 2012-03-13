note
	description: "Summary description for {COMPOUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMPOUND
inherit
	CONTROL
		rename
			copy as old_copy, is_equal as old_is_equal
		select
			out
		end

	LINKED_LIST [INSTRUCTION]
		rename
			out as old_out
		select
			copy, is_equal
		end

create
	make


feature -- Status report

	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here no.
		do
			Result := False
		end

feature -- Access


feature -- Input and output

	out: STRING
			-- Printable representation of compound instruction,
			-- indented at `level', followed by return to next line.
			-- Here no indentation (taken care of by the instructions
			-- making up the compound).
		do
			across Current as  c from
				create Result.make_empty
			loop
				Result := Result + c.item.out
			end
		end

feature -- Implementation


feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by `i'.
		local
			i: INTEGER
		do
			from
				start
			until
				after
			loop
				i := index
				item.update (a)
				if index /= i then
					go_i_th (i)
				end
				forth
			end
		end
end
