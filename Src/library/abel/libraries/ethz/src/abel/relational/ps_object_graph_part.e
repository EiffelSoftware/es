note
	description: "Representation of an object graph part. Its descendants contain all information to perform write operations on databases."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_OBJECT_GRAPH_PART

feature

--	object_id: PS_OBJECT_IDENTIFIER_WRAPPER
		-- The object id of the object to insert/update.

	write_mode: INTEGER
		-- Insert, Update, Delete or No_operation mode

	Insert, Update, Delete, No_operation: INTEGER = unique
		-- The different modes


	dependencies: LIST[PS_OBJECT_GRAPH_PART]
		-- All (immediate) parts on which `Current' is dependent on.
		deferred
		end


	is_basic_attribute:BOOLEAN
		-- Is `Current' an instance of PS_BASIC_ATTRIBUTE_PART?
		deferred
		end


end


