indexing
	description: "Objects implemented SESSION_MANAGER based on serialized sessions (file storage)"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "05.01.2008"
	revision: "$0.6$"

class
	SESSION_MANAGER_FILE_IMPL
inherit
	SESSION_MANAGER

create
	make

feature -- attributes	
	session_path: STRING
		-- path that stores all session files

feature  -- make

	make(path: STRING; expiration, sid_length: INTEGER) is
			-- init session path
		local
--			dir: DIRECTORY
		do
			init_manager(expiration, sid_length)

			create session_path.make_from_string(path)
			if session_path.item (session_path.count) /= '/' then
				session_path.extend ('/')
			end

--			create dir.make (session_path)
--			if not dir.exists then
--				log.writeln ("[INFO] session manager dir not exists = " + session_path)
--				dir.create_dir
--			end
		end

feature -- operations

	get_session(sid: STRING): SESSION is
			-- retrieve the saved session object with given session_id
			-- otherwise return void
		require else
			session_id_valid: sid /= void and then not sid.is_empty
			path_initialized: session_path /= void and then not session_path.is_empty
		local
			session: SESSION
			session_file: RAW_FILE
		do
			create session_file.make (session_path + sid)
			if session_file.exists then
				session := initialize_from_file(session_file)
				Result ?= session
			else
				Result := void
			end
		end

	save_session(sid: STRING; session: SESSION) is
			-- save given session information
		require else
			session_and_id_valid: sid /= void and then not sid.is_empty and then session /= void
			path_initialized: session_path /= void and then not session_path.is_empty
		local
			session_file: RAW_FILE
		do
			create session_file.make (session_path + sid)
			save_to_file(session, session_file)
		end

	delete_session(sid: STRING) is
			-- delete a session based on given id
		require else
			session_id_valid: sid /= void and then not sid.is_empty
			path_initialized: session_path /= void and then not session_path.is_empty
		local
			session_file: RAW_FILE
		do
			create session_file.make (session_path + sid)
			if session_file.exists then
				session_file.delete
			end
		end


	cleanup is
			-- consolidate saved session information, clean-up expired/invalid sessions in storage (files/db)
		require else
			path_initialized: session_path /= void and then not session_path.is_empty
		local
			dir: DIRECTORY
			session: SESSION
			session_file: RAW_FILE
		do
			create dir.make_open_read (session_path)

			from dir.start until dir.lastentry.is_empty
			loop
				create session_file.make (session_path + dir.lastentry)

				if session_file.exists then
					session := initialize_from_file(session_file)
					if session.expired then
						session_file.delete
					end
				end
				dir.readentry
			end

			dir.close
		end

feature {NONE}  -- persist file storage

	initialize_from_file(session_file: RAW_FILE): SESSION is
			-- retrieve session object from serialized file
		require
			session_file_exists: session_file.exists
		local
			store_handler: SED_STORABLE_FACILITIES
			session_serializer: SED_MEDIUM_READER_WRITER
			session: SESSION
		do
			create store_handler
			create session_serializer.make (session_file)

			session_file.open_read
			session_serializer.set_for_reading
			session ?= store_handler.retrieved (session_serializer, true)

			check
				read_ok: session /= void
			end

			check
				session_initialized: session /= Void
			end

			session_file.close

			Result := session

		end

	save_to_file(session: SESSION; session_file: RAW_FILE) is
			-- save session object to file
		local
			store_handler: SED_STORABLE_FACILITIES
			session_serializer: SED_MEDIUM_READER_WRITER
		do
			create store_handler
			create session_serializer.make (session_file)

			session_file.open_write

			session_serializer.set_for_writing
			store_handler.independent_store(session, session_serializer, true)

			session_file.flush

			session_file.close

		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
