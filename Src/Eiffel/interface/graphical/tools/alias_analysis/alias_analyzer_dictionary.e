note
	description: "Dictionary of entities used during alias analysis."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_DICTIONARY

create
	make

feature {NONE} -- Creation

	make
			-- Prepare storage to keep items.
		do
			create indexes.make (0)
			create values.make (0)
			create qualification.make (0)
				-- Add special entities.
			add (-1, -1)
			void_index := last_added
			add (-2, -1)
			non_void_index := last_added
			add (-3, -1)
			current_index := last_added
		end

feature -- Access

	last_added: INTEGER_32
			-- Index of the last added item.

	is_new: BOOLEAN
			-- Is last added element new?

	is_overqualified: BOOLEAN
			-- Does last added element have too many qualifiers?

	suffix (p, c: like last_added): like last_added
			-- Suffix s of a chain `c' == `p'.s
		require
			has_index (p)
			has_index (c)
			has_prefix (p, c)
		local
			i: like last_added
		do
			from
				i := c
				Result := current_index
			until
				i = p or not attached values [i] as v
			loop
				i := v.qualifier
				Result := v.tail.abs
			end
		end

	prefixed (p: like last_added): ITERABLE [like last_added]
			-- Enumeration of indexes of items that start with a prefix of index `p'.
		require
			has_index (p)
		local
			r: SEARCH_TABLE [like last_added]
		do
			create r.make (0)
			across
				values as v
			loop
				if has_prefix (p, v.target_index) then
					r.force (v.target_index)
				end
			end
			Result := r
		end

	next_prefix (p, c: like last_added): like last_added
			-- A shortest prefix `p'.s of `c' if any, such that `p'.s.q == `c',
			-- or a non-existing index if there is no such prefix.
		require
			has_index (p)
			has_index (c)
		local
			i: like last_added
		do
			from
				i := c
			until
				i = p
			loop
				if is_unqualified (i) then
						-- No match found.
					i := p
					Result := 0
				else
						-- Follow the chain.
					Result := i
					check from_precondition_and_qualification: attached values [i] as v then
						i := v.qualifier
					end
				end
			end
		ensure
			valid_prefix_for_p: has_index (Result) implies has_prefix (Result, p)
			valid_prefix_for_c: has_index (Result) implies has_prefix (Result, c)
			invalid_prefix_for_p: not has_prefix (Result, p) implies not has_index (Result)
			invalid_prefix_for_c: not has_prefix (Result, c) implies not has_index (Result)
		end

feature -- Status report

	has_index (v: like last_added): BOOLEAN
			-- Is there a registered item with index `v'?
		do
			if v < 0 then
				Result := has_index (- v)
			elseif v > 0 then
				Result := v <= count
			end
		end

	is_reversed (v: like last_added): BOOLEAN
			-- Is index `v' reversed?
		require
			has_index (v)
		do
			Result := v < 0
		end

	has_prefix (p, c: like last_added): BOOLEAN
			-- Does index `c' correspond to an item starting with a prefix of index `p'?
		require
			has_index (p)
			has_index (c)
		local
			i: like last_added
		do
			if p /= c then
				from
					i := c
				until
					i = p or else i <= 0 or else not attached values [i] as v or else v.qualifier > 0 and then v.tail > 0
				loop
					i := v.qualifier
				end
				Result := i = p
			end
		end

