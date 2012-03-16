indexing
	description: "Data Access Objects that serialize data using raw files"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	EVENT_DAO_FILE_IMPL

inherit
	EVENT_DAO

create
	make

feature -- attributes
	Data_path: STRING
			-- directory to save all these conference data files

	events_file_name, id_file_name: STRING
			-- file names

feature --Access

		store_handler:SED_STORABLE_FACILITIES
		events_data_file:RAW_FILE
		event_id_generator_data_file:RAW_FILE
		events_serializer: SED_MEDIUM_READER_WRITER
		event_id_generator_serializer: SED_MEDIUM_READER_WRITER

feature {NONE} -- Initialization

	make(path, event_fname, id_fname: STRING) is
			--	Creation procedure. Serialized data are retrieved
		do
			create Data_path.make_from_string (path)
			create events_file_name.make_from_string (event_fname)
			create id_file_name.make_from_string (id_fname)

			create store_handler
			create events_data_file.make (Data_Path+events_file_name)
			create event_id_generator_data_file.make (Data_path+id_file_name)

			create events_serializer.make (events_data_file)
			create event_id_generator_serializer.make (event_id_generator_data_file)

			if events_data_file.exists then
				events_data_file.open_read
				events_serializer.set_for_reading
				event_list ?= store_handler.retrieved (events_serializer,true)
				events_data_file.close
			else
				create event_list.make (50)
			end

			if event_id_generator_data_file.exists then
				event_id_generator_data_file.open_read
				event_id_generator_serializer.set_for_reading
				event_id_generator ?= store_handler.retrieved (event_id_generator_serializer,true)
				event_id_generator_data_file.close
			else
				create event_id_generator
			end

		ensure
			event_list_exists:event_list/=Void
			event_id_generator_exists:event_id_generator/=Void
		end


feature -- Basic operations

		persist_data
				--serializes data
			do
				if events_data_file.is_open_read then
					events_data_file.reopen_write (Data_Path+events_file_name)
				elseif events_data_file.is_open_append or events_data_file.is_open_write then
					-- how to wait?
					events_data_file.reopen_write (Data_Path+events_file_name)
				elseif events_data_file.exists then
					events_data_file.open_write
				else
					events_data_file.create_read_write
				end

				events_serializer.set_for_writing
				store_handler.independent_store (event_list,events_serializer,true)
				events_data_file.close

				if event_id_generator_data_file.is_open_read then
					event_id_generator_data_file.reopen_write (Data_Path+id_file_name)
				elseif event_id_generator_data_file.is_open_append or event_id_generator_data_file.is_open_write then
					-- how to wait?
					event_id_generator_data_file.reopen_write (Data_Path+id_file_name)
				elseif event_id_generator_data_file.exists then
					event_id_generator_data_file.open_write
				else
					event_id_generator_data_file.create_read_write
				end
				event_id_generator_serializer.set_for_writing
				store_handler.independent_store (event_id_generator,event_id_generator_serializer,true)
				event_id_generator_data_file.close
			end

feature -- Initialization

invariant
	invariant_clause: True -- Your invariant here

end
