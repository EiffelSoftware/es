indexing
	description: "Objects that wraps up the standard session object for ZENGARDEN application"
	author: "Peizhu Li, lip@student.ethz.ch"
	date: "$Date$"
	revision: "$0.3.1$"

class
	ZEN_SESSION
create
	make

feature --attributes

	session: SESSION -- a reference to actual session object?

	username: STRING is
			--
		do
			if session.has_attribute ("username") then
				Result := session.get_attribute ("username").out
			else
				Result := "Guest"
			end
		end
	email: STRING is
			--
		do
			if session.has_attribute ("email") then
				Result := session.get_attribute ("email").out
			else
				Result := ""
			end
		end

	page: INTEGER is
			--
		do
			if session.has_attribute ("page") then
				Result := session.get_attribute ("page").out.to_integer
			else
				Result := 1
			end
		end

	css_id: INTEGER is
			--
		do
			if session.has_attribute ("css_id") then
				Result := session.get_attribute ("css_id").out.to_integer
			else
				Result := 1
			end
		end


	authenticated: BOOLEAN is
			-- whether user authenticated yet
		do
			Result:= not username.is_equal("Guest")
		end


feature -- creation
	make(a_session: SESSION) is
			-- get a reference to actual session object
	do
		session := a_session
	end


feature -- access

	set_username(name: STRING) is
			--
	do
		session.set_attribute ("username", name)
	end

	set_email(mail: STRING) is
			--
	do
		session.set_attribute ("email", mail)
	end

	set_page(a_page: INTEGER) is
			--
	do
		session.set_attribute ("page", a_page.out)
	end

	set_css_id(cid: INTEGER) is
			--
	do
		session.set_attribute ("css_id", cid.out)
	end


invariant
	invariant_clause: True -- Your invariant here

end
