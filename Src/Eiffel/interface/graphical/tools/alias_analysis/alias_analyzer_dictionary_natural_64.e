note
	description: "Dictionary of entities used during alias analysis."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_DICTIONARY_NATURAL_64

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
			v: like entry
		do
			from
				i := c
				Result := current_index
			until
				i = p or not values.valid_index (i)
			loop
				v := values [i]
				i := entry_qualifier (v)
				Result := entry_tail (v).abs
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
			v: like entry
		do
			from
				i := c
			until
				i = p
			loop
				if is_unqualified (i) then
					i := p
					Result := 0
				else
					Result := i
					check
						from_precondition_and_qualification: values.valid_index (i)
					then
						v := values [i]
						i := entry_qualifier (v)
					end
				end
			end
		ensure
			valid_prefix_for_p: has_index (Result) implies has_prefix (Result, p)
			valid_prefix_for_c: has_index (Result) implies has_prefix (Result, c)
			invalid_prefix_for_p: not has_prefix (Result, p) implies not has_index (Result)
			invalid_prefix_for_c: not has_prefix (Result, c) implies not has_index (Result)
		end

	index_qualifier (index: like last_added): like last_added
			-- Qualifier of the item corresponding to `index' or 0 if none.
		require
			has_index (index)
		local
			t: like entry
		do
			if index = void_index then
					-- Result := False
			elseif index = non_void_index then
					-- Result := False
			elseif index = current_index then
					-- Result := False
			else
				if index < 0 then
						-- Negative expression.
					Result := - index_qualifier (- index)
				else
					t := values.i_th (index)
					if entry_qualifier (t) = 0 then
							-- 	[n, 0] - feature of routine id "n"
						Result := current_index
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) >= 0 then
							-- 	[m, n] - local variable "m" of a feature of routine id "n"
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) < 0 then
							-- [m, -n] - expression "m" qualified by a negative expression "-n"
						Result := - entry_qualifier (t)
					elseif entry_tail (t) < 0 and then entry_qualifier (t) >= 0 then
							-- [-m, n] - expression "m" qualified by an expression "n"
						Result := entry_qualifier (t)
					end
				end
			end
		end

	index_tail (index: like last_added): like last_added
			-- Tail of the item corresponding to `index' or 0 if none.
		require
			has_index (index)
		local
			t: like entry
		do
			if index = void_index then
					-- Result := False
			elseif index = non_void_index then
					-- Result := False
			elseif index = current_index then
					-- Result := False
			else
				if index < 0 then
						-- Negative expression.
--					Result := - qualifier (- index)
				else
					t := values.i_th (index)
					if entry_qualifier (t) = 0 then
							-- 	[n, 0] - feature of routine id "n"
						Result := index
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) >= 0 then
							-- 	[m, n] - local variable "m" of a feature of routine id "n"
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) < 0 then
							-- [m, -n] - expression "m" qualified by a negative expression "-n"
						Result := entry_tail (t)
					elseif entry_tail (t) < 0 and then entry_qualifier (t) >= 0 then
							-- [-m, n] - expression "m" qualified by an expression "n"
						Result := - entry_tail (t)
					end
				end
			end
		end

	routine_id (index: like last_added): INTEGER
			-- Routine ID of a feature with index `index'.
		require
			has_index (index)
			is_feature (index)
		local
			t: like entry
		do
			t := values [index]
				-- 	[n, 0] - feature of routine id "n"
			if entry_qualifier (t) = 0 then
				Result := entry_tail (t)
					-- Avoid returning negative value.
				if Result < 0 then
					Result := 0
				end
			end
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
			v: like entry
		do
			if p /= c then
				from
					i := c
				until
					i = p or else i <= 0 or else not values.valid_index (i)
				loop
					v := values [i]
					if entry_qualifier (v) > 0 and then entry_tail (v) > 0 then
							-- Exit loop.
						i := 0
					else
						i := entry_qualifier (v)
					end
				end
				Result := i = p
			end
		end

	is_attribute_chain (index: like last_added; q: like last_added): BOOLEAN
			-- Does `index' denote a chain that contains only attributes
			-- except possibly the first item that corresponds to an argument
			-- of the feature corresponding to its index `q'?
		require
			has_index (index)
			q /= 0 implies has_index (q)
		local
			t: like entry
			w: SHARED_WORKBENCH
		do
			if index = void_index then
					-- Result := False
			elseif index = non_void_index then
					-- Result := False
			elseif index = current_index then
					-- Result := False
			else
				if index < 0 then
						-- Negative expression.
					Result := is_attribute_chain (- index, q)
				else
					t := values.i_th (index)
					if entry_qualifier (t) = 0 then
							-- 	[n, 0] - feature of routine id "n"
						create w
						if
							attached w.system.rout_info_table.origin (entry_tail (t)) as c and then
							attached c.feature_of_rout_id (entry_tail (t)) as f
						then
							Result := f.is_attribute
						end
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) >= 0 then
							-- 	[m, n] - local variable "m" of a feature of routine id "n"
						if qualification.i_th (index) = 0 then
							create w
							if
								attached w.system.rout_info_table.origin (entry_qualifier (t)) as c and then
								attached c.feature_of_rout_id (entry_qualifier (t)) as f
							then
								if q = 0 then
									Result := True
								elseif entry_qualifier (t) = entry_tail (values.i_th (q)) then
									Result := entry_tail (t) <= f.argument_count
								end
							end
						end
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) < 0 then
							-- [m, -n] - expression "m" qualified by a negative expression "-n"
						Result := is_attribute_chain (- entry_qualifier (t), q) and then is_strong_attribute_chain (entry_tail (t))
					elseif entry_tail (t) < 0 and then entry_qualifier (t) >= 0 then
							-- [-m, n] - expression "m" qualified by an expression "n"
						Result := is_attribute_chain (entry_qualifier (t), q) and then is_strong_attribute_chain (- entry_tail (t))
					end
				end
			end
		end

	is_feature (index: like last_added): BOOLEAN
			-- Does `index' correspond to a feature?
		require
			has_index (index)
		do
			if index = void_index then
					-- Result := False
			elseif index = non_void_index then
					-- Result := False
			elseif index = current_index then
					-- Result := False
			elseif index < 0 then
					-- Result := False
			else
					-- 	[n, 0] - feature of routine id "n"
				Result := entry_qualifier (values [index]) = 0
			end
		end

