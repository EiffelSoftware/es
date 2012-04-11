indexing
	description: "Data Access Objects that serialize data using raw files"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	CONFERENCE_DAO_FILE_IMPL

inherit
	CONFERENCE_DAO
	APPLICATION_CONSTANT

create
	make

feature {NONE} -- Initialization

	make is
			--	Creation procedure. Serialized data are retrieved
		do
			create store_handler
			create accepted_conference_list_data_file.make (Data_Path+Accepted_conference_list_data_file_name)
			create proposed_conference_list_data_file.make (Data_Path+Proposed_conference_list_data_file_name)
			create rejected_conference_list_data_file.make (Data_Path+Rejected_conference_list_data_file_name)
			create conference_id_generator_data_file.make (Data_path+Conference_id_generator_data_file_name)

			create accepted_conference_list_serializer.make (accepted_conference_list_data_file)
			create proposed_conference_list_serializer.make (proposed_conference_list_data_file)
			create rejected_conference_list_serializer.make (rejected_conference_list_data_file)
			create conference_id_generator_serializer.make (conference_id_generator_data_file)

			if accepted_conference_list_data_file.exists then
				accepted_conference_list_data_file.open_read
				accepted_conference_list_serializer.set_for_reading
				accepted_conference_list ?= store_handler.retrieved (accepted_conference_list_serializer,true)
			else
				create accepted_conference_list.make (50)
			end

			if proposed_conference_list_data_file.exists then
				proposed_conference_list_data_file.open_read
				proposed_conference_list_serializer.set_for_reading
				proposed_conference_list ?= store_handler.retrieved (proposed_conference_list_serializer,true)
			else
				create proposed_conference_list.make(50)
			end

			if rejected_conference_list_data_file.exists then
				rejected_conference_list_data_file.open_read
				rejected_conference_list_serializer.set_for_reading
				rejected_conference_list ?= store_handler.retrieved (rejected_conference_list_serializer,true)
			else
				create rejected_conference_list.make(50)
			end

			if conference_id_generator_data_file.exists then
				conference_id_generator_data_file.open_read
				conference_id_generator_serializer.set_for_reading
				conference_id_generator ?= store_handler.retrieved (conference_id_generator_serializer,true)
			else
				create conference_id_generator
			end

		ensure
			accepted_conference_list_exists:accepted_conference_list/=Void
			proposed_conference_list_exists:proposed_conference_list/=Void
			rejected_conference_list_exists:rejected_conference_list/=Void
			conference_id_generator_exists:conference_id_generator/=Void
		end


feature -- Basic operations

		persist_data
				--serializes data
			do
				if accepted_conference_list_data_file.exists then
					accepted_conference_list_data_file.reopen_write (Data_Path+Accepted_conference_list_data_file_name)
				else
					accepted_conference_list_data_file.open_write
				end
				accepted_conference_list_serializer.set_for_writing
				store_handler.independent_store (accepted_conference_list,accepted_conference_list_serializer,true)

				if proposed_conference_list_data_file.exists then
					proposed_conference_list_data_file.reopen_write (Data_Path+Proposed_conference_list_data_file_name)
				else
					proposed_conference_list_data_file.open_write
				end
				proposed_conference_list_serializer.set_for_writing
				store_handler.independent_store (proposed_conference_list,proposed_conference_list_serializer,true)

				if rejected_conference_list_data_file.exists then
					rejected_conference_list_data_file.reopen_write (Data_Path+Rejected_conference_list_data_file_name)
				else
					rejected_conference_list_data_file.open_write
				end
				rejected_conference_list_serializer.set_for_writing
				store_handler.independent_store (rejected_conference_list,rejected_conference_list_serializer,true)

				if conference_id_generator_data_file.exists then
					conference_id_generator_data_file.reopen_write (Data_Path+Conference_id_generator_data_file_name)
				else
					conference_id_generator_data_file.open_write
				end
				conference_id_generator_serializer.set_for_writing
				store_handler.independent_store (conference_id_generator,conference_id_generator_serializer,true)
			end

feature --Access

		store_handler:SED_STORABLE_FACILITIES
		accepted_conference_list_data_file:RAW_FILE
		proposed_conference_list_data_file:RAW_FILE
		rejected_conference_list_data_file:RAW_FILE
		conference_id_generator_data_file:RAW_FILE
		accepted_conference_list_serializer: SED_MEDIUM_READER_WRITER
		proposed_conference_list_serializer: SED_MEDIUM_READER_WRITER
		rejected_conference_list_serializer: SED_MEDIUM_READER_WRITER
		conference_id_generator_serializer: SED_MEDIUM_READER_WRITER

feature -- Initialization

invariant
	invariant_clause: True -- Your invariant here

end
