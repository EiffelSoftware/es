note
	description: "Sorted representation of an alias relation."
	author: "Bertrand Meyer"
	date: "$Date$"
	details: "[
			The structure is a list of lists, together representing an alias
			relation. Think of it as a sequence of lines such as
				x: t, u, v, w
				t: x, w
				u: x
				w: t, x
			This represents the set of pairs
					{[x, t], [x, u], [x, v], [x, w],
					[t, x], [t, w']
					[u, x],
					[w, t], [w, x]}
			The overall list is sorted by the tags appearing on each line
			(`x' for the first line above, `t' for the second line etc.)
			and each line itself is sorted.	
			
			Since the underlying relation is an alias relation (antisymmetric
			and irreflexive), no tag appears again on its own line, and the
			information is duplicated (if `g' appears in the line tagged `f', 
			then `f' appears on the line tagged `g'. The procedure
			`remove_symmetry' removes duplicate pairs.
			]"
	revision: "$Revision$"

class
	ALIASES_SORTED
inherit
	SORTED_TWO_WAY_LIST [SORTABLE_EXPRESSION_LIST]
		rename
			make as list_make
		redefine
			is_equal
		select
			is_equal, copy
		end

	SIZING
		rename
			copy as old_copy, is_equal as old_is_equal
		end

create
	make

create {ALIASES_SORTED}

	list_make, make_sublist

feature {NONE} -- Initialization

	make (a: ALIAS_RELATION)
			-- Initialize so as to represent `a'.
		require
			exists: a /= Void
		local
			al: SORTED_TWO_WAY_LIST [EXPRESSION]
		do
			list_make
			base := a.deep_twin
			across base as  b loop
				check
					b.item /= Void
				end
				if not b.item.is_empty then
					al := base.aliases (b.key)
					al.sort
					extend (create {SORTABLE_EXPRESSION_LIST}.make (b.key, al))
				end
			end
			sort
		end

feature -- Comparison

	is_equal (other: ALIASES_SORTED): BOOLEAN
			-- Are current structure and `other' considered equal?
		local
		do
			debug ("ALIAS_EQUALITY") printout ("Current") other.printout ("other") end
			if attached {CURSOR} cursor as c1 and then attached {CURSOR} other.cursor as c2 then
				if count = other.count then
					from
						start ; other.start ; Result := True
					until
						(not Result) or after
					loop
						if other.after then
							Result := False
						else
							Result := (item.is_same (other.item))
							forth ; other.forth
						end
					end
					check  Result implies other.after end
					go_to (c1) ; other.go_to (c2)
				end
			else
				check cursors_exist: False	end
			end
		end

feature -- Element change

	remove_symmetry
			-- On any line (which cannot be the first), remove any
			-- pair `y, x' such that `x, y' appears in a previous line.
		local
			seen: HASH_TABLE [INTEGER, EXPRESSION]
			al: SORTED_TWO_WAY_LIST [EXPRESSION]
		do
			create seen.make (Average_aliases)
			from
				start

			until
				after
			loop
				al := item.list
				from
					al.start
				until
					al.after
				loop
					if seen.has (al.item) then
						al.remove	-- Also does a ` forth'
					else
						al.forth
					end
				end
				seen.force (0, item.key) -- The integer (first argument) does not matter
				if al.is_empty then
					remove		-- Also does a `forth'
				else
					forth
				end
			end
		end


feature -- Access

	base: ALIAS_RELATION
			-- The underlying alias relation.

feature -- Input and output

	printout (tag: STRING)
			-- Produce text representation of relation, including message `tag'.

				-- Warning: not tested after change from "from" to "across" loops BM 28.01.2010
		require
			exists: tag /= Void
		local
			sel: SORTABLE_EXPRESSION_LIST
		do
			io.put_string ("-- Alias relation: " + tag + "%N")
			across Current as c loop
					sel := c.item
					io.put_string (sel.key.name)
					io.put_string (": ")
					across sel.list as al loop
						io.put_string (al.item.name)
						if al.cursor_index < sel.list.count then
							io.put_string (" ")
						end
					end
					io.put_new_line
			end
		end

end
