note
	description: "Deferred filter class. You should inherit from it, call feature `initialize' at creation, and call `add' to add the attributes that you do NOT want to serialize."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

deferred class
	CUSTOM_SERIALIZATION_FILTER

feature{NONE} -- Implementation

	attributes_not_to_be_saved: DS_HASH_TABLE [ANY, STRING]
		-- The key is the attribute name, the value is the attribute value.

feature --Initialization

	initialize
			-- Default initialization.
		do
			create attributes_not_to_be_saved.make_default
		end

feature -- Basic operations

	add (s: STRING; o: ANY)
			-- Add an attribute to the table
		require
			s_not_empty: s /= Void and then not s.is_empty
			object_exists: o /= Void
		do
			if not attributes_not_to_be_saved.has (s) then
				attributes_not_to_be_saved.force_new (o, s)
			end
		end

feature -- Status

	value (s: STRING): ANY
			-- get the value
		require
			s_not_empty: s /= Void and then not s.is_empty
		do
			Result := attributes_not_to_be_saved.item (s)
		end

feature -- Field test

	has (s: STRING): BOOLEAN
			-- Does the table contain attribute `s'?
		do
			if s = Void or s.is_equal ("attributes_not_to_be_saved") then
				Result :=false
			else
				Result:= attributes_not_to_be_saved.has (s)
			end
		end

invariant
	attributes_not_to_be_saved_exist: attributes_not_to_be_saved /= Void
end
