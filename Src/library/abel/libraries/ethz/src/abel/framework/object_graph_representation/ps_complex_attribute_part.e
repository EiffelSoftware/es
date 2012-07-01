note
	description: "Represents an object in the object graph that is not of a basic type."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COMPLEX_ATTRIBUTE_PART

inherit
	PS_OBJECT_GRAPH_PART
	undefine
		remove_dependency
	redefine
		object_identifier,
		is_complex_attribute
	end

feature

	represented_object:ANY
		do
			Result:= object_id.item
		end

	object_id:PS_OBJECT_IDENTIFIER_WRAPPER
		-- The repository-wide unique object identifier of the object represented by `Current'

	object_identifier:INTEGER
	do
		Result:= object_id.object_identifier
	end

	is_basic_attribute:BOOLEAN = False

	is_representing_object:BOOLEAN = True
		-- Is `Current' representing an existing object?


	is_complex_attribute:BOOLEAN
		-- Is `Current' an instance of PS_COMPLEX_ATTRIBUTE_PART?
		do
			Result:= True
		end

	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		do
			create Result.make (optional_primary.out, object_id.metadata.base_class.name)
		end


	to_string:STRING
		do
			Result:= "Complex object: " + object_id.object_identifier.out + "%N"
			across dependencies as dep loop
				if attached{PS_COMPLEX_ATTRIBUTE_PART} dep.item as comp then
					Result := Result +  "%T Reference attribute: " + comp.object_id.object_identifier.out + "%N"
				else
					Result := Result +   "%T " + dep.item.to_string
				end
			end
			if write_mode = write_mode.no_operation then
				Result:= Result +  "%TNo operation%N"
			end
		end

	internal_metadata: detachable like metadata
		do
			Result:= object_id.metadata
		end


end
