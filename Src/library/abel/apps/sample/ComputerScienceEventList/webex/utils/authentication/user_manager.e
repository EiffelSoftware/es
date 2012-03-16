indexing
	description: "Deferred Class that is a template for all User Data Access Classes"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

deferred class
	USER_MANAGER

feature -- Attributes

	user_list: HASH_TABLE[USER, STRING]

	encryptor: ENCRYPTOR
		-- encrypt user login name and password, void to skip encryption

feature --Basic Operations

	add_user (a_user: USER) is
			--adds a user to the userlist
		require
			a_user_valid: a_user /= Void
			user_not_exists: not username_defined(a_user.username)
		do
			user_list.extend(a_user, a_user.username)

		ensure
			one_user_added: user_list.count= old user_list.count + 1
		end

	update_user (a_user: USER) is
			--update a existing user
		require
			a_user_valid: a_user /= Void
			user_exists: username_defined(a_user.username)
		do
			user_list.replace(a_user, a_user.username)

		ensure
			same_user_number: user_list.count= old user_list.count
		end

	delete_user_by_name(username: STRING) is
			--
		require
			username_exists: username /= Void and then not username.is_empty and then user_list.has(username)
		do
			user_list.remove (username)
		ensure
			one_user_removed: user_list.count= old user_list.count - 1
		end


	get_user_by_name (username: STRING): USER is
			-- return the USER object identified by username
		require
			username_exists: username /= Void and then not username.is_empty and then user_list.has(username)
		do
			Result := user_list[username]
		ensure
			user_found: Result /= void
		end

	username_defined (username: STRING): BOOLEAN is
			--adds a user to the userlist
		require
			username_valid: username /= Void and then not username.is_empty
		do
			Result := user_list.has(username)
		end

	is_user_authentication_valid(username, pass: STRING): BOOLEAN is
			-- check user authentication
		require
			name_pass_not_empty: username /= Void and then not username.is_empty and then pass /= void and then not pass.is_empty
		do
			user_list.start
			user_list.search (username)
			if user_list.found then
				if user_list[username].password.is_equal (pass) then
					Result := true
				end
			end
		end

	set_encryptor(cryptor: ENCRYPTOR) is
			-- retrieve the saved session object with given session_id
		do
			encryptor := cryptor
		end

	user_count: INTEGER is
			--
		do
			result := user_list.count
		end



	persist_data deferred
			--persists data in different ways depending on the implementation
		end

invariant
	invariant_clause: True -- Your invariant here
end
