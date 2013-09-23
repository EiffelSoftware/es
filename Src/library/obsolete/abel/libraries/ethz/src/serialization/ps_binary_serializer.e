note
	description: "[
		Objects used to serialize other objects in binary format.
	]"
	author: ""
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
			precursor (a_file)
			medium := a_file
			create {PS_BINARY_FORMAT} format
			create retrieved_items.make (Default_dimension)
			create last_retrieval_information.make_empty
			create multi_object_serializer
			create stored_objects_locations.make (Default_dimension)
			stored_objects_locations.extend (0)
			stored_objects_locations.forth
		end

feature -- Access

feature -- Basic Operations

	store (an_object: ANY)
			--	Serialize an_object using the format and medium set for current object.
		local
			store_handler: SED_STORABLE_FACILITIES
			serializer: SED_MEDIUM_READER_WRITER
		do
			create store_handler
			if attached {RAW_FILE} medium as file then
				create serializer.make (file)
				if file.exists then
					file.reopen_write (file.name)
				else
					file.open_write
				end
				serializer.set_for_writing
				store_handler.store (an_object, serializer)
				objects_stored_count := 1
				file.close
				last_store_successful := True
			else
				fixme ("Replace with log message")
				print ("%NThe current medium type is not consistent with this serializer. Serialization failed. ")
				last_store_successful := False
			end
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.		
		local
			is_appending_mode: BOOLEAN
		do
			is_appending_mode := True
			if attached {STRING} medium.name as name then
				multi_object_serializer.serialize (an_object, name, is_appending_mode)
				stored_objects_locations.extend (multi_object_serializer.last_file_position)
				stored_objects_locations.forth
				objects_stored_count := objects_stored_count + 1
				last_store_successful := True
			else
				fixme ("Replace with log message")
				print ("%NMedium name is Void!")
			end
		ensure then
			object_count_correct: objects_stored_count = stored_objects_locations.count - 1
		end

	retrieve
			-- Retrieve an_object using the medium and format set for current object.
		local
			store_handler: SED_STORABLE_FACILITIES
			serializer: SED_MEDIUM_READER_WRITER
		do
			create store_handler
			if attached {RAW_FILE} medium as file then
				create serializer.make (file)
				if file.exists then
					file.open_read
					serializer.set_for_reading
					retrieved_items.extend (store_handler.retrieved (serializer, True))
					retrieved_items.forth
					file.close
					last_retrieval_information.append ("%NRetrieval successful. ")
				else
					retrieved_items.extend (Void)
					fixme ("Replace print with log message")
					print ("%NData file does not exist. ")
					last_retrieval_information.append ("%NData file does not exist. ")
				end
			else
				retrieved_items.extend (Void)
				fixme ("Replace with log message")
				print ("%NThe current medium type is not consistent with this serializer. Serialization failed. ")
				last_retrieval_information.append ("%NThe current medium type is not consistent with this serializer. Serialization failed. ")
				retrieved_items.forth
			end
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		local
			temp_file: RAW_FILE
		do
			if attached {STRING} medium.name as name then
				create temp_file.make (name)
				if temp_file.exists then
					from
						stored_objects_locations.start
					until
						stored_objects_locations.islast
					loop
						multi_object_serializer.deserialize (name, stored_objects_locations.item)
						retrieved_items.extend (multi_object_serializer.deserialized_object)
						retrieved_items.forth
						stored_objects_locations.forth
					end
					last_retrieval_information.append ("%NRetrieval successful. ")
				else
					retrieved_items.extend (Void)
					retrieved_items.forth
					fixme ("Replace print with log message")
					print ("%NA file with the name: " + name + " has not been found. ")
					last_retrieval_information.append ("%NA file with the name: " + name + " has not been found. ")
				end
			else
				fixme ("Replace with log message")
				print ("%NMedium name is Void!")
			end
		end

feature {NONE} -- Implementation

	stored_objects_locations: ARRAYED_LIST [INTEGER]
			-- List of file locations where objects are stored.

	multi_object_serializer: SED_MULTI_OBJECT_SERIALIZATION
	-- Embedded multi-object serializer

invariant
	format_is_independent_binary_format: format.generating_type.name.is_equal ("PS_BINARY_FORMAT")

end
