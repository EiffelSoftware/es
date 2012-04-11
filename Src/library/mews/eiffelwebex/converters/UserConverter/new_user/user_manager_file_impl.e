indexing
	description: "Data Access Objects that serialize data using raw files"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	USER_MANAGER_FILE_IMPL

inherit
	USER_MANAGER
create
	make

feature -- attributes
	data_path: STRING
		-- where to save user list
	file_name: STRING
		-- where to save user list

feature {NONE} -- Initialization

	make(folder, filename: STRING; cryptor: ENCRYPTOR) is
			-- Creation procedure. Serialized data are retrieved
		require
			file_path_valid: folder /= void and then not folder.is_empty and then filename /= void and then not filename.is_empty
			encryptor_valid: cryptor /= void
		local
			user: USER
		do
			create data_path.make_from_string (folder)
			create file_name.make_from_string (filename)
			set_encryptor(cryptor)

			create store_handler
			create user_list_data_file.make (data_path+file_name)
			create user_list_serializer.make (user_list_data_file)

			if user_list_data_file.exists then
				user_list_data_file.open_read
				user_list_serializer.set_for_reading
				user_list ?= store_handler.retrieved (user_list_serializer,true)

				if encryptor /= void then
					from user_list.start
					until user_list.after
					loop
						user := user_list.item (user_list.key_for_iteration)
						user.set_password(encryptor.decrypt(user.password))
						user_list.replace (user, user_list.key_for_iteration)
						user_list.forth
					end
				end
			else
				create user_list.make(100)
			end
		ensure
			user_list_exists:user_list/=Void
		end


feature -- Basic operations

	persist_data
			--serializes data
		local
			user: USER
		do
			if encryptor /= void then
				from user_list.start
				until user_list.after
				loop
					user := user_list.item (user_list.key_for_iteration)
					user.set_password(encryptor.encrypt(user.password))
					user_list.replace (user, user_list.key_for_iteration)
					user_list.forth
				end
			end

			if user_list_data_file.exists then
				user_list_data_file.reopen_write (data_path + file_name)
			else
				user_list_data_file.open_write
			end
			user_list_serializer.set_for_writing
			store_handler.independent_store (user_list,user_list_serializer,true)
		end

feature {NONE} -- implementation

		store_handler:SED_STORABLE_FACILITIES
		user_list_data_file:RAW_FILE
		user_list_serializer: SED_MEDIUM_READER_WRITER

invariant
	invariant_clause: True -- Your invariant here

end
