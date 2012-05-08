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
			create entities.make (0)
				-- Take into account `void_index' and `non_void_index'.
			count := 2
		end

feature -- Access

	last_added: NATURAL_32
			-- Index of the last added item.

feature -- Special entities

	void_index: like last_added = 1
			-- Index of a special entity "void".

	non_void_index: like last_added = 2
			-- Index of a special entity "non_void".

feature -- Modification

	add_local (n: INTEGER; f: FEATURE_I; c: CLASS_C)
			-- Add a local `n' declared in feature `f' in class `c'.
			-- Set `last_added' to the index of the item.
		require
			valid_n: n >= 1
			f_attached: attached f
			c_attached: attached c
		do
			add ([n, f.rout_id_set.first, c.class_id])
		ensure
			local_added: entities.has_key ([n, f.rout_id_set.first, c.class_id])
		end

	add_result (f: FEATURE_I; c: CLASS_C)
			-- Add a result of the feature `f' in the class `c'.
			-- Set `last_added' to the index of the item.
		require
			f_attached: attached f
			c_attached: attached c
		do
			add ([0, f.rout_id_set.first, c.class_id])
		ensure
			result_added: entities.has_key ([0, f.rout_id_set.first, c.class_id])
		end

feature {NONE} -- Modification

	add (t: TUPLE [INTEGER, INTEGER, INTEGER])
			-- Add an entity identified by `t'.
			-- Set `last_added' to the index of the item.
		local
			i: like count
		do
			i := count + 1
			entities.put (i, t)
			if entities.inserted then
					-- A new item is added, increase the number of items.
				count := i
					-- Report index of the added item.
				last_added := i
			else
					-- The number of items is unchanged.
					-- Retrieve the index of the item.
				last_added := entities.found_item
			end
		ensure
			added: entities.has_key (t)
		end

feature {NONE} -- Measurement

	count: like last_added
			-- Current number of registered entities.

feature {NONE} -- Storage

	entities: HASH_TABLE [like last_added, TUPLE [INTEGER, INTEGER, INTEGER]]
			-- Registered entities.

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
