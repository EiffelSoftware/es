note
	description: "[
		Represents a repository query that returns data tuples of objects.
		Please note that you cannot update or insert data tuples of objects into the repository.
		
		You can set a projection on the attributes you would like to have, to restrict the amount of data that is going to be retrieved.
		You'll get completely loaded objects as attributes if you include an attribute in your projection that is not of a basic type (strings and numbers)
	]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TUPLE_QUERY [G -> ANY]

inherit

	PS_QUERY [G]

	ITERABLE [TUPLE]

create
	make

feature -- Access

	result_cursor: PS_RESULT_SET [TUPLE]
			-- Iteration cursor containing the result of the query.

feature -- Status report

	is_object_query: BOOLEAN = False
			-- Is `Current' an instance of PS_OBJECT_QUERY?

feature -- Projections

	projection: ARRAY [STRING]
			-- Data to be included for projection. Defaults to all basic types: numbers and strings

	default_projection: ARRAY [STRING]
			-- An array containing all the attribute names that are of a basic type.
		local
			reflection: INTERNAL
			instance: ANY
			field: detachable ANY
			i, j, num_fields: INTEGER
			field_type, string_type: INTEGER
		do
			create reflection
			instance := reflection.new_instance_of (reflection.generic_dynamic_type (Current, 1))
				--reflection.dynamic_type_from_string (class_name))
			num_fields := reflection.field_count (instance)
			create Result.make_filled (create {STRING}.make_empty, 1, num_fields)
			from
				i := 1
				j := 1
			until
				i > num_fields
			loop
				field := reflection.field (i, instance)
				if attached {NUMERIC} field or attached {BOOLEAN} field then
					Result.put (reflection.field_name (i, instance), j)
					j := j + 1
				else
					field_type := reflection.field_static_type_of_type (i, reflection.dynamic_type (instance))
					string_type := reflection.dynamic_type_from_string ("READABLE_STRING_GENERAL")
						--print (field_type.out + " " + string_type.out + "%N")
					if reflection.field_conforms_to (field_type, string_type) then
						Result.put (reflection.field_name (i, instance), j)
						j := j + 1
					end
				end
				i := i + 1
			end
		end

	set_projection (a_projection: ARRAY [STRING])
			-- Set `a_projection' to the current query.
		do
			projection := a_projection
		ensure
			projected_data_set: projection = a_projection
		end

feature -- Cursor generation

	new_cursor: PS_RESULT_SET [TUPLE]
			-- Return the result_cursor
		do
			Result := result_cursor
		end

feature {NONE} -- Initialization

	make
			-- Create an new query on objects of type `G'.
		do
			create projection.make_empty -- some stupid void safety rule...
			initialize
			create projection.make_from_array (default_projection)
		ensure then
			projection_correctly_initialized: projection = default_projection
		end

	create_result_cursor
			-- Create a new result set
		do
			create result_cursor.make
		end

end
