indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OBSERVABLE

feature -- Access
	object_id: INTEGER is
			--
		do
			if internal_id = 0 then
				--object id not set yet. --> request an object ID.
				internal_id := global_object_id
				global_object_id.set_item(global_object_id + 1)
			end
			Result := internal_id
		end


	global_object_id: INTEGER_REF is
		once
			create Result
			Result.set_item(1)
		end

feature {ENTITY_RESOLVER}
	set_object_id(new_object_id: INTEGER) is
		do
			internal_id := new_object_id
		end

feature {NONE}
	internal_id: INTEGER

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
