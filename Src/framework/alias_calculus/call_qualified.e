note
	description: "Calls on an explicit target, e.g. `x.f'."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	CALL_QUALIFIED

inherit
	CALL
		rename make as call_make end

create
	make

feature -- Initialization

	make (t: VARIABLE; pn: STRING; pr: PROGRAM)
				-- Initialize with `pn' as name of  procedure
				-- and `t' as   name of  target in `pr'.
		require else
			variable_exists: t /= Void
					-- FIXME this is not correct (needs an abstract precondition) BM 9 January 2010
		do
			call_make (pn, pr)
			target := t
			create cached_input.make (Default_cached_call_aliases)
			create cached_output.make_empty
		ensure then
			cached_input_exists: cached_input /= Void
			cached_output_exists: cached_output /= Void
			variable_set: target = t
		end

feature -- Access

	target: VARIABLE
		-- Target of call, e.g. `x' in `x.f'.

	cached_input: HASH_TABLE [INTEGER, ALIAS_RELATION]
				-- Last aliases on entry.
				-- See `caching' note entry at top of class.

	cached_output: ARRAY [ALIAS_RELATION]
				-- Last aliases on exit.
				-- See `caching' note entry at top of class.

feature -- Measurement

	cached_count: INTEGER
				-- Number of cached alias relations
				-- (inputs, and corresponding outputs).

feature -- Status report

	is_stable: BOOLEAN
			-- Has computation of this call reached a fixed point?
			-- FIXME: currently useless, may need to be removed BM 4.12.2009

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by call.
		local
			uq: CALL_UNQUALIFIED
			b: ALIAS_RELATION
			cc: INTEGER
					-- Used to preserve the value of `cached_count'
					-- between recursive calls.
		do
			debug ("QUALIFIED") print ("Handling procedure call: " + target.name + "." + proc_name + "%N") end
			if cached_input.has (a) then
				debug ("QUALIFIED")
					io.put_string ("Found among cached alias relations%N")
				end
				is_stable := True
				a.deep_copy (cached_output [cached_input [a]])
			elseif a.dot_count < Max_dots  then
				debug ("QUALIFIED") io.put_string ("Not found, will create new alias relation%N"); end
				cached_count := cached_count + 1
				cc := cached_count
				cached_input  [a.deep_twin] := cc
				cached_output.force (create {ALIAS_RELATION}.make, cc)

				create uq.make (proc_name, program)
				debug ("QUALIFIED") b := a.deep_twin ; b.printout ("BEFORE PREPENDING:%N") end
				b := a.prepended (-target)
				debug ("QUALIFIED") b.printout ("AFTER PREPENDING:%N") end
				b.update (uq)
				debug ("QUALIFIED") b.printout ("AFTER UPDATING:%N") end
				b := b.prepended (target)
				a.copy (b)

				cached_output [cc] := a.deep_twin

			end

		ensure then
--			increased: a.dot_count = old a.dot_count + 1
		end

feature -- Input and output

	out: STRING
			-- Printable representation of call.
		do
			Result := tabs + "call "+ target.name + "." + proc_name + "%N"
		end
end
