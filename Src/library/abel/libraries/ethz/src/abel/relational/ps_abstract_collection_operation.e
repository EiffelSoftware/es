note
	description: "Represents an abstract operation on the database that handles collections."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_ABSTRACT_COLLECTION_OPERATION [COLLECTION_TYPE -> ITERABLE[ANY]]
inherit
	PS_ABSTRACT_DB_OPERATION

feature

	is_of_basic_type:BOOLEAN
		-- is the current collection's generic paameter of a basic type?
	deferred
	end

	reference_owner:PS_ABSTRACT_DB_OPERATION
		-- An object that holds a reference to `Current.object_id'
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)

	reference_owner_attribute_name: STRING
		-- The attribute name of the reference_owner of the current collection.
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)


	is_in_relational_mode:BOOLEAN
		-- Is current collection inserted in relational mode?

feature {NONE} -- Initialization

	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER; owner: PS_ABSTRACT_DB_OPERATION; attr_name: STRING ; a_mode:INTEGER; is_relational:BOOLEAN)
		-- initialize `Current'
		do
			object_id:=obj
			reference_owner:= owner
			reference_owner_attribute_name:= attr_name
			mode:= a_mode
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
