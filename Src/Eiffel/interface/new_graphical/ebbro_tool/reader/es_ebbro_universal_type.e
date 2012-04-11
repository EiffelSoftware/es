indexing
	description: "Describtion of an universal type of an object. Attribute names, types..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_UNIVERSAL_TYPE

create
	make

feature -- creation

	make(an_old_dtype:INTEGER;a_class_name:STRING) is
			-- init generic type
		do
			old_dtype := an_old_dtype
			name := a_class_name
			create attributes.make(10)
		end

feature -- access

	old_dtype:INTEGER
			-- data type identifier in system which stored this object

	name:STRING
			-- name of class

	attributes:ARRAYED_LIST[TUPLE[INTEGER,STRING]]
			-- attributes (old_dtype,attr_name)

feature -- basic operations


	insert_attribute(a_dtype:INTEGER;a_name:STRING) is
			-- insert an attribute
		local
			tuple:TUPLE[INTEGER,STRING]
		do
			create tuple
			tuple.put_integer (a_dtype, 1)
			tuple.put(a_name,2)
			attributes.extend(tuple)
		end

	attribute_count:INTEGER is
			-- how many attributes
		do
			result := attributes.count
		end
end
