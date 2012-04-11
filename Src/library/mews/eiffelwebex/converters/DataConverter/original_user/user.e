indexing
	description: "Objects that represents users of a web application."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	USER

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
			username:=""
			password:=""
			first_name:=""
			last_name:=""
			organization:=""
			email:=""
		end

feature -- Access

	--security access data
	username:STRING --for now username is email
	password:STRING

	--personal data
	first_name:STRING -- first name
	last_name:STRING --last name
	organization:STRING --organization
	email: STRING --email


feature -- Status setting

	set_username (a_username: STRING)
			--sets username
		require
			username_has_meaning: a_username/=Void AND THEN (NOT a_username.is_empty)
		do
			username:=a_username
		ensure
			username_is_set: username=a_username
			username_is_email: username=email
		end
---------------------------------------------------------------------------------------
	set_password (a_password: STRING)
			--sets password
		require
			password_has_meaning: a_password/=Void AND THEN (NOT a_password.is_empty)
		do
			password:=a_password
		ensure
			password_is_set: password=a_password
		end
---------------------------------------------------------------------------------------
	set_first_name (a_first_name: STRING)
			--sets first name
		require
			first_name_has_meaning: a_first_name/=Void AND THEN (NOT a_first_name.is_empty)
		do
			first_name:=a_first_name
		ensure
			first_name_is_set: first_name=a_first_name
		end
---------------------------------------------------------------------------------------
	set_last_name (a_last_name: STRING)
			--sets last name
		require
			last_name_has_meaning: a_last_name/=Void AND THEN (NOT a_last_name.is_empty)
		do
			last_name:=a_last_name
		ensure
			last_name_is_set: last_name=a_last_name
		end
---------------------------------------------------------------------------------------
	set_organization (an_organization: STRING)
			--sets organization
		require
			organization_has_meaning: an_organization/=Void AND THEN (NOT an_organization.is_empty)
		do
			organization:=an_organization
		ensure
			organization_is_set: organization=an_organization
		end
---------------------------------------------------------------------------------------
	set_email (an_email: STRING)
			--sets email
		require
			email_has_meaning: an_email/=Void AND THEN (NOT an_email.is_empty)
		do
			email:=an_email
		ensure
			email_is_set: email=an_email
		end
---------------------------------------------------------------------------------------	
invariant
	invariant_clause: True -- Your invariant here
end
