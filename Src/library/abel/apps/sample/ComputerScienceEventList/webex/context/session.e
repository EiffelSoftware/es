indexing
	description: "Objects used to hold http session state."
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "20.12.2008"
	revision: "$0.6$"

class
	SESSION
inherit
	ANY

create
	make

feature --attributes

session_id: STRING
	-- save session_id by its own

creation_time: DATE_TIME
	-- session creation timestamp

expiration_time: DATE_TIME
	-- when session will get expired

object_list: HASH_TABLE[ANY, STRING]
	-- user injected objects that need to be saved

feature --creation
	make is
			-- initialize a default session object
		do
			create creation_time.make_now_utc

			create expiration_time.make_now_utc
			-- default valid for 15 minutes
			expiration_time.second_add (15*60)

			create object_list.make(100)
		end


feature -- access

	set_session_id(sid: STRING) is
			-- set session id
	require
		session_id_valid: sid /= void and then not sid.is_empty
	do
		session_id := sid
	end

	set_expiration_time(expiration: DATE_TIME) is
			-- set expiration date
	do
		expiration_time := expiration
	end

	set_expiration_after_seconds(seconds: INTEGER) is
			-- set expiration date to be seconds after now
	do
		creation_time.make_now_utc
		expiration_time.make_now_utc
		expiration_time.second_add(seconds)
	end

	expired: BOOLEAN is
			-- whether session is expired
		local
			now: DATE_TIME
		do
			create now.make_now_utc
			if expiration_time <= now then
				Result := true
			end
		end

	set_attribute(name: STRING; obj: ANY) is
			-- add/update an attribute in session state
		require
			valid_name_is_given: name /= void and not name.is_empty
			valid_object_is_given: obj /= void
		do
			if  object_list.has (name) then
				object_list.replace (obj, name)
			else
				object_list.extend (obj, name)
			end
		end

	delete_attribute(name: STRING) is
			-- delete an attribute from state
		require
			valid_name_is_given: name /= void and not name.is_empty
			attribute_exists: object_list.has (name)
		do
			object_list.remove (name)
		ensure
			one_attribute_deleted: object_list.count = old object_list.count - 1
		end

	get_attribute(name: STRING): ANY is
			-- retrieve an attribute object from current session state, return void if not exist
		require
			valid_name_is_given: name /= void and not name.is_empty
			attribute_exists: object_list.has (name)
		do
			Result := object_list.item(name)
		end

	has_attribute(name: STRING): BOOLEAN is
			-- check whether a specified session object exists
		require
			valid_name_is_given: name /= void and not name.is_empty
		do
			Result := object_list.has (name)
		end

invariant
	invariant_clause: True -- Your invariant here

end