feature {NONE} -- Status report

	is_unqualified (v: like last_added): BOOLEAN
			-- Does `v' denote an unqualified entity?
		require
			has_index (v)
		local
			t: like entry
		do
			t := values [v]
			Result :=
				t.tail >= 0 and then t.qualifier >= 0 or else
				t.tail < 0 and then t.qualifier < 0
		end

feature -- Special indexes

	void_index: like last_added
			-- Index of a special entity "void".

	non_void_index: like last_added
			-- Index of a special entity "non_void".

feature {NONE} -- Special indexes

	current_index: like last_added
			-- Index of "Current".

feature -- Modification

	add_argument (n: INTEGER; f: FEATURE_I; c: CLASS_C)
			-- Add an argument `n' declared in feature `f' in class `c'.
			-- Set `last_added' to the index of the item.
		require
			valid_n: n >= 1
			f_attached: attached f
			c_attached: attached c
		do
			add (n, f.rout_id_set.first)
		ensure
			local_added: indexes.has_key (entry (n, f.rout_id_set.first))
		end

	add_local (n: INTEGER; f: FEATURE_I; c: CLASS_C)
			-- Add a local `n' declared in feature `f' in class `c'.
			-- Set `last_added' to the index of the item.
		require
			valid_n: n >= 1
			f_attached: attached f
			c_attached: attached c
		do
			add (n + f.argument_count, f.rout_id_set.first)
		ensure
			local_added: indexes.has_key (entry (n + f.argument_count, f.rout_id_set.first))
		end

	add_result (f: FEATURE_I; c: CLASS_C)
			-- Add a result of the feature `f' in the class `c'.
			-- Set `last_added' to the index of the item.
		require
			f_attached: attached f
			c_attached: attached c
		do
			add (f.rout_id_set.first, 0)
		ensure
			result_added: indexes.has_key (entry (f.rout_id_set.first, 0))
		end

	add_feature (f: FEATURE_I; t: like last_added; c: CLASS_C)
			-- Add a feature `f' in the class `c'.
			-- Set `last_added' to the index of the item.
		require
			f_attached: attached f
			c_attached: attached c
		do
			add_result (f, c)
		ensure
			attribute_added: indexes.has_key (entry (f.rout_id_set.first, 0))
		end

	add_current
			-- Add current.
			-- Set `last_added' to the index of the item.
		do
				-- No special entry is required.
			last_added := current_index
		end

	add_reverse (v: like last_added)
			-- Add a new item which is the reverse of `v'.
			-- Set `last_added' to the index of the item.
		do
			last_added := - v
		ensure
			last_item_reversed: is_reversed (v) /= is_reversed (last_added)
		end

	add_qualification (q: like last_added; v: like last_added)
			-- Add qualification `q' for the item `v'.
			-- Updates `is_overqualified' to signify that the elements has too many qualifiers.
		require
			v_is_registered: has_index (v)
			v_not_reversed: not is_reversed (v)
		local
			t: like entry
			p: like last_added
			n: like qualification.i_th
		do
			is_overqualified := False
				-- Check if `v' represents a special value.
			if v = non_void_index or else v = void_index then
					-- Arbitrary value, non-void or void value have no qualification.
				last_added := v
			elseif q = current_index then
					-- Current.foo == foo.
				last_added := v
			elseif v = current_index then
					-- foo.Current == foo.
				last_added := q
			elseif q > 0 then
					-- Add real qualification.
				if is_unqualified (v) then
						-- Add immediate qualification.
					add (- v, q)
					if is_new then
						qualification.put_i_th (1, last_added)
					end
				else
					t := values [v]
					if t.qualifier < 0 then
							-- We should be removing the qualifier.
						last_added := t.tail
					else
							-- Add qualification to the current qualifier and use it instead.
						add_qualification (q, t.qualifier)
						p := last_added
						add (t.tail, p)
						if is_new then
							n := qualification.i_th (p) + 1
							qualification.put_i_th (n, last_added)
							if n >= 20 then
								is_overqualified := True
							end
						end
					end
				end
			else
					-- Add the nested qualification by appending the qualifier `q' at end
					-- so that it can be efficiently removed when a real qualification is applied.
				add (v, q)
			end
		end

feature -- Output

	name (index: like last_added): STRING
			-- Name corresponding to `index'.
		local
			t: like entry
			w: SHARED_WORKBENCH
		do
			if index = void_index then
				Result := once "Void"
			elseif index = non_void_index then
				Result := once "NonVoid"
			elseif index = current_index then
				Result := once "Current"
			else
				if index < 0 then
						-- Negative expression.
					Result := "-" + name (- index)
				else
					t := values.i_th (index)
					if t.qualifier = 0 then
							-- 	[n, 0] - feature of routine id "n"
						create w
						if
							attached w.system.rout_info_table.origin (t.tail) as c and then
							attached c.feature_of_rout_id (t.tail) as f
						then
							Result := "{" + c.name + "}." + f.feature_name_32
						end
					elseif t.tail >= 0 and then t.qualifier >= 0 then
							-- 	[m, n] - local variable "m" of a feature of routine id "n"
						create w
						if
							attached w.system.rout_info_table.origin (t.qualifier) as c and then
							attached c.feature_of_rout_id (t.qualifier) as f
						then
							if t.tail <= f.argument_count then
								Result := "{" + c.name + "}." + f.feature_name_32 + "(" + t.tail.out + ")"
							else
								Result := "{" + c.name + "}." + f.feature_name_32 + "." + (t.tail - f.argument_count).out
							end
						end
					elseif t.tail >= 0 and then t.qualifier < 0 then
							-- [m, -n] - expression "m" qualified by a negative expression "-n"
						Result := "-" + name (- t.qualifier) + "." + name (t.tail)
					elseif t.tail < 0 and then t.qualifier >= 0 then
							-- [-m, n] - expression "m" qualified by an expression "n"
						Result := name (t.qualifier) + "." + name (- t.tail)
					end
				end
			end
		end

