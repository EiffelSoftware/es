indexing
	description: "Objects that represents a general/basic user acount of a web application, which focuses on authentication"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	USER

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize
		do
			username:=""
			password:=""
		end

feature -- Access

	--security access data
	username:STRING
	password:STRING

feature -- Status setting

	set_username (a_username: STRING)
			--sets username
		require
			username_has_meaning: a_username/=Void and then (not a_username.is_empty)
		do
			username:=a_username
		ensure
			username_is_set: username=a_username
		end

	set_password (a_password: STRING)
			--sets password
		require
			password_has_meaning: a_password/=Void and then (not a_password.is_empty)
		do
			password:=a_password
		ensure
			password_is_set: password=a_password
		end


invariant
	invariant_clause: True -- Your invariant here
end
