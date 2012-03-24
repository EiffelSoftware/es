note
	description: "Qualified expressions, e.g. `t.u.v....'."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	MULTIDOT

inherit
	EXPRESSION
		rename
			copy as old_copy
		redefine
			full_aliases, simplified
		select
			is_equal
		end

	LINKED_LIST [SIMPLE_EXPRESSION]
		rename
			make as make_empty, is_equal as list_is_equal, count as dot_count
		select
			copy
		end

	ALIASING_CONSTANTS
		rename
			copy as old_copy1, is_equal as old_is_equal1
		end

	SHARED_OBJECTS
		rename
			copy as old_copy2, is_equal as old_is_equal2
		end

create
	make_from_array, make_from_simple_expression, make_from_two_variables

create {LINKED_LIST}
	make_empty

feature -- Initialization

	make_from_array (a: ARRAY [SIMPLE_EXPRESSION])
			-- Initialize from elements in `a'.
		require
			non_empty: a.count > 0
--		local
--			i: INTEGER
		do
			make_empty
				-- Code for longer "from" loop variant retained temporarily, commented out, for discussion, can be removed BM 29.01.2010
--			from i := a.lower until i > a.upper	loop
--				extend (a [i])
--				i := i + 1
--			end
			across a.lower |..| a.upper	as aa loop
				extend (a [aa.item])
			end
		end

	make_from_simple_expression (v: SIMPLE_EXPRESSION)
			-- Set up as 0-dot (1 element) from `v'.	
		require
			exists: v /= Void
		do
			make_empty
			extend (v)
		end

	make_from_two_variables (v, w: VARIABLE)
		require
			exists: v /= Void
		do
			make_from_simple_expression (v)
			extend (w)
		end

feature -- Access


	name: STRING
			-- Textual form of expression,
			-- of the form "a.b.c..."
		do
			create Result.make_empty
			across Current as c loop
				Result.append (c.item.name)
--				if not c.islast then
						-- FIXME above does not work since there is currently  no `islast' for cursors, see
						-- temporary replacement next BM 28.01.2010
				if c.cursor_index < dot_count then
					Result.append (Period)
				end
			end
		end

	simplified: EXPRESSION
			-- Variable form of this expression if meaningful
			-- (i.e. if the multidot has only one item).
		do
			if dot_count > 1 then
				Result := Current
			else
				Result := initial
			end
		end

	prepended (x: VARIABLE): MULTIDOT
			-- `x.e' where `e' is current expression.
				-- FIXME I am no longer sure why the following was commented out, this needs to be checked BM 28.01.2010
--		require
--			must_not_prepend_current_to_current: not ((attached {CURRENT_EXPRESSION} initial) and (attached {CURRENT_EXPRESSION} x))
		do
			debug ("MULTIDOT")
				print ("(MULTIDOT) Prepending simple expression " + x.name + " to ")
				printout
				io.put_new_line
			end

			if x.is_inverse (initial) then
				debug ("MULTIDOT")
					print ("Simple expression " + x.name + ", is inverse of first element " + initial.name + " of expression " + name + "%N")
				end
				if dot_count = 1 then
					Result := Current_object.as_multidot
				else
					Result := tail
				end
			else
				Result := twin
				Result.start
				Result.put_left (x)
			end
		end

	tail: MULTIDOT
			-- If current expression is of the form `x.e', then `e'.
		require
			at_least_two: dot_count > 1
		do

			Result := twin
			Result.start
			Result.remove
		end

	as_array: ARRAY [SIMPLE_EXPRESSION]
			-- Array form of expression, with successive variables.
		local
			s: SPECIAL [SIMPLE_EXPRESSION]
		do
			create s.make_empty (dot_count)
			across Current as c loop
				s.extend (c.item)
			end
			create Result.make_from_special (s)
		ensure
			same_count: Result.count = dot_count
			start_at_1: Result.lower = 1
			end_at_count: Result.upper = dot_count
			non_empty: Result.count > 0
		end

	initial: SIMPLE_EXPRESSION
			-- The starting variable, e.g. `a' in `a.b.c...'.
		do
			Result := first
		end

	full_aliases (a: ALIAS_RELATION; xcl: detachable VARIABLE): SORTED_TWO_WAY_LIST [EXPRESSION]
			-- List (possibly empty) of expressions starting with a variable
			-- other than `xcl' and aliased to current expression in `a'.
			-- This includes indirect aliases: for `e.f', any `x.y' such that
			-- `e' is aliased to `x' and `f' to `y'.
			-- Ignore `xcl' if void.
		local
			initial_aliases, tail_aliases: SORTED_TWO_WAY_LIST [EXPRESSION]
			e: MULTIDOT
			for_search: EXPRESSION
		do
			for_search := Current; if dot_count = 1 then for_search := initial end
			Result := a.aliases (for_search)
			debug  ("MULTIDOT") print ("%TComputing aliases for " + name) ; if xcl /= Void then print (" excluding " + xcl.name) end; io.put_new_line end
			debug  ("MULTIDOT") print_list (Result, "%TPosition 1" ) end
			if xcl /= Void then
				from Result.start until Result.after loop
					if Result.item.initial ~ xcl then
						Result.remove		-- Performs a ` forth'
					else
						Result.forth
					end
				end
			end
			debug  ("MULTIDOT") print_list (Result, "%TPosition 2" ) end
			if dot_count > 1 then
				initial_aliases := a.aliases (initial)
							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition A" ) end
				if xcl = Void or else initial /~ xcl then
							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition B" ) end
					initial_aliases.extend (initial)
							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition C" ) end
				end
				tail_aliases := tail.full_aliases (a, Void)
				across initial_aliases as ia loop
					e := ia.item.as_multidot
					e.append (tail.as_multidot)
							-- TEMP CHANGE 9 Jan 2010
					if e.name /~ name then Result.extend (e) end
					debug  ("MULTIDOT") print_list (Result, "%TPosition 3" ) end
					across tail_aliases as ta loop
						e := ia.item.as_multidot
						e.append (ta.item.as_multidot)
						Result.extend (e)
						debug  ("MULTIDOT") print_list (Result, "%TPosition 4" ) end
					end
				end
			end
		end

--	BELOW: OLD VERSION ("from" loops) RETAINED TEMPORARILY AS COMMENT, FOR COMPARISON BM 28.01.2010
-- CAN BE SAFELY REMOVED NOW
--	full_aliases (a: ALIAS_RELATION; xcl: VARIABLE): SORTED_TWO_WAY_LIST [EXPRESSION]
--			-- List (possibly empty) of expressions starting with a variable
--			-- other than `xcl' and aliased to current expression in `a'.
--			-- This includes indirect aliases: for `e.f', any `x.y' such that
--			-- `e' is aliased to `x' and `f' to `y'.
--			-- Ignore `xcl' if void.

