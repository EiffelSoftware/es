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
				-- Add special entities.
			add ([-1, -1])
			void_index := last_added
			add ([-1, -2])
			non_void_index := last_added
			add ([-1, -3])
			current_index := last_added
		end

feature -- Access

	last_added: INTEGER_32
			-- Index of the last added item.

	is_new: BOOLEAN
			-- Is last added element new?

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

feature {NONE} -- Status report

	is_unqualified (v: like last_added): BOOLEAN
			-- Does `v' denote an unqualified entity?
		require
			has_index (v)
		local
			t: TUPLE [tail, qualifier: INTEGER_32]
		do
			t := values [v]
			Result := t.tail >= 0 and then t.qualifier >= 0
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

	add_local (n: INTEGER; f: FEATURE_I; c: CLASS_C)
			-- Add a local `n' declared in feature `f' in class `c'.
			-- Set `last_added' to the index of the item.
		require
			valid_n: n >= 1
			f_attached: attached f
			c_attached: attached c
		do
			add ([n, f.rout_id_set.first])
		ensure
			local_added: indexes.has_key ([n, f.rout_id_set.first])
		end

	add_result (f: FEATURE_I; c: CLASS_C)
			-- Add a result of the feature `f' in the class `c'.
			-- Set `last_added' to the index of the item.
		require
			f_attached: attached f
			c_attached: attached c
		do
			add ([0, f.rout_id_set.first])
		ensure
			result_added: indexes.has_key ([0, f.rout_id_set.first])
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
			attribute_added: indexes.has_key ([0, f.rout_id_set.first])
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
		require
			v_is_registered: has_index (v)
			v_not_reversed: not is_reversed (v)
		local
			t: TUPLE [tail, qualifier: INTEGER_32]
		do
			if q > 0 then
					-- Add real qualification.
				if is_unqualified (v) then
						-- Add immediate qualification.
					add ([- v, q])
				else
					t := values [v]
					if t.qualifier < 0 then
							-- We should be removing the qualifier.
						last_added := t.tail
					else
							-- Add qualification to the current qualifier and use it instead.
						add_qualification (q, t.qualifier)
						add ([- t.tail, last_added])
					end
				end
			else
					-- Add the nested qualification by appending the qualifier `q' at end
					-- so that it can be efficiently removed when a real qualification is applied.
				add ([v, q])
			end
		end

feature -- Output

	name (index: like last_added): STRING
			-- Name corresponding to `index'.
		local
			t: TUPLE [tail: INTEGER; qualifier: INTEGER]
			w: SHARED_WORKBENCH
		do
			if index = void_index then
				Result := once "Void"
			elseif index = non_void_index then
				Result := once "NonVoid"
			elseif index = current_index then
				Result := once "Current"
			else
				t := values.i_th (index)
				if t.tail = 0 then
						-- 	[0, n] - feature of routine id "n"
					create w
					if
						attached w.system.rout_info_table.origin (t.qualifier) as c and then
						attached c.feature_of_rout_id (t.qualifier) as f
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
						Result := "{" + c.name + "}." + f.feature_name_32 + "." + t.tail.out
					end
				elseif t.tail >= 0 and then t.qualifier < 0 then
						-- [m, -n] - expression "m" qualified by a negative expression "-n"
				elseif t.tail < 0 and then t.qualifier >= 0 then
						-- [-m, n] - expression "m" qualified by an expression "n"
				end
			end
		end

feature {NONE} -- Modification

	add (t: TUPLE [INTEGER, INTEGER])
			-- Add an entity identified by `t'.
			-- Set `last_added' to the index of the item.
			-- Set `is_new' to indicate whether this is a new element or not.
		local
			i: like count
		do
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
			else
					-- The number of items is unchanged.
					-- Retrieve the index of the item.
				last_added := indexes.found_item
					-- Report that this is a old item.
				is_new := False
			end
		ensure
			added_entity: indexes.has_key (t)
			added_values: values [last_added] ~ t
		end

feature {NONE} -- Measurement

	count: like last_added
			-- Current number of registered indexes.

feature {NONE} -- Storage

	indexes: HASH_TABLE [like last_added, TUPLE [INTEGER, INTEGER]]
			-- Registered indexes.
			-- See `values'.

	values: ARRAYED_LIST [TUPLE [tail: INTEGER; qualifier: INTEGER]]
			-- Values of registered indexes.
			-- The following encoding is used ("n", "m" are positive numbers):
			-- 	[0, n] - feature of routine id "n"
			-- 	[m, n] - local variable "m" of a feature of routine id "n"
			-- [m, -n] - expression "m" qualified by a negative expression "-n"
			-- [-m, n] - expression "m" qualified by an expression "n"

;note
	copyright: "Copyright (c) 2012, Eiffel Software"
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
