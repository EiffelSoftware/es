indexing
	description: "Summary description for {DADL_PERSISTENCE_MANAGER}."
	author: "Hansen Lucien"
	date: "$Date$"
	revision: "$Revision$"

class
	DADL_PERSISTENCE_MANAGER

inherit
	PERSISTENCE_MANAGER
	SHARED_DT_SERIALISERS

create
	make


feature -- Initialization

	make (file_name: STRING)
			-- Initialization procedure
		require
			file_name_exists: file_name /= Void
		do
			create {FILE_MEDIUM} medium.make (file_name)
			create {DADL_FORMAT} format
			initialise_serialisers

			init_format
		ensure
			medium_exists: medium /= Void
			format_exists: format /= Void
		end

feature -- Basic operations

	serialize_type_information (is_serializing_type_information: BOOLEAN) is
			-- type information of DT structure is serialized or not
		do
			if {actual_format: DADL_FORMAT} format then
				if not is_serializing_type_information then
					actual_format.not_serialize_type_information
				else
					actual_format.serialize_type_information
				end
			end
		end

	set_type_id (a_type_id: INTEGER) is
			-- sets object type id inside the format
			-- the object id of the object which is being stored retrieved
		do
			if {actual_format: DADL_FORMAT} format then
				actual_format.set_object_id(a_type_id)
			end
		end


feature {NONE} -- Implementation

	init_format is
			-- initiliazes the dADL format
		do
			if {actual_format: DADL_FORMAT} format then
				actual_format.set_object_id(-1)
			end
		end


	initialise_serialisers is
		once
			dt_serialisers.put(create {DADL_SYNTAX_SERIALISER}.make(create {NATIVE_DADL_SERIALISATION_PROFILE}.make("adl")), "adl")
		end

end
