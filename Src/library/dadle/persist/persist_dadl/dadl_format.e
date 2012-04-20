indexing
	description: "Summary description for {DADL_FORMAT}."
	author: "Hansen Lucien"
	date: "$Date$"
	revision: "$Revision$"

class
	DADL_FORMAT

inherit
	PERSISTENCE_FORMAT
		redefine
			store,
			retrieve
		end

feature -- Access

	last_retrieved_object: ANY

	last_retrieved_dt: DT_COMPLEX_OBJECT_NODE


feature -- Basic operations

	store (object: ANY; data_file: FILE_MEDIUM)
			-- stores object using a FILE_MEDIUM
		local
			l_complex_node: DT_COMPLEX_OBJECT_NODE
			l_custom_serialization_list: ARRAYED_LIST[STRING]
		do
			reset
			create store_handler.make

			create converter
			if not serialize_no_types then
				converter.show_type
			end

			if serialized_form /= void and then serialized_form.has_serialized_form (object.generating_type) then
				l_custom_serialization_list := serialized_form.get_serialized_form (object.generating_type)
			end

			l_complex_node := converter.object_to_dt (object,l_custom_serialization_list)

			store_handler.set_tree (l_complex_node)
			store_handler.serialise ("adl")

			if data_file.exists and not data_file.raw_file.is_closed then
				data_file.reopen_write (data_file.file_name)
			else
				data_file.open_write
			end

			data_file.raw_file.put_string(store_handler.serialised)
			data_file.close

		end


	retrieve (data_file: FILE_MEDIUM): ANY
			-- retrieves object using a FILE_MEDIUM
		do
			reset
			create store_handler.make
			if data_file.exists then
				data_file.open_read

				data_file.raw_file.read_stream(data_file.raw_file.count)
				store_handler.set_source (data_file.raw_file.last_string, 1)
				store_handler.parse
				if store_handler.parse_succeeded then
					create converter
					last_retrieved_dt := store_handler.tree

					result := converter.dt_to_object (last_retrieved_dt,last_set_type_id)
					last_retrieved_object := result
					if last_retrieved_object = void then
						if converter.conversion_error_message /= void then
							error_message := converter.conversion_error_message
						end
					end
				else
					create error_message.make_from_string("%NParse error!%N")
					error_message.append(store_handler.parse_error_text)

					print ("%NParse error!")
					print (store_handler.parse_error_text)
				end
			else
				create error_message.make_from_string("%%NData file does not exist!")
				print ("%NData file does not exist! ")
			end

			--reset object id
			set_object_id(-1)
		end

feature --

	not_serialize_type_information is
			-- set serializes no type information
		do
			serialize_no_types := True
		end

	serialize_type_information is
			-- serialize type information
		do
			serialize_no_types := False
		end


	set_object_id (a_type_id:INTEGER) is
			-- sets the object id corresponding to the DT structure to retrieve
		do
			last_set_type_id := a_type_id
		end

feature {NONE} -- implementation

	store_handler: DADL_ENGINE

	converter: DT_OBJECT_CONVERTER

	serialize_no_types: BOOLEAN


	reset is
			-- resets information before parse/store
		do
			create error_message.make_empty
		end

	last_set_type_id: INTEGER
			-- the last object id which was set
			-- this object id i passed to the converter as an argument, which should represent the object id of the DT structure
			-- the converter is going to convert
			-- if no ID is set, the converter will try to read the type from the DT file


end
