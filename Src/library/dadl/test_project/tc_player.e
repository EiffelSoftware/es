indexing
	description: "Summary description for {TC_PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_PLAYER


feature -- serialize

	serialize_dadl(a_path:STRING;a_obj:ANY) is
			--
		do
			create persistence_manager.make(a_path)
			persistence_manager.serialize_type_information(true)
			persistence_manager.store (a_obj)
		end

	serialize_custom_dadl (a_path: STRING;a_obj: ANY;a_form: SERIALIZED_FORM) is
			--
		do
			create persistence_manager.make(a_path)
			persistence_manager.format.set_serialized_form (a_form)
			persistence_manager.serialize_type_information(true)
			persistence_manager.store (a_obj)
		end

	serialize_without_type_information(a_path:STRING;a_obj:ANY) is
			--
		do
			create persistence_manager.make(a_path)
			persistence_manager.serialize_type_information(false)
			persistence_manager.store (a_obj)
		end

feature -- deserialize

	deserialize_dadl(a_path:STRING):ANY is
			--
		do
			create persistence_manager.make(a_path)
			result := persistence_manager.retrieve
		end





feature -- access

	converter:DT_OBJECT_CONVERTER

	d_engine:DADL_ENGINE

	persistence_manager:DADL_PERSISTENCE_MANAGER

	persistence_format:DADL_FORMAT


end
