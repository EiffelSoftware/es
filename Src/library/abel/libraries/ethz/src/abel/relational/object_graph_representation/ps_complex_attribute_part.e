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
	end

feature

	object_id:PS_OBJECT_IDENTIFIER_WRAPPER
		-- The repository-wide unique object identifier of the object represented by `Current'

	is_basic_attribute:BOOLEAN = False


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

end
