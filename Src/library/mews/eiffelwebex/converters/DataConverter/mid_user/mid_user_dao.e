indexing
	description: "Deferred Class that is a template for all User Data Access Classes"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

deferred class
	MID_USER_DAO

feature -- Access

	user_list:HASH_TABLE[MID_USER,STRING]

feature --Basic Operations

	add_user (a_user:MID_USER)
			--adds a user to the userlist
		require
			a_user_exists: a_user /= Void
		do
			user_list.extend(a_user,a_user.username)
		ensure
			one_user_added: user_list.count= old user_list.count +1
		end

	persist_data deferred
			--persists data in different ways depending on the implementation
		end

invariant
	invariant_clause: True -- Your invariant here
end