feature {NONE} -- Entry encoding

	entry (tail: INTEGER_32; qualifier: INTEGER_32): TUPLE [tail: INTEGER_32; qualifier: INTEGER_32]
			-- Entry value corresponding to `tail' and `qualifier'.
		do
			Result := [tail, qualifier]
		ensure
			entry_tail (Result) = tail
			entry_qualifier (Result) = qualifier
		end

	entry_tail (e: like entry): INTEGER_32
			-- Tail part of an entry `e'.
		do
			Result := e.tail
		end

	entry_qualifier (e: like entry): INTEGER_32
			-- Qualifier part of an entry `e'.
		do
			Result := e.qualifier
		end

feature {NONE} -- Modification

	add (tail: INTEGER; qualifier: INTEGER)
			-- Add an entity identified by `tail' and `qualifier'.
			-- Set `last_added' to the index of the item.
			-- Set `is_new' to indicate whether this is a new element or not.
		local
			i: like count
			t: like entry
		do
			t := entry (tail, qualifier)
			i := count + 1
			indexes.put (i, t)
			if indexes.inserted then
					-- A new item is added, increase the number of items.
				count := i
					-- Report index of the added item.
				last_added := i
					-- Report that this is a new item.
				is_new := True
					-- Save item for later use.
				values.force (t)
				qualification.force (0)
			else
					-- The number of items is unchanged.
					-- Retrieve the index of the item.
				last_added := indexes.found_item
					-- Report that this is a old item.
				is_new := False
			end
		ensure
			added_entity: indexes.has_key (entry (tail, qualifier))
			added_values: values [last_added] ~ entry (tail, qualifier)
		end

feature -- Measurement

	count: like last_added
			-- Current number of registered indexes.

feature {NONE} -- Storage

	indexes: HASH_TABLE [like last_added, like entry]
			-- Registered indexes.
			-- See `values'.

	values: ARRAYED_LIST [like entry]
			-- Values of registered indexes.
			-- The following encoding is used ("n", "m" are positive numbers):
			-- 	[m, 0] - feature of routine id "m"
			-- 	[m, n] - argument (m<=argument_count) or local variable (m>argument_count) "m" of a feature of routine id "n"
			-- [m, -n] - expression "m" qualified by a negative expression "-n"
			-- [-m, n] - expression "m" qualified by an expression "n"

	qualification: ARRAYED_LIST [INTEGER]
			-- Total number of qualifiers in the chain of given item.

invariant
	same_count: indexes.count = values.count and indexes.count = qualification.count

note
	copyright: "Copyright (c) 2012-2013, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
