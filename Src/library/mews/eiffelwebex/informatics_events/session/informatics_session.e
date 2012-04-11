indexing
	description: "Objects that wraps up the standard session object for Informatics_event application"
	author: "Peizhu Li, lip@student.ethz.ch"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

class
	INFORMATICS_SESSION

create
	make

feature --attributes

	session: SESSION

feature -- creation
	make(a_session: SESSION) is
			-- create session object with specified name, mail, pass etc information
	do
		session := a_session
	end

feature -- access

	username: STRING is
			-- retrieve username attribute from actual session
		do
			if session.has_attribute ("username") then
				Result := session.get_attribute ("username").out
			else
				Result := ""
			end
		end

	email: STRING is
			-- get email attribute from session
		do
			if session.has_attribute ("email") then
				Result := session.get_attribute ("email").out
			else
				Result := ""
			end
		end


	set_username(name: STRING) is
			-- store username in session
		do
			session.set_attribute ("username", name)
		end

	set_email(mail: STRING) is
			-- store email in session
		do
			session.set_attribute ("email", mail)
		end

invariant
	invariant_clause: True -- Your invariant here

end
