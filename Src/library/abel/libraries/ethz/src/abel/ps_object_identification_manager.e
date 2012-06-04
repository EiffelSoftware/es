note
	description:
		"[
		This class generates unique object identifiers, attaches them to objects, and maintains a weak reference to every identified object.
		It also observes the state of weak references providing a sort of publish-subscribe mechanism if it finds a deleted object.
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_IDENTIFICATION_MANAGER
inherit
	PS_EIFFELSTORE_EXPORT

create make

feature

	-- TODO: Speedup things, e.g. by separating objects by class name...
	-- It might be possible to hash objects on the {ANY}.tagged_out string, but only on the hex number in the first brackets, and only if the number is stable.
	-- This seems to be the memory location.

feature {PS_EIFFELSTORE_EXPORT} -- Identification

	is_identified ( an_object:ANY ): BOOLEAN
			-- Is `an_object' already identified and thus known to the system?
		do
			Result:= across identifier_table as cursor some (cursor.item.first.exists and then cursor.item.first.item = an_object) end
		end


	identify (an_object:ANY)
			-- Generate an identifier for `an_object' and store it
		local
			temp: WEAK_REFERENCE[ANY]
			pair: PS_PAIR [WEAK_REFERENCE [ANY], INTEGER]
		do
			create temp.put (an_object)
			create pair.make (temp, new_id)
			identifier_table.extend (pair)
		ensure
			identified: is_identified (an_object)
		end


	get_identifier_wrapper (an_object:ANY) : PS_OBJECT_IDENTIFIER_WRAPPER
			-- Get the REPO_IDENTIFIER of `an_object'
		require
			identified: is_identified (an_object)
		local
			found:BOOLEAN
			meta: PS_TYPE_METADATA
		do
			meta:= metadata_manager.create_metadata_from_object (an_object)
			from
				identifier_table.start
				found:=false
				create Result.make (0, Current, meta) -- Void safety
			until
				identifier_table.after or found
			loop
				if identifier_table.item.first.exists and then identifier_table.item.first.item = an_object then
					create Result.make (identifier_table.item.second.item, an_object, meta)
				end
				identifier_table.forth
			end
		ensure
			item_present: Result.item = an_object
		end


feature {PS_EIFFELSTORE_EXPORT} -- Deletion management

	cleanup
		-- remove all entries where the weak reference is Void, i.e. the garbage collector has collected the object
		do
			from identifier_table.start
			until identifier_table.after
			loop
				if not identifier_table.item.first.exists then
					publish_deletion (identifier_table.item.second)
					identifier_table.remove
				else
					identifier_table.forth
				end
			end
		end


	publish_deletion (identifier:INTEGER)
		-- Publish the deletion of the object with identifier `identifier'
		do
			across subscribers as cursor loop cursor.item.call ([identifier]) end
		end

	register_for_deletion_event (action:PROCEDURE[ANY, TUPLE[INTEGER]])
		-- Register `action' and call it every time an object gets deleted
		do
			subscribers.extend (action)
		end


	subscribers: LINKED_LIST[PROCEDURE[ANY, TUPLE[INTEGER]]]
		-- A list of all subscribers interested in deletion events



feature { NONE } -- Implementation

	identifier_table: LINKED_LIST[ PS_PAIR [WEAK_REFERENCE [ANY], INTEGER] ]
			-- The internal storage for identifiers

	make
			-- Initialize `Current'
		do
			create identifier_table.make
			create subscribers.make
			create metadata_manager.make_new
			last_id:=0
		end

	new_id:INTEGER
		-- create a new identifier
		do
			last_id:=last_id+1
			Result:= last_id
		end

	last_id:INTEGER
		-- the last id generated

	metadata_manager: PS_METADATA_MANAGER
		-- A manager to generate metadata

end
