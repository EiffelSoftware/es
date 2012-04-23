note
	description: "Represents a collection in an object graph."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[ANY]]
inherit
	PS_COMPLEX_ATTRIBUTE_PART

create make

feature

	are_items_of_basic_type:BOOLEAN
		-- are the current collection's items of a basic type?
	require
		not values.is_empty
	do
		Result:= values.at (1).is_basic_attribute
	end

	reference_owner:PS_OBJECT_GRAPH_PART
		-- An object that holds a reference to `Current.object_id'
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)

	reference_owner_attribute_name: STRING
		-- The attribute name of the reference_owner of the current collection.
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)


	is_in_relational_mode:BOOLEAN
		-- Is current collection inserted in relational mode?

	values:LINKED_LIST[PS_OBJECT_GRAPH_PART]

	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		do
			create Result.make
			Result.append(values)

			if is_in_relational_mode then
				Result.extend (reference_owner)
			end
		end


feature {NONE} -- Initialization

	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER; owner: PS_OBJECT_GRAPH_PART; attr_name: STRING ; a_mode:INTEGER; is_relational:BOOLEAN)
		-- initialize `Current'
		do
			object_id:=obj
			reference_owner:= owner
			reference_owner_attribute_name:= attr_name
			write_mode:= a_mode
			create values.make
--			create_other_attributes
		end


-- Collections: All collections have a single poid of the object they "belong" to, and several referenced poids. They also have an attribute name.

-- How to model collections of basic types? - probably different insert strategies, so treat them differently: deferred classes PS_BASIC_TYPE_WRITE_COLLECTION and PS_REFERENCE_TYPE_WRITE_COLLECTION

-- Another funny thing: collections of collections like LIST[LIST[ANY]]... Make Collections "first-level citizens" with their own poid? Might be the best solution...
-- This will also easily allow to store plain lists as objects.


invariant
	same_types: dependencies.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)  or not dependencies.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)


end
