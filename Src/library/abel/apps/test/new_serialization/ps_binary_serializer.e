note
	description: "[
		Objects used to serialize other objects in binary format.
	]"
	author: "Marco Piccioni, Adrian Schmidmeister"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BINARY_SERIALIZER

inherit

	PS_SERIALIZER
	redefine
			make
	end

create
	make

feature -- Initialization

	make (a_file: RAW_FILE)
			-- Set the serializer for binary serialization on file.
		do
			default_dimension := 30
			precursor (a_file)
			medium := a_file
			create {PS_BINARY_FORMAT} format.make
			create retrieved_items.make (default_dimension)
			create last_retrieval_information.make_empty
			create stored_objects_locations.make (default_dimension)
			stored_objects_locations.extend (0)
			stored_objects_locations.forth
		end

feature -- Access

	default_dimension: INTEGER

feature -- Basic Operations

	store (an_object: ANY)
			--	Serialize an_object using the format and medium set for current object.
		do
			encode_object (an_object)
			objects_stored_count := 1
			last_store_successful := true
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.		
		local
		do
		end

	retrieve
			-- Retrieve an_object using the medium and format set for current object.
		local
		do
			decode_object
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		local
		do
		end

feature {NONE} -- Implementation

	stored_objects_locations: ARRAYED_LIST [INTEGER]
	-- List of file locations where objects are stored.

invariant
	format_is_independent_binary_format: format.generating_type.name.is_equal ("PS_BINARY_FORMAT")

end
