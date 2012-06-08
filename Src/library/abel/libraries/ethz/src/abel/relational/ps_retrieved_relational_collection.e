note
	description: "Summary description for {PS_RETRIEVED_RELATIONAL_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RETRIEVED_RELATIONAL_COLLECTION

inherit
	PS_RETRIEVED_COLLECTION

create make

feature -- Relational collection specific features

	owner_key: INTEGER

	owner_type: PS_CLASS_METADATA

	owner_attribute_name: STRING



feature {NONE}

	make (o_key: INTEGER; o_type: PS_CLASS_METADATA; o_attr_name: STRING)
		do
			owner_key:= o_key
			owner_type:= o_type
			owner_attribute_name:= o_attr_name

			create collection_items.make
		end

end
