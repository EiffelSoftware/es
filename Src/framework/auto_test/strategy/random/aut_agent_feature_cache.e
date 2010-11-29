note
	description: "Singleton for accessing precalculated features conforming to some agent type."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_AGENT_FEATURE_CACHE

create
	make

feature -- Singleton access

	agent_feature_cache: AUT_AGENT_FEATURE_CACHE
			-- Get the singleton
		once
			create Result.make
		ensure
			result_attached: Result /= Void
		end

feature {AUT_AGENT_FEATURE_CACHE} -- Initialization

	make
			-- Create an instance
		do
			create storage.make (storage_capacity)
		ensure
			storage_attached: storage /= Void
			capacity_set: storage.capacity = storage_capacity
		end

feature {AUT_AGENT_FEATURE_CACHE} -- Basic operations

	find (a_type: TYPE_A)
			-- Find an agent type
		do
			storage.search (a_type)
		end

	found: BOOLEAN
			-- Was last type found?
		do
			Result := storage.found
		end

	found_item: ARRAYED_LIST[AUT_FEATURE_OF_TYPE]
			-- Result of last search
		do
			Result := storage.found_item
		end

	put (a_list: ARRAYED_LIST[AUT_FEATURE_OF_TYPE]; a_type: TYPE_A)
			-- Put a new list into the cache
		do
			storage.put (a_list, a_type)
		end

feature {AUT_AGENT_FEATURE_CACHE} -- Implementation

	storage: HASH_TABLE[ARRAYED_LIST[AUT_FEATURE_OF_TYPE],TYPE_A]
			-- Stores previously searched conforming features for an agent type argument

	storage_capacity: INTEGER = 100
			-- Initial capacity of `storage'

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
