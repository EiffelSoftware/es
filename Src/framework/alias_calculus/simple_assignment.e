note
	description: "Assignment of a variable to another variable."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_ASSIGNMENT

inherit
	ASSIGNMENT

create
	make

feature -- Initialization

	make (x: VARIABLE; e: EXPRESSION)
			-- Build as representing x := e.
		require
				target_exists: x /= Void
				source_exists: e /= Void
		do
			target := x
			source := e
		end

feature -- Status report



feature -- Access

	target: VARIABLE
			-- Target of assignment.

	source: EXPRESSION
			-- Source of assignment.

feature -- Basic operations
	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by assignment.
		local
			source_aliases, target_aliases: LIST [EXPRESSION]
		do
			debug ("ASSIGNMENT") print ("<<<<<START alias processing for assignment " + target.name + " := " + source.name + "%N") end
			source_aliases := source.full_aliases (a, target)

			debug ("ASSIGNMENT") print_list (source_aliases, "Original aliases of source " + source_aliases.count.out + " aliases for " + source.name + " excluding " + target.name) end

			debug ("ASSIGNMENT") a.printout_raw ("Original") end
					-- First: 			r':= r \- {target}
			a.remove_item (target)
					-- Next: 			r' := r' U {target} x (r' (source)))
			debug ("ASSIGNMENT") a.printout_raw ("After removing target") end
			target_aliases := target.full_aliases (a, Void)
			debug ("ASSIGNMENT") print_list (target_aliases, "Original aliases of target " + target_aliases.count.out + " aliases for " + target.name) end

			across source_aliases as sa  loop
				debug ("ASSIGNMENT") print ("Adding in loop " + sa.item.name + ", " + target.name + "%N") end
				a.put (sa.item, target)
				debug ("ASSIGNMENT") a.printout_raw ("After addition") end
			end
					-- Finally: 			r' := r' U [x, y])
			if source.initial /~ target then
				debug ("ASSIGNMENT") print ("Adding pair from original assignment: [" + target.name + ", " + source.name + "]%N") end
				a.put (source, target)
			end
			debug ("ASSIGNMENT") print ("<<<<<END alias processing for assignment " + target.name + " := " + source.name + "%N") end
		end

feature -- Input and output

	out: STRING
			-- Printable representation of assignment.
		do
			Result := tabs + target.name + " := " + source.name + New_line
		end

	print_list (s: LIST [EXPRESSION]; tag: STRING)
			-- Print elements of `s'.
			-- Useful for debugging purposes
		require
			list_exists: s /= Void
			tag_exists: tag /= Void
		local
			backup: INTEGER
		do
			backup := s.index
			io.put_string (tag + ": ")
			from s.start until s.after loop
				io.put_string (s.item.name)
				s.forth
				if not s.after then
					io.put_string (", ")
				end
			end
			io.put_new_line
			s.go_i_th (backup)
		end

invariant
	target_exists: target /= Void
	source_exists: source /= Void
end
