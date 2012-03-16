note
	description: "This class collects all relevant information about inheritance structure and fields in a single class."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_METADATA

create
	make

feature {PS_EIFFELSTORE_EXPORT} -- Access

	parents: LIST [PS_METADATA]
			-- The parents of this class

	children: LIST [PS_METADATA]
			-- The class' children

	name: STRING
			--name of the class

	class_id: INTEGER
			-- id of class, as stored in database	

	attributes: LIST [STRING]
			-- List of name of the attributes

	get_attribute_id (attribute_name: STRING): INTEGER
			-- return the id of the specified attribute, as stored in the database
		do
			Result := private_attr_id_hash [attribute_name]
		end

	get_attribute_type (attribute_name: STRING): PS_METADATA
			-- Get the metadata of the type of the attribute `attribute_name'
		do
			result := private_type_hash [attribute_name].as_attached
		end

feature {PS_EIFFELSTORE_EXPORT} -- Status

	is_basic_type: BOOLEAN
			-- Is `Current' a basic type, i.e. a String, Boolean or Numeric value?


feature {NONE} -- Implementation

	private_attr_id_hash: HASH_TABLE [INTEGER, STRING]

	private_type_hash: HASH_TABLE [PS_METADATA, STRING]

feature {NONE} -- Initialization

	make (class_name: STRING; basic: BOOLEAN)
			-- Initialize `Current'
		do
			create {LINKED_LIST [PS_METADATA]} parents.make
			create {LINKED_LIST [PS_METADATA]} children.make
			create {LINKED_LIST [STRING]} attributes.make
			create private_type_hash.make (50)
			create private_attr_id_hash.make (50)
			name := class_name
			is_basic_type := basic
		end

feature {PS_METADATA_MANAGER} -- Initialization

	set_class_id (i: INTEGER)
			-- Set class id, as stored in the database
		do
			class_id := i
		end

	set_attribute_id (i: INTEGER; attr: STRING)
			-- Set the attribute id, as stored in the database
		do
			private_attr_id_hash.put (i, attr)
		end


	add_attribute (attribute_name: STRING; type: PS_METADATA)
			-- Add an attrubute to the list.
		do
			attributes.extend (attribute_name)
			private_type_hash.put (type, attribute_name)
		end

end