--		local
--			backup: INTEGER
--			initial_aliases, tail_aliases: SORTED_TWO_WAY_LIST [EXPRESSION]
--			e,f: MULTIDOT
--			for_search: EXPRESSION
--		do
--			for_search := Current; if dot_count = 1 then for_search := initial end
--			Result := a.aliases (for_search)
--			debug  ("MULTIDOT") print ("%TComputing aliases for " + name) ; if xcl /= Void then print (" excluding " + xcl.name) end; io.put_new_line end
--			debug  ("MULTIDOT") print_list (Result, "%TPosition 1" ) end
--			if xcl /= Void then
--				from Result.start until Result.after loop
--					if Result.item.initial ~ xcl then
--						Result.remove		-- Performs a ` forth'
--					else
--						Result.forth
--					end
--				end
--			end
--			debug  ("MULTIDOT") print_list (Result, "%TPosition 2" ) end
--			if dot_count > 1 then
--				backup := index
--				initial_aliases := a.aliases (initial)
--							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition A" ) end
--				if xcl = Void or else initial /~ xcl then
--							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition B" ) end
--					initial_aliases.extend (initial)
--							debug  ("MULTIDOT") print_list (initial_aliases, "%TPosition C" ) end
--				end
--				tail_aliases := tail.full_aliases (a, Void)
--				from initial_aliases.start until initial_aliases.after loop
--					e := initial_aliases.item.as_multidot
--					f := tail.as_multidot
--					e.append (f)
--							-- TEMP CHANGE 9 Jan 2010
--					if e.name /~ name then Result.extend (e) end
--					debug  ("MULTIDOT") print_list (Result, "%TPosition 3" ) end
--					from tail_aliases.start until tail_aliases.after loop
--						e := initial_aliases.item.as_multidot
--						f := tail_aliases.item.as_multidot
--						e.append (f)
--						Result.extend (e)
--						debug  ("MULTIDOT") print_list (Result, "%TPosition 4" ) end
--						tail_aliases.forth
--					end
--					initial_aliases.forth
--				end
--				go_i_th (backup)
--			end
--		end


	as_multidot: MULTIDOT
			-- New copy of current multidot.
		do
			Result := twin
		end

feature -- Element change


feature -- Duplication


feature -- Input and output

	printout
			-- Print representation of multidot.
				-- FIXME Why doesn't this routine use `name'?
				-- This seems to be a carryover from an older version,
				-- should be checked, and code duplication removed. BM 28.01.2010
		do
			across Current as c loop
				io.put_string (c.item.name)
				if c.cursor_index < dot_count then io.put_string (".") end
				forth
			end
			io.put_new_line
		end

	print_list (l: SORTED_TWO_WAY_LIST [EXPRESSION]; tag: STRING)
			-- Print elements of `l', preceded by `tag'.
			-- Useful for debugging.
		require
			list_exists: l /= Void
			tag_exists: tag /= Void
		do
			print (tag + ": ")
			across l as ll loop print (ll.item.name + " ") end
			io.put_new_line
		end
invariant
	non_empty: dot_count > 0
	current_only_by_itself: (attached {CURRENT_EXPRESSION} initial) implies (dot_count = 1)
end