feature {NONE} -- Status report

	is_strong_attribute_chain (index: like last_added): BOOLEAN
			-- Does `index' denote a chain that contains only attributes?
		require
			has_index (index)
		local
			t: like entry
			w: SHARED_WORKBENCH
		do
			if index = void_index then
					-- Result := False
			elseif index = non_void_index then
					-- Result := False
			elseif index = current_index then
					-- Result := False
			else
				if index < 0 then
						-- Negative expression.
					Result := is_strong_attribute_chain (- index)
				else
					t := values.i_th (index)
					if entry_qualifier (t) = 0 then
							-- 	[n, 0] - feature of routine id "n"
						create w
						if
							attached w.system.rout_info_table.origin (entry_tail (t)) as c and then
							attached c.feature_of_rout_id (entry_tail (t)) as f
						then
							Result := f.is_attribute
						end
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) >= 0 then
							-- 	[m, n] - local variable "m" of a feature of routine id "n"
						-- Result := False
					elseif entry_tail (t) >= 0 and then entry_qualifier (t) < 0 then
							-- [m, -n] - expression "m" qualified by a negative expression "-n"
						Result := is_strong_attribute_chain (- entry_qualifier (t)) and then is_strong_attribute_chain (entry_tail (t))
					elseif entry_tail (t) < 0 and then entry_qualifier (t) >= 0 then
							-- [-m, n] - expression "m" qualified by an expression "n"
						Result := is_strong_attribute_chain (entry_qualifier (t)) and then is_strong_attribute_chain (- entry_tail (t))
					end
				end
			end
		end

	is_unqualified (v: like last_added): BOOLEAN
			-- Does `v' denote an unqualified entity?
		require
			has_index (v)
		local
			t: like entry
		do
			t := values [v]
			Result := entry_qualifier (t) >= 0
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

	add_argument (n: INTEGER_32; f: FEATURE_I; c: CLASS_C)
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

	add_local (n: INTEGER_32; f: FEATURE_I; c: CLASS_C)
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

	add_feature (f: FEATURE_I; c: CLASS_C)
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
			v_is_nested:
--				q > 0 and then not is_unqualified (v) and then entry_qualifier (values [v]) < 0 implies
--				entry_qualifier (values [v]) = - q
		local
			t: like entry
			p: like last_added
			n: like qualification.i_th
		do
			is_overqualified := False
			if v = non_void_index or else v = void_index then
				last_added := v
			elseif q = current_index then
				last_added := v
			elseif v = current_index then
				last_added := q
			elseif q = - v then
				last_added := current_index
			elseif q > 0 then
				if is_unqualified (v) then
					add (- v, q)
					if is_new then
						qualification.put_i_th (1, last_added)
					end
				else
					t := values [v]
					if entry_qualifier (t) < 0 then
							-- We should be removing the qualifier.
						check
							from_precondition: entry_qualifier (t) = - q
						end
						last_added := entry_tail (t)
					else
