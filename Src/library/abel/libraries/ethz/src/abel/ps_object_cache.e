note
	description: "This class caches all retrieved or inserted objects by using weak references. Supports also a link for the repository to identify the object"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_CACHE [REPO_IDENTIFIER]

create make


-- TODO: Speedup things, e.g. by separating different objects...
-- It should be possible to hash objects on the {ANY}.tagged_out string, but ONLY on the hex number in the first brackets. This seems to be the memory location.

feature {PS_EIFFELSTORE_EXPORT} -- Basics

	is_cached ( an_object:ANY ): BOOLEAN
			-- Is `an_object' in the cache?
		do
			Result:= across cache_list as cursor some (cursor.item.first.exists and then cursor.item.first.item = an_object) end
		end


	cache (an_object:ANY; a_repo_link: REPO_IDENTIFIER)
			-- Put `an_object' with `a_repo_link' into the cache
		local
			temp:WEAK_REFERENCE[ANY]
			pair: PS_PAIR [WEAK_REFERENCE [ANY], REPO_IDENTIFIER]
		do
			create temp.put (an_object)
			create pair.make (temp, a_repo_link)
			cache_list.extend (pair)
		end

	update_repo_link (an_object:ANY; a_repo_link:REPO_IDENTIFIER)
			-- Update `a_repo_link' in the cache
		require
			present_in_cache: is_cached(an_object)
		local
			found:BOOLEAN
		do
			from
				cache_list.start
				found:=false
			until
				cache_list.after or found
			loop
				if cache_list.item.first.exists and then cache_list.item.first.item = an_object then
					cache_list.item.set_second (a_repo_link)
				end
				cache_list.forth
			end
		end


	get_identifier (an_object:ANY) : detachable REPO_IDENTIFIER
			-- Get the REPO_IDENTIFIER of `an_object'
		require
			present_in_cache: is_cached (an_object)
		local
			found:BOOLEAN
		do
			from
				cache_list.start
				found:=false
			until
				cache_list.after or found
			loop
				if cache_list.item.first.exists and then cache_list.item.first.item = an_object then
					Result:= cache_list.item.second
					found:=true
				end
				cache_list.forth
			end
		end


feature {PS_EIFFELSTORE_EXPORT} -- management

	cleanup
		-- remove all entries where the weak reference is Void, i.e. the garbage collector has collected the object
		do
			across cache_list as cursor loop
				if not cursor.item.first.exists then
					cache_list.remove
				end
			end
		end

feature { NONE } -- Implementation

	cache_list: LINKED_LIST[ PS_PAIR [WEAK_REFERENCE [ANY], REPO_IDENTIFIER] ]
			-- The internal cache

	make
			-- Initialize `Current'
		do
			create cache_list.make
		end

end
