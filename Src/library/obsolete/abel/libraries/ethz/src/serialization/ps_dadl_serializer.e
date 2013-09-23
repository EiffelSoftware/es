note
	description: "[
		Objects that are used to serialize other objects, using the DADL (Data Archetype Definition Language) textual format.
		Dadl is the ADL (Archetype Definition Language) serialization component. See http://www.openehr.org/projects/eiffel.html.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_DADL_SERIALIZER

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
			precursor (a_file)
			medium := a_file
			create {PS_DADL_FORMAT} format
			create retrieved_items.make (Default_dimension)
			create last_retrieval_information.make_empty
		end

feature -- Basic operations

	store (an_object: ANY)
			--	Serialize an_object using the format and medium set for current object.
		do
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.
		do
		end

	retrieve
			-- Retrieve an_object using the medium and format set for current object.
		do
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		do
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