--						if v > 0 then
--							add (- v, q)
--						else
--							add (v, q)
--						end
						add_qualification (q, entry_qualifier (t))
						p := last_added
						add (entry_tail (t), p)
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
				add (v, q)
			end
		end

feature -- Output

	name (index: like last_added): STRING_8
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
					Result := "-" + name (- index)
				else
					t := values.i_th (index)
					if entry_qualifier (t) = 0 then
						create w
						if attached w.System.rout_info_table.origin (entry_tail (t)) as c and then attached c.feature_of_rout_id (entry_tail (t)) as f then
							Result := "{" + c.name + "}." + f.feature_name_32
						end
					elseif entry_qualifier (t) >= 0 then
						if entry_tail (t) >= 0 then
							create w
							if attached w.System.rout_info_table.origin (entry_qualifier (t)) as c and then attached c.feature_of_rout_id (entry_qualifier (t)) as f then
								Result := "{" + c.name + "}." + f.feature_name_32 + "."
								if entry_tail (t) <= f.argument_count then
									Result := Result + f.arguments.item_name (entry_tail (t))
								else
									Result := Result + local_variable_name (entry_tail (t) - f.argument_count, ({ROUTINE_AS} #? f.body.body.content).locals)
								end
							end
						else
							Result := name (entry_qualifier (t)) + "." + name (- entry_tail (t))
						end
					else
						Result := "-" + name (- entry_qualifier (t)) + "." + name (entry_tail (t))
					end
				end
			end
		end

feature {NONE} -- Entry encoding

	entry (tail: INTEGER_32; qualifier: INTEGER_32): NATURAL_64
			-- Entry value corresponding to `tail' and `qualifier'.
		do
			Result := tail.as_natural_64 |<< 32 + (qualifier.as_natural_64 & 0xFFFFFFFF)
		ensure
			entry_tail (Result) = tail
			entry_qualifier (Result) = qualifier
		end

	entry_tail (e: like entry): INTEGER_32
			-- Tail part of an entry `e'.
		do
			Result := (e |>> 32).as_integer_32
		end

	entry_qualifier (e: like entry): INTEGER_32
			-- Qualifier part of an entry `e'.
		do
			Result := e.as_integer_32
		end

feature {NONE} -- Modification

	add (tail: INTEGER_32; qualifier: INTEGER_32)
			-- Add an entity identified by `t'.
			-- Set last_added to the index of the item.
			-- Set is_new to indicate whether this is a new element or not.
		local
			i: like count
			t: NATURAL_64
		do
			t := entry (tail, qualifier)
			i := count + 1
			indexes.put (i, t)
			if indexes.inserted then
				count := i
				last_added := i
				is_new := True
				values.force (t)
				qualification.force (0)
			else
				last_added := indexes.found_item
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
			-- See values.

	values: ARRAYED_LIST [like entry]
			-- Values of registered indexes.
			-- The following encoding is used ("n", "m" are positive numbers):
			-- [m, 0] - feature of routine id "m"
			-- [m, n] - argument (m<=argument_count) or local variable (m>argument_count) "m" of a feature of routine id "n"
			-- [m, -n] - expression "m" qualified by a negative expression "-n"
			-- [-m, n] - expression "m" qualified by an expression "n"

	qualification: ARRAYED_LIST [INTEGER_32]
			-- Total number of qualifiers in the chain of given item.

feature {NONE} -- helper functions

	local_variable_name (a_var_index: INTEGER_32; a_locals: EIFFEL_LIST [LIST_DEC_AS]): STRING_8
			-- TODO I'm sure there must be a function doing this somewhere already?!
		require
			a_var_index >= 1
			a_locals /= Void
		local
			l_i: INTEGER_32
		do
			l_i := a_var_index
			across
				a_locals as c
			until
				Result /= Void
			loop
				if l_i <= c.item.id_list.count then
					Result := c.item.item_name (l_i)
				else
					l_i := l_i - c.item.id_list.count
				end
			end
			if Result = Void then
				-- not found?!
				Result := "???"
			end
		ensure
			Result /= Void
		end

invariant
	same_count: indexes.count = values.count and indexes.count = qualification.count
	has_current_index: has_index (current_index)
	has_non_void_index: has_index (non_void_index)
	has_void_index: has_index (void_index)
	is_unqualified_current_index: is_unqualified (current_index)
	is_unqualified_non_void_index: is_unqualified (non_void_index)
	is_unqualified_void_index: is_unqualified (void_index)

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
