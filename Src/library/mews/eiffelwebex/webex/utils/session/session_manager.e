indexing
	description: "Objects help retrieving/saving/deleting sessions"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "05.01.2008"
	revision: "$0.6$"

deferred class
	SESSION_MANAGER

feature -- attributes	

	session_id_length: INTEGER
		-- number of digits/characters used for session id

feature {SESSION_MANAGER} -- attributes	

	random_number_generator: RANDOM
		-- generate new session id

	last_random: INTEGER
		-- last generated string, used as next seed

feature -- operations

	generate_session_id: STRING is
			-- generate a new session id
		local
			int_formatter: FORMAT_INTEGER
		do
			make_random_number

			create int_formatter.make(last_random)
			int_formatter.set_width (session_id_length)
			int_formatter.set_fill ('0')
			int_formatter.zero_fill
			create Result.make_from_string(int_formatter.formatted (last_random).out)
			check
				session_id_width_ok: Result.count = session_id_length
			end

		end


	get_session(sid: STRING): SESSION is
			-- retrieve the saved session object with given session_id
			-- otherwise return void
		require
			sid_session_valid: sid /= void and then not sid.is_empty
		deferred
		end


	save_session(sid: STRING; session: SESSION) is
			-- save given session information
		require
			sid_session_valid: sid /= void and then not sid.is_empty and then session /= void
		deferred
		end

	delete_session(sid: STRING) is
			-- delete a session based on given id
		deferred
		end


	cleanup is
			-- consolidate saved session information, clean-up expired/invalid sessions in storage (files/db)
		deferred
		end

feature {NONE} -- Implementation

	init_manager(expiration, sid_length: INTEGER) is
			-- initialize random_number_generator and last_random
		local
			time: TIME
				-- initial seed for RANDOM object
		do
			create time.make_now
			create random_number_generator.set_seed (time.milli_second)
			last_random := random_number_generator.next_random(time.milli_second)

			session_id_length := sid_length
		end

	make_random_number is
			-- make a new random number and store it in 'last_random'
		do
			last_random := random_number_generator.next_random (last_random)
		end


invariant
	invariant_clause: True -- Your invariant here

end
