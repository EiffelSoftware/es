indexing
	description: "Objects that represents an user of the informatics_event application."
	author: "Peizhu Li"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	INFORMATICS_USER

inherit
	USER
	redefine
		make
	end
	APPLICATION_CONSTANTS

create
	make

feature -- Access

	--personal data
	first_name:STRING -- first name
	last_name:STRING --last name
	organization:STRING --organization
	email: STRING --email
	telephone: STRING --phone
	role: INTEGER --role of current user, should be a enum type
	status: INTEGER  -- deleted, blocked

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
			PRECURSOR
			first_name:=""
			last_name:=""
			organization:=""
			email:=""
			telephone:=""
			role:= ROLE_GUEST
		end

feature -- Status setting

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
	set_telephone (an_phone: STRING)
			--sets telephone
		require
--			phone_has_meaning: an_phone/=Void AND THEN (NOT an_phone.is_empty)
		do
			telephone:=an_phone
		ensure
			phone_is_set: telephone=an_phone
		end
---------------------------------------------------------------------------------------	
	set_role (a_role: INTEGER)
			--sets role
		require
			role_has_meaning: a_role >= 0
		do
			role:=a_role
		ensure
			role_is_set: role=a_role
		end
----------------------------------------------------------------------------------------	
	set_status (a_status: INTEGER)
			--sets status
		require
			status_has_meaning: a_status >= 0
		do
			status:=a_status
		ensure
			status_is_set: status=a_status
		end
---------------------------------------------------------------------------------------	
invariant
	invariant_clause: True -- Your invariant here
end

