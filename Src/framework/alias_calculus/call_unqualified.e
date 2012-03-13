note
	description: "Representation of a Call instruction."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"
	caching: "[
			Recursion is handled through caching. Specifically, the result
			of any application of the current call to an alias relation `a'
			is recorded in the array `cached_output'; for a new integer
			value `cc' (the latest value of the global counter
			`cached_count'), the  result of this application will be in 
			`cached_output [cc]'. The input relation itself, `a',
			is recorded in a hash table `cached_input'; the key is `a'
			and the associated value is the corresponding `cc'.
			]"
class
	CALL_UNQUALIFIED

inherit
	CALL
		rename make as call_make end

create
	make


feature -- Initialization

	make (pn: STRING; pr: PROGRAM)
				-- Initialize with `pn' as name of procedure in `pr'.
				-- Serves as creation procedure in UNQUALIFIED_CALL,
				-- needs to be complemented in QUALIFIED_CALL.
		do
			call_make (pn, pr)
			create cached_input.make (Default_cached_call_aliases)
			create cached_output.make (1, Default_cached_call_aliases)
		ensure then
			cached_input_exists: cached_input /= Void
			cached_output_exists: cached_output /= Void
			cached_output_sized: cached_output.count = Default_cached_call_aliases
		end


feature -- Access


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
			cc: INTEGER
					-- Used to preserve the value of `cached_count'
					-- between recursive calls.
		do
			debug ("CALL")
				io.put_string ("Procedure " + proc_name);
				io.put_string (",  caching level "); io.put_integer (cached_count); io.put_new_line
			end
			if cached_input.has (a) then
				debug ("CALL")
					io.put_string ("Found among cached alias relations%N"); io.put_string (proc_name);
				end
				is_stable := True
				a.deep_copy (cached_output [cached_input [a]])
			else
				debug ("CALL") io.put_string ("Need to create new alias relation for procedure "); io.put_string (proc_name + "%N") end
				cached_count := cached_count + 1
				cc := cached_count
				cached_input  [a.deep_twin] := cc
				cached_output.force (create {ALIAS_RELATION}.make, cc)
				a.update (proc.body)
				cached_output.force (a.deep_twin, cc)
				debug ("CALL") io.put_string ("New alias relation created%N"); io.put_string (proc_name); end
			end
		end

--	update_backup (a: ALIAS_RELATION)
--			-- If [`first', `second'] is an alias pair, remove it.
--			-- THIS IS A PREVIOUS VERSION OF `update',  RETAINED TEMPORARILY FOR COMPARISON, WILL GO AWAY
--			--
--		do
--			if cached_input /= Void and then a.is_deep_equal (cached_input) then
--				is_stable := True
--				a.deep_copy (cached_output)
--			else
--				cached_input := a.deep_twin
--				create cached_output.make
----				cached_output := a.deep_twin  -- WRONG, temporarily kept for historical edification!
--				a.update (proc.body)
--				cached_output := a.deep_twin
--			end
--		end

feature -- Input and output

	out: STRING
			-- Printable representation of call.
		do
			Result := tabs + "call "+ proc_name + "%N"
		end


invariant
	proc_name_exists: proc_name /= Void and then not proc_name.is_empty
	program_exists: program /= Void
end
