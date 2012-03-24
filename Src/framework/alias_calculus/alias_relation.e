note
	description: "Alias relation (commutative, irreflexive) between expressions."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"
	related: "[
			The associated classes ALIASES_SORTED and ALIASES_CANONICAL provide
			specific representations of an alias relation. They are not, however,
			defined as heirs (no need).
			]"
	MODIFICATION_RULE: "[
			Any routine that can change the contents of the relation must,
			prior to carrying out any such changes, call `invalidate_sorted_representation'.
			]"

	MODIFICATION_RULE: "[
			This class (for better or worse) has its own `copy'.
			Whenever adding an attribute, make sure to update `copy' accordingly.
			]"

class
	ALIAS_RELATION

inherit
	HASH_TABLE [HASH_TABLE [EXPRESSION, EXPRESSION], EXPRESSION]
		rename
			put as ht_put, remove as ht_remove, make as ht_make, has as ht_has
		redefine
			copy, is_equal, empty_duplicate
		select
			copy, is_equal
		end

	HASHABLE
		rename copy as old_copy, is_equal as old_is_equal end

	SIZING
		rename copy as old_copy1, is_equal as old_is_equal1 end

create
	make

create {ALIAS_RELATION}
	make_sized

feature -- Initialization

	make
			-- Initialize with room for `Min_expressions' expressions.
		do
			make_sized (Min_expressions)
		end

	make_sized (n: INTEGER)
			-- Initialize with room for `n' expressions.
		require
			non_negative: n >= 0
		do
			ht_make (n)
			create suffixes.make (Min_expressions)
			invalidate_sorted_representation	-- Not necessary thanks to automatic initialization,
												-- included for clarity
		end



feature -- Access

	suffixes: HASH_TABLE [HASH_TABLE [INTEGER, EXPRESSION], SIMPLE_EXPRESSION]
			-- For every simple expression `e', the set of multidot expressions
			-- starting with it, e.g. ` e.f.g' starts with ` e'.
			-- Conservative: if ` e.f.g...' appears in the alias table,
			-- then it must be in the suffixes list for ` e'; however
			-- not the other way around (we don't always bother to
			-- remove unneeded entries.
			-- The INTEGER values in the sub-hash-tables are irrelevant,
			-- we use these tables as plain sets of EXPRESSION.


	aliases (e: EXPRESSION): SORTED_TWO_WAY_LIST [EXPRESSION]
			-- List (possibly empty) of expressions directly aliased
			-- to `e' in current alias relation.
			-- `Direct' because in looking up the aliases of `a.b'
			-- we don't consider the aliases of `a' and the aliases
			-- of `b', just the aliases recorded for `a.b'.
		local
--			eht: HASH_TABLE [EXPRESSION, EXPRESSION]
		do
			create {SORTED_TWO_WAY_LIST [EXPRESSION]} Result.make
--			eht := item (e)
			if ht_has (e) then
				debug ("REMOVE") print ("Found " + e.name + " in table%N") end
				check attached item(e) as eht then
					across eht as ehtc loop Result.extend (ehtc.key) end
				end
--				Result.sort		-- We do not need to sort here, see `printout'. BM ,Dec 2009
			else
				debug
					("REMOVE") print ("DID NOT FIND " + e.name + " in table%N")
					printout_raw ("Trying to understand why not found")
				end
			end
		ensure
			list_exists: Result /= Void
			irreflexive: not Result.has (e)
		end

	sorted_representation: ALIASES_SORTED
			-- List of aliased expressions, each with its list of aliases.
		local
			c: ALIASES_SORTED
		do
			if has_sorted_representation then
				check attached computed_sorted_representation as r then
					Result := r
				end
			else
				create c.make (Current)
				computed_sorted_representation := c
				validate_sorted_representation
				Result := c
			end
		ensure
			exists: Result /= Void
		end

feature -- Measurement

	dot_count: INTEGER assign set_dot_count
			-- Lower bound for the number of dots
			-- (length minus one, e.g. 2 for `a.b.c')
			-- of expressions recorded in this relation.
			-- This is conservative: every expression must have
			-- at least `dot_count' dots, but the actual lower
			-- bound may be higher.
			-- Updated only by `prepended'.

	hash_code: INTEGER
			-- Hashing value (currently just the number of aliases).
		do
			Result := count
				-- Make sure `count' reflect the actual number of aliased variables.
			check consistent_count: sorted_representation.count = count end
		end

feature -- Comparison

	is_equal (other: ALIAS_RELATION): BOOLEAN
			-- Equality: should be defined as deep equality?
		local
			rep, rep_other: ALIASES_SORTED
		do
				-- The following version causes a postcondition violation in is_deep_equal!
--			Result := is_deep_equal (other)

				-- The following version seems to do what we want, albeit expensively:
			if has_sorted_representation then
				rep := sorted_representation
			else
				create rep.make (Current)
			end
			if other.has_sorted_representation then
				rep_other := other.sorted_representation
			else
				create rep_other.make (other)
			end
			Result := rep.is_equal (rep_other)
		end

	difference (other: ALIAS_RELATION): STRING
			-- What kind of difference is there with `other'?
			-- (Only useful if not equal)
		do
			create Result.make_empty
			if not keys.is_deep_equal (other.keys) then	Result := Result + " Unequal keys " end
			if not 	content.is_deep_equal (other.content) then 	Result := Result + " Unequal content " end
			if not deleted_marks.is_deep_equal (other.deleted_marks) then	Result := Result + " Unequal deletion marks " end
			if  not	(has_default = other.has_default) then	Result := Result + " Unequal defaults " end
		end

feature -- Status report

	has (e, f: EXPRESSION): BOOLEAN
			-- Is pair [`e', `f'] in relation?
		do
			Result := attached item (e) as eht and then eht.has (f)
		ensure
			symmetric: Result = has (f, e)
		end

feature -- Status setting

	invalidate_sorted_representation
			-- Record that sorted representation is no longer up to date.
		do
			has_sorted_representation := False
		end

	validate_sorted_representation
			-- Record that sorted representation is now up to date.
		do
			has_sorted_representation := True
		end


feature -- Element change

	put (e, f: EXPRESSION)
			-- If `e' and `f' are different, insert pairs [`e', `f']
			-- and [`f',`e']; do nothing if equal.
		do
			debug ("PUT_IN_ALIAS_RELATION")
				io.put_string ("-- Argument 1: "); io.put_string (e.name)
				io.put_string (". Argument 2: "); io.put_string (f.name)
				io.put_new_line
			end
			invalidate_sorted_representation
			if e /~ f and then (e.dot_count <= Max_dots and f.dot_count <= Max_dots) then
				put_one_pair (e, f)
				put_one_pair (f, e)
				record_as_suffix (e)
				record_as_suffix (f)
			end
		ensure
			present_if_distinct: (e /~ f and e.dot_count <= Max_dots and f.dot_count <= Max_dots) implies has (e.simplified, f.simplified)
		end

	add (other: ALIAS_RElATION)
			-- Add all aliases from `other'.
		require
			exists: other /= Void
			different: other /= Current
		local
			e: EXPRESSION
		do
			invalidate_sorted_representation
		across other as o loop
			e := o.key
			across o.item as oht loop put (e, oht.item) end
		end
	end

	put_one_pair (e, f: EXPRESSION)
			-- Add `f' to aliases of `e'.
		require
			first_exists: e /= Void
			second_exists: f /= Void
			different: e /~ f
		local
			eht: detachable HASH_TABLE [EXPRESSION, EXPRESSION]
			e1, f1: EXPRESSION
				-- The ones we actually insert: simplified to variables
				-- if possible.
		do
			invalidate_sorted_representation
			e1 := e.simplified
			f1 := f.simplified
			eht := item (e1)
			if not attached eht then
				create eht.make (Average_aliases)
				ht_put (eht, e1)
			end
			check eht = item (e1) end
			eht.force (f1, f1)
		end

	remove_one_pair (e, f: EXPRESSION)
			-- Remove pairs [`e', `f'] and [`f,`e'].
			-- Do nothing if they were not present.
		do
			debug ("REMOVE") print (" Removing [" + e.name + " , " + f.name + "]") end
			invalidate_sorted_representation
			if attached item (e) as eht then
				debug ("REMOVE") print (", found.%N") end
				check ht_has (f) end
				check attached item (f) as fht then
					eht.remove (f)
					if eht.is_empty then
							-- There are no more items associated with `e'.
						ht_remove (e)
					end
					fht.remove (e)
					if fht.is_empty then
							-- There are no more items associated with `f'.
						ht_remove (f)
					end
				end
			else
				debug ("REMOVE") print (", NOT found.%N") end
			end
		ensure
			absent: not has (e, f)
		end

	remove_item (e: EXPRESSION)
			-- Remove `e' entirely from relation,
			-- i.e. remove all pairs including `e',
			-- plus any suffixes of `e'
			-- (i.e. anything of the form `e.f.g...').
		do
			debug ("REMOVE") print ("Removing item " + e.name + "%N") end
			invalidate_sorted_representation
			across aliases (e) as assoc loop
				remove_one_pair (e, assoc.item)
			end
			remove_suffixes (e)
		end

	prepended (v: VARIABLE): ALIAS_RELATION
			-- Relation deduced from current one by replacing
			-- every pair `[a, b]' by `[v.a, v.b]'.
		require
			exists: v /= Void
		local
			m1: MULTIDOT
		do
			invalidate_sorted_representation
			create Result.make
			across Current as c loop
				m1 := c.key.prepended (v)
				across c.item as eht loop
					Result.put (m1, eht.key.prepended (v))
				end
			end
			if attached {VARIABLE} v as vvv and then not vvv.polarity then
				Result.dot_count := dot_count + 1
			end
		end

	set_dot_count (dc: INTEGER)
			-- Set dot count to `dc'.
		require
			non_negative: dc >= 0
		do
			dot_count := dc
		end

feature -- Duplication

	copy (other: like Current)
			-- Re-initialize from `other'.
		do
			invalidate_sorted_representation
			Precursor {HASH_TABLE} (other)
			suffixes := other.suffixes.twin
			dot_count := other.dot_count
			if other.has_sorted_representation then
				computed_sorted_representation := other.sorted_representation.twin
			end
--			deep_copy (other)	-- This does not work (deep_copy calls copy!
		end

feature -- Input and output

	printout_raw (tag: STRING)
			-- Produce text representation of relation, including message `tag'.
		require
			exists: tag /= Void
		local
			a: ALIAS_RELATION
--			eht: HASH_TABLE [EXPRESSION, EXPRESSION]
			e1, e2: EXPRESSION
		do
			a := deep_twin
			print ("---- Alias relation, raw: " + tag + "---- %N")
				-- Pre-"across" code retained temporarily as comment because it has not been tested BM 29 Jan 2010
--			from a.start until a.off loop
--				e1 := a.key_for_iteration
--				print (e1.name + ": ")
--				eht := a.item_for_iteration
--				from eht.start until eht.off loop
--					e2 := eht.key_for_iteration
--					print (e2.name + " ")
--					eht.forth
--				end
--				io.put_new_line
--				a.forth
--			end
			across deep_twin as dt loop
				e1 := dt.key
				print (e1.name + ": ")
				across dt.item as eht loop
					e2 := eht.key
					print (e2.name + " ")
				end
				io.put_new_line
			end
			print ("---- End alias relation ---------- %N")
		end



	printout (tag: STRING)
			-- Print a list of aliases computed, preceded by `tag' if not empty.
		local
			new: ALIAS_RELATION
			aso: ALIASES_SORTED
			aco: ALIASES_CANONICAL
		do
			new := deep_twin
			aso := new.sorted_representation
			aso.remove_symmetry
			create aco.make (new)
			aco.printout (tag)
		end


feature -- Basic operations

	update (i: INSTRUCTION)
			-- Take into account aliases induced by `i'.
		require
			instruction_exists: i /= Void
			applicable: i.is_applicable (Current)
		do
			invalidate_sorted_representation
			i.update (Current)
		end

feature {ALIAS_RELATION} -- Status report

	has_sorted_representation: BOOLEAN
			-- Is sorted representation available and up to date?
			-- RULE: call `invalidate_sorted_representation' whenever modifying the relation.

feature {NONE} -- Implementation

	record_as_suffix (e: EXPRESSION)
			-- If necessary, record ` e' among the suffixes of its
			-- starting simple expression, e.g. `a' if `e' is `a.b.c'.
		require
			exists: e /= Void
		local
			suf: detachable HASH_TABLE [INTEGER, EXPRESSION]
			v: SIMPLE_EXPRESSION
		do
			if attached {MULTIDOT} e as em and then em.dot_count > 1 then
				v := em.initial
				suf := suffixes.item (v)
				if not attached suf then
					create suf.make (Average_aliases)
					suffixes.put (suf, v)
				end
				check suf = suffixes.item (v) end
				suf.force (0, e)
			end
		end

	remove_suffixes (e: EXPRESSION)
			-- If `e' is a variable or other simple expression `v',
			-- remove any multidot starting with `v'.
		require
			exists: e /= Void
		do
			if attached {SIMPLE_EXPRESSION} e as v and then suffixes.has (v) then
				check attached suffixes.item (v) as s then
					across s as suf loop
						check attached {MULTIDOT} suf.key end
						remove_item (suf.key)
					end
				end
				suffixes.remove (v)
			end
		end

	computed_sorted_representation: detachable ALIASES_SORTED
			-- Sorted representation, computed and stored for reuse
			-- if needed again when the relation has not changed.

	empty_duplicate (n: INTEGER_32): ALIAS_RELATION
			-- Create an empty copy of Current that can accommodate `n' items
			-- (from HASH_TABLE)
			-- (export status {NONE})
		do
			create Result.make_sized (n)
		end

	print_list (l: LIST [EXPRESSION]; tag: STRING)
			-- Print elements of `l', preceded by `tag'.
			-- Intended for debugging purposes.
			-- Caution: not tested after replacement of "from" by "across" loops.
		require
			list_exists: l /= Void
			tag_exists: tag /= Void
		do
			print (tag + ": ")
			across l as ll loop
				print (ll.item.name + " ")
			end
			io.put_new_line
		end

invariant
	consistent_computed_representation: has_sorted_representation implies (computed_sorted_representation /= Void)
	suffixes_exist: suffixes /= Void

end
