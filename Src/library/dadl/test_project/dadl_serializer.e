indexing
	description: "Summary description for {DADL_SERIALIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DADL_SERIALIZER

feature -- serialize

	serialize (a_path:STRING;an_obj:ANY) is
			-- serialize object to a file_path without type information
		do
			create persistence_manager.make(a_path)
			persistence_manager.serialize_type_information(true)
			persistence_manager.store (an_obj)
		end

	serialize_without_type_information (a_path:STRING;an_obj:ANY) is
			-- serialize object to a file_path without type information
		do
			create persistence_manager.make(a_path)
			persistence_manager.serialize_type_information(false)
			persistence_manager.store (an_obj)
		end

feature -- deserialize

	deserialize (a_path:STRING):ANY is
			-- deserialize dt structure given a file_path
		do
			create persistence_manager.make(a_path)
			result := persistence_manager.retrieve
		end

	deserialize_non_typed_dt (a_path:STRING;a_type_id:INTEGER):ANY is
			-- deserialize withouth type information in the DT structure
		do
			create persistence_manager.make(a_path)
			persistence_manager.set_type_id(a_type_id)
			result := persistence_manager.retrieve
		end


feature -- access

	persistence_manager:DADL_PERSISTENCE_MANAGER



end
