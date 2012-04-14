note
	description: "Represents an abstract operation on the database that handles collections."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_ABSTRACT_COLLECTION_OPERATION
inherit
	PS_ABSTRACT_DB_OPERATION

feature

	is_of_basic_type:BOOLEAN
		-- is the current collection's generic paameter of a basic type?
	deferred
	end

	parent_id: PS_OBJECT_IDENTIFIER_WRAPPER
		-- the object that this collection is embedded in.

	parent_attribute_name: STRING
		-- The attribute name of the current collection.


feature {NONE} -- Initialization

	make (obj, parent: PS_OBJECT_IDENTIFIER_WRAPPER ; attr_name: STRING ; write_mode:INTEGER)
		-- initialize `Current'
		do
			object_id:=obj
			parent_id:= parent
			parent_attribute_name:= attr_name
			mode:= write_mode
			create_other_attributes
		end

	create_other_attributes
		-- create other attributes defined in this class
		deferred
		end

-- Collections: All collections have a single poid of the object they "belong" to, and several referenced poids. They also have an attribute name.

-- How to model collections of basic types? - probably different insert strategies, so treat them differently: deferred classes PS_BASIC_TYPE_WRITE_COLLECTION and PS_REFERENCE_TYPE_WRITE_COLLECTION

-- Another funny thing: collections of collections like LIST[LIST[ANY]]... Make Collections "first-level citizens" with their own poid? Might be the best solution...
-- This will also easily allow to store plain lists as objects.


-- possible class hierarchy:

-- PS_ABSTRACT_DB_OPERATION feature object_id, is_update_operation
-- PS_ABSTRACT_COLLECTION_OP feature is_basic_type, object_parent, object_parent_attributename
-- PS_BASIC_COLLECTION_WRITE feature values:LIST[ANY]
-- PS_REFERENCE_COLLECTION_WRITE feature references:LIST[PS_DB_OPERATION]
-- PS_OBJECT_WRITE_OPERATION features as above
-- PS_ID_ONLY -- no feature
end
