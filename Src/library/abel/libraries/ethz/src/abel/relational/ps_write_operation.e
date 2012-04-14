note
	description:
		"[
			This class encapsulates all information needed to perform a write operation.
			Only the values in the `basic_attributes' and `references' lists actually get inserted/updated.
			Any other values that might be present in the object will be ignored (this allows to leave current 
			DB entries "untouched", and later to define non-persistent attributes to an object)

		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_WRITE_OPERATION

inherit
	PS_ABSTRACT_DB_OPERATION

create make_update_operation, make_insert_operation


feature


--	metadata: PS_METADATA

	basic_attributes: LINKED_LIST[STRING]

	basic_attribute_values: HASH_TABLE [ANY, STRING]

	references: LINKED_LIST[STRING]

	reference_values: HASH_TABLE [PS_ABSTRACT_DB_OPERATION, STRING]

	dependencies:LINKED_LIST[PS_ABSTRACT_DB_OPERATION]
		do
			create Result.make
			across references as ref loop Result.extend (reference_values[ref.item]) end
		end


feature {NONE} -- Initialization

	make
		do
			create basic_attributes.make
			create references.make
			create basic_attribute_values.make (hashtable_size)
			create reference_values.make (hashtable_size)
		end

	make_update_operation (an_object: PS_OBJECT_IDENTIFIER_WRAPPER)
		do
			object_id:=an_object
			is_insert:=False
			mode:=Update
			make
		end

	make_insert_operation (an_object: PS_OBJECT_IDENTIFIER_WRAPPER)
		do
			object_id:=an_object
			is_insert:=True
			mode:=Insert
			make
		end


	hashtable_size:INTEGER = 20



end
