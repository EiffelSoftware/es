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

feature {PS_EIFFELSTORE_EXPORT} -- Access

	represented_object:ANY
		-- The object which gets represented by `Current'
		require
			is_representing_object
		deferred
		end

	metadata:PS_TYPE_METADATA
		-- Some metadata about `represented_object'
		require
			is_representing_object
		do
			Result:= attach (internal_metadata)
		end

	level:INTEGER
		-- The level of the current object graph part.

	write_mode: PS_WRITE_OPERATION
		-- Insert, Update, Delete or No_operation mode

	root: PS_OBJECT_GRAPH_ROOT
		-- The root of the object graph
		deferred
			-- Add this to the creation procedures of the descendants
--			check not_implemented:False end
--			create Result.make
		end

	dependencies: LIST[PS_OBJECT_GRAPH_PART]
		-- All (immediate) parts on which `Current' is dependent on.
		deferred
		end


feature {PS_EIFFELSTORE_EXPORT} -- Status report

	is_persistent:BOOLEAN
		-- Is `Current' already persistent?
		attribute
		ensure
			is_basic_attribute implies not Result
		end


	is_basic_attribute:BOOLEAN
		-- Is `Current' an instance of PS_BASIC_ATTRIBUTE_PART?
		deferred
		end

	is_complex_attribute:BOOLEAN
		-- Is `Current' an instance of PS_COMPLEX_ATTRIBUTE_PART?
		do
			Result:= False
		end

	is_representing_object:BOOLEAN
		-- Is `Current' representing an existing object?
		deferred
		end

	is_visited:BOOLEAN
		-- Has current part been visited?

	is_collection:BOOLEAN
		-- Is `Current' an instance of PS_COLLECTION_PART?
		do
			Result:=False
		end

feature {PS_EIFFELSTORE_EXPORT} -- Utilities

	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		require
			is_representing_object
		do
			if is_basic_attribute then
				create Result.make (basic_attribute_value, metadata.base_class.name)
			else
				create Result.make (optional_primary.out, metadata.base_class.name)
			end
		end

	object_identifier: INTEGER
		-- The object identifier of `Current'. Returns 0 if `Current' is a basic type
		do
			Result:= 0
		ensure
			is_basic_attribute implies Result = 0
			not is_representing_object implies Result = 0
			is_complex_attribute implies Result > 0
		end

	basic_attribute_value: STRING
		-- The value of `Current' as a string.
		require
			is_basic_attribute
		do
			Result:= ""
		end

	to_string:STRING
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Basic operations

	set_visited (var:BOOLEAN)
		do
			is_visited:= var
		end

	remove_dependency (obj:PS_OBJECT_GRAPH_PART)
		-- Remove dependency `obj' from the list
		require
			is_present: dependencies.has (obj)
		do
			dependencies.prune (obj)
		ensure
			not_present: not dependencies.has (obj)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Access: Cursor

	new_cursor:PS_OBJECT_GRAPH_CURSOR
		do
			create Result.make (Current)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Initialization

	initialize (a_level:INTEGER; a_mode:PS_WRITE_OPERATION; disassembler:PS_OBJECT_DISASSEMBLER)
		deferred
		ensure
			is_initialized
		end

	is_initialized:BOOLEAN

feature {NONE} -- Implementation

	internal_metadata: detachable like metadata
		-- A little helper to circumvent void safety
		deferred
		end

invariant
	no_self_dependence: not dependencies.has (Current)
	metadata_attached_if_representing_object: is_representing_object implies attached internal_metadata
	only_complex_attributes_get_written: not is_complex_attribute implies write_mode = write_mode.no_operation

end


