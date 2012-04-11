indexing
	description: "Data Access Objects that serialize data using raw files"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	MID_USER_DAO_FILE_IMPL

inherit
	MID_USER_DAO
	APPLICATION_CONSTANT
create
	make

feature {NONE} -- Initialization

	make is
	--		 Creation procedure. Serialized data are retrieved
		do
			create store_handler
			create user_list_data_file.make (Data_Path+Users_file_name2)
			create user_list_serializer.make (user_list_data_file)

			if user_list_data_file.exists then
				user_list_data_file.open_read
				user_list_serializer.set_for_reading
				user_list ?= store_handler.retrieved (user_list_serializer,true)
			else
				create user_list.make(100)
			end
		ensure
			user_list_exists:user_list/=Void
		end


feature -- Basic operations

		persist_data
				--serializes data
			do
				if user_list_data_file.exists then
					user_list_data_file.reopen_write (Data_Path+Users_file_name)
				else
					user_list_data_file.open_write
				end
				user_list_serializer.set_for_writing
				store_handler.independent_store (user_list,user_list_serializer,true)
			end
feature --Access

		store_handler:SED_STORABLE_FACILITIES
		user_list_data_file:RAW_FILE
		user_list_serializer: SED_MEDIUM_READER_WRITER

feature -- Initialization

invariant
	invariant_clause: True -- Your invariant here

end
