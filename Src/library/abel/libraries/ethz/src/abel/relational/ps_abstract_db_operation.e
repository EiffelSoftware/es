note
	description: "Representation of an abstract operation on the data backend (database)."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_ABSTRACT_DB_OPERATION

feature

	object_id: PS_OBJECT_IDENTIFIER_WRAPPER
	-- The object id of the object to insert/update.

	is_insert:BOOLEAN
	-- Is `Current' an insert operation? If no, it is an update operation

	mode: INTEGER
		-- Insert, Update or Delete mode

	Insert, Update, Delete : INTEGER = unique
		-- The different modes


	dependencies: LIST[PS_ABSTRACT_DB_OPERATION]
		-- All the operations on which `Current' is dependent on.
		deferred
		end



end


