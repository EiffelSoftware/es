indexing
	description: "Objects that perform XML RPC calls to Origo through the XML RPC client"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_API_CALLS

inherit
	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature -- Initialisation

	make is
		do

		end

feature -- XML RPC calls

	login is
			-- perform a login
		do

		end

feature {NONE} -- Implementation

	session: STRING
		-- session string


end
