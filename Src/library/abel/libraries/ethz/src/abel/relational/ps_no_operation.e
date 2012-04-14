note
	description: "Represents a 'no-op', used to just identify objects that already are in database and don't need to be changed."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_NO_OPERATION

inherit
	PS_ABSTRACT_DB_OPERATION

create make

feature {NONE}

	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER)
		-- initialize `Current'
		do
			object_id:=obj
			-- and don't care about is_insert
		end

end
