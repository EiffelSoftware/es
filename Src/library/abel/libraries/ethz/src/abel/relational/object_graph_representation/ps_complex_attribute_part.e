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

end
