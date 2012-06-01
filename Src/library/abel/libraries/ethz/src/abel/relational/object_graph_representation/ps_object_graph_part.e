note
	description: "Representation of an object graph part. Its descendants contain all information to perform write operations on databases."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_OBJECT_GRAPH_PART

inherit
	ITERABLE[PS_OBJECT_GRAPH_PART]
	PS_EIFFELSTORE_EXPORT
feature

--	object_id: PS_OBJECT_IDENTIFIER_WRAPPER
		-- The object id of the object to insert/update.

	write_mode: PS_WRITE_OPERATION
		-- Insert, Update, Delete or No_operation mode

	Insert, Update, Delete, No_operation: INTEGER = unique
		-- The different modes


	dependencies: LIST[PS_OBJECT_GRAPH_PART]
		-- All (immediate) parts on which `Current' is dependent on.
		deferred
		end

	remove_dependency (obj:PS_OBJECT_GRAPH_PART)
		-- Remove dependency `obj' from the list
		do
			dependencies.prune (obj)
		end


	is_basic_attribute:BOOLEAN
		-- Is `Current' an instance of PS_BASIC_ATTRIBUTE_PART?
		deferred
		end

	is_visited:BOOLEAN
		-- Has current part been visited?

	set_visited (var:BOOLEAN)
		do
			is_visited:= var
		end


	new_cursor:PS_OBJECT_GRAPH_CURSOR
		do
			create Result.make (Current)
		end

end


