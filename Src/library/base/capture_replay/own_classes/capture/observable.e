indexing
	description: "Interface of Observable objects. Should later be included in the ANY - Class"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OBSERVABLE

feature -- Access
	object_id: INTEGER is
			-- The unique ID of the Observed Object.
		do
			if internal_id = 0 then
				--object id not set yet. --> request an object ID.
				internal_id := global_object_id
				global_object_id.set_item(global_object_id + 1)
			end
			Result := internal_id
		end

	global_object_id: INTEGER_REF is
			-- The next free ID.
		once
			create Result
			Result.set_item(1)
		end

feature {ENTITY_RESOLVER}
	set_object_id(new_object_id: INTEGER) is
			-- Manually set `object_id'.
			-- Note: this could break the assumption that `object_id' is unique
		do
			internal_id := new_object_id
		end

feature {NONE}
	internal_id: INTEGER


feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
