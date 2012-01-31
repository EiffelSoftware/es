note
	description: "Canonical form of an alias relation."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	ALIASES_CANONICAL

inherit
	LINKED_LIST [LINKED_LIST [EXPRESSION]]
		rename
			make as list_make
		select
			copy, is_equal
		end

	SIZING
		rename copy as old_copy, is_equal as old_is_equal end

create
	make

feature {NONE} -- Initialization

	make (a: ALIAS_RELATION)
			-- Produce single-list representation of `a'.
		require
			exists: a /= Void
		local
			rep: ALIASES_SORTED
			sel: SORTABLE_EXPRESSION_LIST
			list: SORTED_TWO_WAY_LIST [EXPRESSION]
			el: LINKED_LIST [EXPRESSION]
		do
			base := a
			list_make
			rep := base.sorted_representation.deep_twin
			rep.remove_symmetry
			across rep as r loop
				sel := r.item
				create el.make ; el.extend (sel.key)
				across sel.list as sl loop
					el.extend (sl.item)
				end
				extend (el)
			end
--			canonize		-- For the moment, prefer to do it separately (BM, 6 Jan 2010)
		end

feature -- Access

	base: ALIAS_RELATION
			-- The underlying alias relation.

feature -- Element change

	canonize
			-- Produce canonical form.
		local
			el, new: LINKED_LIST [EXPRESSION]
			split, bad: INTEGER


		do
			from
				start
			until
				after
			loop
				el := item
				check
					at_least_two: el.count > 1
				end
				from
					el.start; el.forth
					el.forth
				until
					el.after
				loop
					check base.has (el.item, el.first) end
					bad := non_aliased (el.item, el.index, el)
					if bad > 0 then
							-- Split the list into two:
						split := el.index
						new := el.twin
						el.remove	-- Also does a `forth'
						new.go_i_th (bad)
						new.remove
						put_right (new)
					else
						el.forth
					end
				end
			forth
			end
			remove_subsets
		end



feature -- Input and output

	printout (tag: STRING)
			-- Printout readable representation, preceded by `tag' if not empty.
		local
			i: INTEGER
		do
			if not tag.is_empty then io.put_string (tag + ":%N%N") end
			print ("%T")
			across Current as  c from i := 1 loop
				if i > Groups_per_line then
					i := 1
					io.put_string ("%N%T")
				end
				print ("<")
				across c.item as el loop
					print (el.item.name)
					if el.cursor_index < c.item.count then
						print (", ")
					end
				end
				print (">")
				if c.cursor_index < count then
					print (", ")
				end
				i := i + 1
			end
			io.put_new_line
		end

feature {NONE} --Implementation

	non_aliased (v: EXPRESSION; i: INTEGER; el: LINKED_LIST [EXPRESSION]): INTEGER
			-- Assuming `v' appears at index `i' in `el':
			-- if all preceding elements are aliased to `v', then 0;
			-- otherwise, position of first preceding element not aliased to `v'.
		require
			list_exists: el /= Void
			list_big_enough: el.count > 2
			expression_exists: v /= Void
			at_least_three: i > 2
			not_too_big: i <= el.count
			at_position: el.i_th (i) = v
			aliased_to_first: base.has (v, el.first)
		local
			ci: INTEGER
		do
			across el as ell until (Result > 0) or ell.cursor_index = i loop
				ci := ell.cursor_index
				if (ci > 1) and then not base.has (ell.item, v) then
					Result := ci
				end
			end
			debug ("NON_ALIASED")
				print ("Non-aliased " + v.name + ": " + Result.out + "%N")
			end
		ensure
			Result_consistent: (Result = 0) or (Result > 1)
			Result_not_too_big: Result < el.count
		end

-- PREVIOUS VERSION ("from" loops) TEMPORARILY RETAINED FOR COMPARISON
-- BM 28.01.2010
--	non_aliased (v: EXPRESSION; i: INTEGER; el: LINKED_LIST [EXPRESSION]): INTEGER
--			-- Assuming `v' appears at index `i' in `el':
--			-- if all preceding elements are aliased to `v', then 0;
--			-- otherwise, position of first element not aliased to `v'.
--		require
--			list_exists: el /= Void
--			list_big_enough: el.count > 2
--			expression_exists: v /= Void
--			at_least_three: i > 2
--			not_too_big: i <= el.count
--			at_position: el.i_th (i) = v
--			aliased_to_first: base.has (v, el.first)
--		local
--			backup: INTEGER
--		do
--			backup := el.index
--			from
--				el.start; el.forth
--			until
--				(Result > 0) or el.index = i
--			loop
--				if not base.has (el.item, v) then
--					Result := el.index
--				end
--				el.forth
--			end
--			el.go_i_th (backup)
--			debug ("NON_ALIASED")
--				print ("Non-aliased " + v.name + ": " + Result.out + "%N")
--			end
--		ensure
--			Result_consistent: (Result = 0) or (Result > 1)
--			Result_not_too_big: Result < el.count
--		end

	remove_subsets
			-- Remove any item that is a subset of another.
		local
			spurious: BOOLEAN
			backup: INTEGER
			found: LINKED_LIST [EXPRESSION]
		do
			debug ("ALIAS_SUBSET")
				print ("Removing subsets%N")
			end
			from
				start
			until
				after
			loop
				debug ("ALIAS_SUBSET")
					printout ("Intermediate")
				end
				backup := index
				found := item
				from
					start; spurious := False
				until
					spurious or (index = backup)
				loop
					if is_subset (item, found) then
						remove
						backup := backup - 1
								-- index to return to must be updated
								-- since there is one fewer element.
					else
						spurious := is_subset (found, item)
						forth
					end
				end
				go_i_th (backup)
				if spurious then
					debug ("ALIAS_SUBSET")
						print (" Spurious, removing: ")
							-- FIXME Following line not tested after change from "from" loop BM 28.01.2010
						across item as ic loop print (ic.item.name + " ") ; print ("%N") end
					end
					remove			-- Also does a `forth'
				else
					forth
				end
			end
		end

	is_subset (e, f: LINKED_LIST [EXPRESSION]): BOOLEAN
			-- Is `e' contained in `f'?
		require
			first_exists: e /= Void
			second_exists: f /= Void
			different: e /= f
		do
			debug ("ALIAS_SUBSET")
				print ("______%N")
						-- Next two lines not tested after change from "from" to "across" form BM 28.01.2010.
				across e as ee loop print (ee.item.name + " ") end; print ("%N")
				across f as ff loop print (ff.item.name + " ") end; print ("%N")
			end
			if e /= f then
				across e as ee from Result := True until (not Result) loop
					across f as ff from Result := False until Result loop
						Result := (ff.item ~ ee.item)
					end
				end
				debug ("ALIAS_SUBSET")
					if Result then
						print ("Is a subset %N")
					end
				end
			end
		end
end
